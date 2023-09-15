import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/mixins/nfc_pay_mixin.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_data.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/repository.dart';

typedef QRPayTPPRedirect = ({QRPayTPPRedirectType type, String url});

class QRPayViewModel extends BaseViewModel with NfcPayMixin {
  final String mid;
  final String cid;
  final void Function(QRPayData qrPayData) onCabSelect;
  final VoidCallback onPaymentDone;

  QRPayViewModel({
    required this.mid,
    required this.cid,
    required this.onCabSelect,
    required this.onPaymentDone,
  });

  final _repo = Repository();
  late final PaymentSettingsModel currentPaymentSettings;
  late final bool _enabledFastQRPay;
  late String _qrPayEntryUrl;
  bool hasLogined = false;
  String _rawEntryDocument = '';
  String _rawMaybePayDoc = '';
  String _x50PayUrl = '';
  String _jkoPayUrl = '';
  String _linePayUrl = '';
  String get x50PayUrl => 'https://pay.x50.fun$_x50PayUrl';
  String get jkoPayUrl => _jkoPayUrl;
  String get linePayUrl => _linePayUrl;
  bool get isLinePayAvailable => _linePayUrl.startsWith('https');

  Future<String> getRawEntryDocument() async {
    if (_rawEntryDocument.isNotEmpty) return _rawEntryDocument;

    if (!kDebugMode || isForceFetch) {
      final rawResponse = await _repo.getDocument(_qrPayEntryUrl);
      _rawEntryDocument = const Utf8Decoder().convert(rawResponse.bodyBytes);
    } else {
      _rawEntryDocument =
          await rootBundle.loadString('assets/tests/scan_pay.html');
    }

    return _rawEntryDocument;
  }

  QRPayTPPRedirect _decideRedirectType(String redirectURL) {
    log('redirectURL: $redirectURL',
        name: 'QRPayViewModel._decideRedirectType');
    if (redirectURL.contains('onlinepay.jkopay.com')) {
      return (type: QRPayTPPRedirectType.jkoPay, url: redirectURL);
    } else if (redirectURL.contains('line.me')) {
      return (type: QRPayTPPRedirectType.linePay, url: redirectURL);
    } else {
      return (type: QRPayTPPRedirectType.unknown, url: redirectURL);
    }
  }

  Future<QRPayTPPRedirect> checkThirdPartyPaymentRedirect() async {
    _qrPayEntryUrl = 'https://pay.x50.fun/mid/$mid/$cid';
    try {
      log('url: $_qrPayEntryUrl', name: 'QRPayViewModel.init');

      final settings = await _getPaymentSettings();

      if (settings.mtpMode == DefaultCabPayment.ask.value) {
        return (type: QRPayTPPRedirectType.none, url: '');
      }

      if (settings.mtpMode == DefaultCabPayment.x50pay.value) {
        handleNfcPay(
          mid: mid,
          cid: cid,
          onCabSelect: onCabSelect,
          isPreferTicket: settings.nfcTicket,
          onPaymentDone: onPaymentDone,
        );
        return (type: QRPayTPPRedirectType.x50Pay, url: '');
      }
      if (!kDebugMode || isForceFetch) {
        final rawResponse = await _repo.getDocument(_qrPayEntryUrl);
        if (rawResponse.statusCode != 200) {
          if (rawResponse.statusCode == 302) {
            return _decideRedirectType(rawResponse.headers['location']!);
          } else {
            throw Exception('statusCode: ${rawResponse.statusCode}');
          }
        }
      }
      return (type: QRPayTPPRedirectType.unknown, url: '');
    } catch (e, stacktrace) {
      log('',
          error: e,
          stackTrace: stacktrace,
          name: 'QRPayViewModel.checkThirdPartyPaymentRedirect');
      throw Exception('checkThirdPartyPaymentRedirect failed');
    }
  }

