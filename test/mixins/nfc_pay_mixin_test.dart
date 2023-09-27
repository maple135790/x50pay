import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/mixins/nfc_pay_mixin.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';

class MockNfcPayMixin with NfcPayMixin {}

class MockRepository extends Mock implements Repository {}

class MockSettingRepository extends Mock implements SettingRepository {}

void main() {
  final mockSettingRepo = MockSettingRepository();
  final mockRepo = MockRepository();
  final mockMixin = MockNfcPayMixin();

  setUp(() {
    when(() => mockRepo.getQRPayDocument(any())).thenAnswer((_) async {
      const rawResponse = r'''付款中...''';
      return rawResponse;
    });
    when(() => mockRepo.doInsertRawUrl(any())).thenAnswer((_) async {
      const rawResponse = '''{"code":200,"message":"smth"}''';
      return BasicResponse.fromJson(json.decode(rawResponse));
    });
    when(() => mockRepo.getDocumentWithDomainPrefix(
          any(),
          any(),
          descLabel: any(named: 'descLabel'),
        )).thenAnswer((_) async {
      return r'''<script type="text/javascript"> 
        $.post('/api/v1/pay/5fcdcf800004a524c8fae000/70376560/0',function(data){});
        function myfc() {
            var win = window.open('','_self');
            win.close();
         }
        setInterval(myfc, 1500);
    </script>
  </body>''';
    });
  });
  test('當快速付款無設定、自動付款開啟，預期自動完成付款', () async {
    SharedPreferences.setMockInitialValues({});

    var log = <String>[];
    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: true,
        aGV: true,
        nfcQuic: true,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
      },
      onPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), false);
    expect(log.contains('onPaymentDone'), true);
  });
  test('當快速付款開啟、自動付款開啟，預期自動完成付款', () async {
    var log = <String>[];
    SharedPreferences.setMockInitialValues({"fastQRPay": true});

    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: true,
        aGV: true,
        nfcQuic: true,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
      },
      onPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), false);
    expect(log.contains('onPaymentDone'), true);
  });
  test('當快速付款關閉、自動付款開啟，預期自動完成付款', () async {
    var log = <String>[];
    SharedPreferences.setMockInitialValues({"fastQRPay": false});

    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: true,
        aGV: true,
        nfcQuic: true,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
      },
      onPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), false);
    expect(log.contains('onPaymentDone'), true);
  });
  test('當自動付款關閉，預期彈出onCabSelect', () async {
    SharedPreferences.setMockInitialValues({});

    var log = <String>[];
    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: false,
        aGV: true,
        nfcQuic: false,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
        expect(qrPayData, isNotNull);
      },
      onPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), true);
    expect(log.contains('onPaymentDone'), true);
  });
}
