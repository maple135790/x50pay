import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/mixins/nfc_pay_mixin.dart';
import 'package:x50pay/page/scan/qr_pay/cab_payment_result.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_data.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';
import 'package:x50pay/service/game_insert_service.dart';

typedef QRPayTPPRedirect = ({
  QRPayTPPRedirectType type,
  String url,
  CabPaymentResult? cabPaymentResult,
});

class QRPayService with NfcPayMixin {
  final SettingRepository settingRepo;
  @override
  final Repository repository;

  final VoidCallback onAfterInserted;
  @override
  final GameInsertService gameInsertService;

  QRPayService({
    required this.settingRepo,
    required this.repository,
    required this.onAfterInserted,
    required this.gameInsertService,
  });

  bool _enabledFastQRPay = false;
  late String _qrPayEntryUrl;
  late PaymentSettingsModel currentPaymentSettings;
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
      final rawResponse = await repository.getDocument(_qrPayEntryUrl);
      _rawEntryDocument = const Utf8Decoder().convert(rawResponse.bodyBytes);
    } else {
      // TODO: 移動至 test 並補上測試用asset
      _rawEntryDocument = await rootBundle.loadString(
        'assets/tests/scan_pay.html',
      );
    }

    return _rawEntryDocument;
  }

  QRPayTPPRedirect _decideRedirectType(String redirectURL) {
    log(
      'redirectURL: $redirectURL',
      name: 'QRPayViewModel._decideRedirectType',
    );
    if (redirectURL.contains('onlinepay.jkopay.com')) {
      return (
        type: QRPayTPPRedirectType.jkoPay,
        url: redirectURL,
        cabPaymentResult: null,
      );
    } else if (redirectURL.contains('line.me')) {
      return (
        type: QRPayTPPRedirectType.linePay,
        url: redirectURL,
        cabPaymentResult: null,
      );
    } else {
      return (
        type: QRPayTPPRedirectType.unknown,
        url: redirectURL,
        cabPaymentResult: null,
      );
    }
  }

  Future<QRPayTPPRedirect> checkThirdPartyPaymentRedirect({
    required String mid,
    required String cid,
  }) async {
    _qrPayEntryUrl = 'https://pay.x50.fun/mid/$mid/$cid';
    try {
      log('url: $_qrPayEntryUrl', name: 'QRPayViewModel.init');

      final settings = await _getPaymentSettings();

      if (settings.mtpMode == DefaultCabPayment.ask.value) {
        return (
          type: QRPayTPPRedirectType.none,
          url: '',
          cabPaymentResult: null,
        );
      }

      if (settings.mtpMode == DefaultCabPayment.x50pay.value) {
        final paymentResult = await handleNfcPay(
          mid: mid,
          cid: cid,
          repository: repository,
          settingRepo: settingRepo,
          isPreferTicket: settings.nfcTicket,
        );
        return (
          type: QRPayTPPRedirectType.x50Pay,
          url: '',
          cabPaymentResult: paymentResult,
        );
      }
      if (!kDebugMode || isForceFetch) {
        final rawResponse = await repository.getDocument(_qrPayEntryUrl);
        if (rawResponse.statusCode != 200) {
          if (rawResponse.statusCode == 302) {
            return _decideRedirectType(rawResponse.headers['location']!);
          } else {
            throw Exception('statusCode: ${rawResponse.statusCode}');
          }
        }
      }
      return (
        type: QRPayTPPRedirectType.unknown,
        url: '',
        cabPaymentResult: null,
      );
    } catch (e, stacktrace) {
      log(
        '',
        error: e,
        stackTrace: stacktrace,
        name: 'QRPayViewModel.checkThirdPartyPaymentRedirect',
      );
      throw Exception('checkThirdPartyPaymentRedirect failed');
    }
  }

  Future<bool> checkSessionValid({
    required String mid,
    required String cid,
  }) async {
    try {
      _qrPayEntryUrl = 'https://pay.x50.fun/mid/$mid/$cid';
      final rawDoc = await getRawEntryDocument();
      final doc = parse(rawDoc);
      hasLogined = doc.getElementsByClassName("ts-notice is-outlined").isEmpty;
      final webButtons = doc.getElementsByClassName("ts-button is-fluid");
      _x50PayUrl = webButtons[0].attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      _jkoPayUrl = webButtons[1].attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      _linePayUrl = webButtons[2].attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      log('x50PayUrl: $x50PayUrl', name: 'QRPayViewModel.init');
      log('jkoPayUrl: $jkoPayUrl', name: 'QRPayViewModel.init');
      log('linePayUrl: $linePayUrl', name: 'QRPayViewModel.init');
      return hasLogined;
    } catch (e, stacktrace) {
      log('', error: e, stackTrace: stacktrace, name: 'QRPayViewModel.init');
      return false;
    }
  }

  Future<CabPaymentResult> handleX50PayPayment({
    required String mid,
    required String cid,
  }) async {
    final enableFastQRPay = await _checkEnableFastQRPay();
    if (enableFastQRPay) {
      log('FastQRPay enabled', name: 'QRPayViewModel._handleFastQRPayment');
      await _handleFastQRPayment(mid, cid);
      return const CabPaymentCompleted();
    }

    final willDirectPay = await _checkDirectPay();
    if (willDirectPay) {
      await _handlePayment();
      return const CabPaymentCompleted();
    }

    final data = await _getQRPayData();

    return CabPaymentNeedsSelection(data);
  }

  Future<void> _doInsert(String url) async {
    log('https://pay.x50.fun$url');
    await gameInsertService.doInsertQRPay(url: 'https://pay.x50.fun$url');
  }

  Future<PaymentSettingsModel> _getPaymentSettings() async {
    final accountViewModel = SettingsViewModel(settingRepo: settingRepo);
    final settings = await accountViewModel.getPaymentSettings();
    currentPaymentSettings = settings;
    return settings;
  }

  Future<void> _handlePayment() async {
    assert(_rawMaybePayDoc.contains('付款中...'));

    try {
      final prePayUrl = _rawMaybePayDoc
          .split('location.replace("')
          .last
          .split('")')
          .first;
      if (prePayUrl.isEmpty) throw Exception('payUrl is empty');
      final prePaymentDoc = await repository.getDocumentWithDomainPrefix(
        prePayUrl,
        _qrPayEntryUrl,
        descLabel: '取得支付前的頁面',
      );
      final payUrl = prePaymentDoc
          .split("\$.post('")[1]
          .split("',function")
          .first;
      if (payUrl.isEmpty) throw Exception('payUrl is empty');

      await _doInsert(payUrl);
    } on Exception catch (e) {
      log('', error: e, name: 'QRPayViewModel.handlePayment');
      rethrow;
    }
  }

  Future<void> _handleFastQRPayment(String mid, String cid) async {
    assert(_enabledFastQRPay);

    // 0mu 做 QRCode 的時候打錯了，所以要做轉換
    if (cid == '703765460') cid = '70376560';
    final accountViewModel = SettingsViewModel(settingRepo: settingRepo);
    final settings = await accountViewModel.getPaymentSettings();
    if (settings.nfcTicket) {
      await _doInsert('/api/v1/tic/$mid/$cid/0');
    } else {
      await _doInsert('/api/v1/pay/$mid/$cid/0');
    }
  }

  Future<bool> _checkEnableFastQRPay() async {
    final enabled = await Prefs.getBool(PrefsToken.enabledFastQRPay);
    _enabledFastQRPay = enabled ?? PrefsToken.enabledFastQRPay.defaultValue;
    return _enabledFastQRPay;
  }

  Future<bool> _checkDirectPay() async {
    try {
      if (!kDebugMode || isForceFetch) {
        _rawMaybePayDoc = await repository.getQRPayDocument(x50PayUrl);
      } else {
        // TODO: 移動至 test 並補上測試用asset
        _rawMaybePayDoc = await rootBundle.loadString(
          'assets/tests/scan_pay_x50pay.html',
        );
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
        _rawMaybePayDoc = await repository.getQRPayDocument(x50PayUrl);
      } else {
        // TODO: 移動至 test 並補上測試用asset
        _rawMaybePayDoc = await rootBundle.loadString(
          'assets/tests/scan_pay_x50pay.html',
        );
      }
      final doc = parse(_rawMaybePayDoc);
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
    } on Exception catch (e, stacktrace) {
      log(
        '',
        error: e,
        stackTrace: stacktrace,
        name: 'QRPayViewModel.gameSelect',
      );
      rethrow;
    }
  }
}

enum QRPayTPPRedirectType { none, unknown, x50Pay, jkoPay, linePay }
