import 'dart:developer';

import 'package:html/parser.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/page/scan/qr_pay/cab_payment_result.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_data.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/main_repository/repository.dart';
import 'package:x50pay/repository/setting_repository/setting_repository.dart';
import 'package:x50pay/service/game_insert_service.dart';

mixin NfcPayMixin {
  Repository get repository;
  GameInsertService get gameInsertService;

  Future<CabPaymentResult> handleNfcPay({
    required String mid,
    required String cid,
    required SettingRepository settingRepo,
    required bool isPreferTicket,
    required Repository repository,
    bool? isNfcAutoOn,
  }) async {
    if (cid == '703765460') cid = '70376560';
    final url = 'https://pay.x50.fun/nfcpay/$mid/$cid';
    isNfcAutoOn ??= await _getNfcAutoSetting(settingRepo);

    if (isNfcAutoOn) {
      final isEnableFastNfcPay = await _checkEnableFastNfcPay();
      if (isEnableFastNfcPay) {
        log('FastQRPay enabled', name: 'NfcPayMixin._handleFastQRPayment');
        await _handleFastQRPayment(mid, cid, isPreferTicket);
      } else {
        final rawDoc = await _getNfcPayDocument(url);
        await _handlePayment(rawDoc, mid, cid);
      }
      return const CabPaymentCompleted();
    } else {
      final qrPayData = await _getQRPayData(url);
      return CabPaymentNeedsSelection(qrPayData);
    }
  }

  Future<bool> _getNfcAutoSetting(SettingRepository settingRepo) async {
    final accountViewModel = SettingsViewModel(settingRepo: settingRepo);
    final settings = await accountViewModel.getPaymentSettings();
    return settings.nfcAuto;
  }

  Future<void> _handlePayment(String rawDoc, String mid, String cid) async {
    try {
      final prePayUrl = rawDoc
          .split('location.replace("')
          .last
          .split('")')
          .first;
      if (prePayUrl.isEmpty) throw Exception('payUrl is empty');
      final prePaymentDoc = await repository.getDocumentWithDomainPrefix(
        prePayUrl,
        'https://pay.x50.fun/mid/$mid/$cid',
        descLabel: '取得支付前的頁面',
      );
      final payUrl = prePaymentDoc
          .split("\$.post('")[1]
          .split("',function")
          .first;
      if (payUrl.isEmpty) throw Exception('payUrl is empty');

      await _doInsert(payUrl);
    } catch (e) {
      log('', error: e, name: 'NfcPayMixin.handlePayment');
      rethrow;
    }
  }

  Future<void> _doInsert(String url) async {
    log('https://pay.x50.fun$url', name: 'NfcPayMixin._doInsert');
    await gameInsertService.doInsertQRPay(url: 'https://pay.x50.fun$url');
  }

  Future<void> _handleFastQRPayment(
    String mid,
    String cid,
    bool isPreferTicket,
  ) async {
    // 0mu 做 QRCode 的時候打錯了，所以要做轉換
    if (cid == '703765460') cid = '70376560';
    if (isPreferTicket) {
      await _doInsert('/api/v1/tic/$mid/$cid/0');
    } else {
      await _doInsert('/api/v1/pay/$mid/$cid/0');
    }
  }

  Future<bool> _checkEnableFastNfcPay() async {
    final enabled = await Prefs.getBool(PrefsToken.enabledFastQRPay);
    return enabled ?? false;
  }

  Future<String> _getNfcPayDocument(String url) async {
    late final String rawDoc;
    rawDoc = await repository.getQRPayDocument(url);
    return rawDoc;
  }

  Future<QRPayData> _getQRPayData(String url) async {
    try {
      final rawDoc = await _getNfcPayDocument(url);
      final doc = parse(rawDoc);
      final imageUrl = doc
          .querySelector('body > div > a > div > img')!
          .attributes['src']!;
      final cabName = doc
          .querySelector('body > div > a > div > div')!
          .text
          .trim();
      final cabNum = doc
          .querySelector(
            'body > div > div.center.aligned.content > div > div > div.header > strong',
          )!
          .text
          .trim()
          .split(' ')[1];
      final rawScript = doc.querySelectorAll("body > script")[3].text.trim();
      final rawModes = doc.querySelectorAll(
        "body > div > div.center.aligned.content > div > div > p",
      );
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
    } catch (e, stacktrace) {
      log(
        '',
        error: e,
        stackTrace: stacktrace,
        name: 'NfcPayMixin._getQRPayData',
      );
      rethrow;
    }
  }
}
