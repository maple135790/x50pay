import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_data.dart';
import 'package:x50pay/repository/repository.dart';

mixin NfcPayMixin {
  final _repo = Repository();

  Future<void> handleNfcPay({
    required String mid,
    required String cid,
    required Function(QRPayData qrPayData) onCabSelect,
    required VoidCallback onPaymentDone,
    required bool isPreferTicket,
    bool? isNfcAutoOn,
  }) async {
    if (cid == '703765460') cid = '70376560';
    final url = 'https://pay.x50.fun/nfcpay/$mid/$cid';
    isNfcAutoOn ??= await _getNfcAutoSetting();

    if (isNfcAutoOn) {
      final isEnableFastNfcPay = await _checkEnableFastNfcPay();
      if (isEnableFastNfcPay) {
        log('FastQRPay enabled', name: 'NfcPayMixin._handleFastQRPayment');
        _handleFastQRPayment(mid, cid, isPreferTicket);
      } else {
        final rawDoc = await _getNfcPayDocument(url);
        _handlePayment(rawDoc, mid, cid);
      }
      onPaymentDone.call();
    } else {
      final qrPayData = await _getQRPayData(url);
      onCabSelect.call(qrPayData);
    }
  }

  Future<bool> _getNfcAutoSetting() async {
    final accountViewModel = AccountViewModel();
    final settings = await accountViewModel.getPaymentSettings();
    return settings.nfcAuto;
  }

  void _handlePayment(String rawDoc, String mid, String cid) async {
    assert(rawDoc.contains('付款中...'));

    try {
      final prePayUrl =
          rawDoc.split('location.replace("').last.split('")').first;
      if (prePayUrl.isEmpty) throw Exception('payUrl is empty');
      final prePaymentDoc = await _repo.getDocumentWithDomainPrefix(
        prePayUrl,
        'https://pay.x50.fun/mid/$mid/$cid',
        descLabel: '取得支付前的頁面',
      );
      final payUrl =
          prePaymentDoc.split("\$.post('")[1].split("',function").first;
      if (payUrl.isEmpty) throw Exception('payUrl is empty');

      _doInsert(payUrl);
    } on Exception catch (e) {
      log('', error: e, name: 'QRPayViewModel.handlePayment');
      rethrow;
    }
  }

  void _doInsert(String url) async {
    log('https://pay.x50.fun$url');
    // await CabSelectViewModel().doInsertQRPay(url: 'https://pay.x50.fun$url');
    return;
  }

  void _handleFastQRPayment(String mid, String cid, bool isPreferTicket) async {
    // 0mu 做 QRCode 的時候打錯了，所以要做轉換
    if (cid == '703765460') cid = '70376560';
    if (isPreferTicket) {
      _doInsert('/api/v1/tic/$mid/$cid/0');
    } else {
      _doInsert('/api/v1/pay/$mid/$cid/0');
    }
  }

  Future<bool> _checkEnableFastNfcPay() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('fastQRPay') ?? false;
  }

  Future<String> _getNfcPayDocument(String url) async {
    late final String rawDoc;
    if (!kDebugMode) {
      rawDoc = await _repo.getQRPayDocument(url);
    } else {
      rawDoc = await rootBundle.loadString('assets/tests/scan_pay_x50pay.html');
    }
    return rawDoc;
  }

  Future<QRPayData> _getQRPayData(String url) async {
    try {
      final rawDoc = await _getNfcPayDocument(url);
      final doc = parse(rawDoc);
      final imageUrl =
          doc.querySelector('body > div > a > div > img')!.attributes['src']!;
      final cabName =
          doc.querySelector('body > div > a > div > div')!.text.trim();
      final cabNum = doc
          .querySelector(
              'body > div > div.center.aligned.content > div > div > div.header > strong')!
          .text
          .trim()
          .split(' ')[1];
      final rawScript = doc.querySelectorAll("body > script")[3].text.trim();
      final rawModes = doc.querySelectorAll(
          "body > div > div.center.aligned.content > div > div > p");
      List<List<dynamic>> modes = [];
      for (var rawMode in rawModes) {
        final modeName = rawMode.text.trim();
        String pointPrice = '';
        String pointPayUrl = '';
        String ticketPayUrl = '';
        for (var rawButton
            in rawMode.nextElementSibling!.children.first.children) {
          String id = '';
          bool isPointBtn = false;

          id = "\"#${rawButton.attributes['id']!.split('-').first}\"";
          isPointBtn = rawButton.text.contains('P');
          if (isPointBtn) {
            pointPrice = rawButton.text.trim().replaceAll('P', '');
          }
          final url = rawScript
              .split(id)[1]
              .split(' });\n});')
              .first
              .split("\$.post(")[1]
              .split('\'')[1];
          if (isPointBtn) {
            pointPayUrl = url;
          } else {
            ticketPayUrl = url;
          }
        }

        modes.add([
          [pointPayUrl, ticketPayUrl],
          modeName,
          pointPrice,
        ]);
      }
      return QRPayData(
        rawGameCabImageUrl: imageUrl,
        cabLabel: cabName,
        cabNum: int.parse(cabNum),
        mode: modes,
      );
    } on Exception catch (e, stacktrace) {
      log('',
          error: e, stackTrace: stacktrace, name: 'NfcPayMixin._getQRPayData');
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