  Future<bool> checkSessionValid() async {
    try {
      _qrPayEntryUrl = 'https://pay.x50.fun/mid/$mid/$cid';
      final rawDoc = await getRawEntryDocument();
      final doc = parse(rawDoc);
      hasLogined = doc.getElementsByClassName("ts-notice is-outlined").isEmpty;
      final webButtons = doc.getElementsByClassName("ts-button is-fluid");
      _x50PayUrl = webButtons[0]
          .attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      _jkoPayUrl = webButtons[1]
          .attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      _linePayUrl = webButtons[2]
          .attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      log('x50PayUrl: $x50PayUrl', name: 'QRPayViewModel.init');
      log('jkoPayUrl: $jkoPayUrl', name: 'QRPayViewModel.init');
      log('linePayUrl: $linePayUrl', name: 'QRPayViewModel.init');
      return hasLogined;
    } catch (e) {
      log('', error: e, name: 'QRPayViewModel.init');
      return false;
    }
  }

  void handleX50PayPayment({
    required VoidCallback onPaymentFinished,
    required void Function(QRPayData qrPayData) onCabSelect,
  }) async {
    EasyLoading.show(status: '處理 X50Pay 支付');
    final enableFastQRPay = await _checkEnableFastQRPay();
    if (enableFastQRPay) {
      log('FastQRPay enabled', name: 'QRPayViewModel._handleFastQRPayment');
      _handleFastQRPayment();
      onPaymentFinished.call();
      return;
    }

    final willDirectPay = await _checkDirectPay();
    if (willDirectPay) {
      _handlePayment();
      onPaymentFinished.call();
      return;
    }

    final data = await _getQRPayData();

    onCabSelect.call(data);
    onPaymentFinished.call();
  }

  void _doInsert(String url) async {
    log('https://pay.x50.fun$url');
    // await CabSelectViewModel().doInsertQRPay(url: 'https://pay.x50.fun$url');
    return;
  }

  Future<PaymentSettingsModel> _getPaymentSettings() async {
    final accountViewModel = SettingsViewModel();
    final settings = await accountViewModel.getPaymentSettings();
    currentPaymentSettings = settings;
    return currentPaymentSettings;
  }

  void _handlePayment() async {
    assert(_rawMaybePayDoc.contains('付款中...'));

    try {
      final prePayUrl =
          _rawMaybePayDoc.split('location.replace("').last.split('")').first;
      if (prePayUrl.isEmpty) throw Exception('payUrl is empty');
      final prePaymentDoc = await _repo.getDocumentWithDomainPrefix(
        prePayUrl,
        _qrPayEntryUrl,
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

  void _handleFastQRPayment() async {
    assert(_enabledFastQRPay);

    String cid = this.cid;
    // 0mu 做 QRCode 的時候打錯了，所以要做轉換
    if (this.cid == '703765460') cid = '70376560';
    final accountViewModel = SettingsViewModel();
    final settings = await accountViewModel.getPaymentSettings();
    if (settings.nfcTicket) {
      _doInsert('/api/v1/tic/$mid/$cid/0');
    } else {
      _doInsert('/api/v1/pay/$mid/$cid/0');
    }
  }

  Future<bool> _checkEnableFastQRPay() async {
    final pref = await SharedPreferences.getInstance();
    _enabledFastQRPay = pref.getBool('fastQRPay') ?? false;
    return _enabledFastQRPay;
  }

  Future<bool> _checkDirectPay() async {
    try {
      if (!kDebugMode || isForceFetch) {
        _rawMaybePayDoc = await _repo.getQRPayDocument(x50PayUrl);
      } else {
        _rawMaybePayDoc =
            await rootBundle.loadString('assets/tests/scan_pay_x50pay.html');
      }
      log(_rawMaybePayDoc);
      return _rawMaybePayDoc.contains('付款中...');
    } catch (e) {
      log('', error: e, name: 'QRPayViewModel.willDirectPay');
      rethrow;
    }
  }

  Future<QRPayData> _getQRPayData() async {
    try {
      if (!kDebugMode || isForceFetch) {
        _rawMaybePayDoc = await _repo.getQRPayDocument(x50PayUrl);
      } else {
        _rawMaybePayDoc =
            await rootBundle.loadString('assets/tests/scan_pay_x50pay.html');
      }
      final doc = parse(_rawMaybePayDoc);
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
          error: e, stackTrace: stacktrace, name: 'QRPayViewModel.gameSelect');
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }
}

enum QRPayTPPRedirectType {
  none,
  unknown,
  x50Pay,
  jkoPay,
  linePay;
}
