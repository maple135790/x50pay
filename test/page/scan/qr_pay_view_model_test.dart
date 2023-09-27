import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_view_model.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';

class MockRepository extends Mock implements Repository {}

class MockSettingRepository extends Mock implements SettingRepository {}

final mockRepo = MockRepository();
final mockSettingRepo = MockSettingRepository();

void main() {
  final viewModel = QRPayViewModel(
    repository: mockRepo,
    settingRepo: mockSettingRepo,
    cid: '',
    mid: '',
    onCabSelect: (qrPayData) {},
    onPaymentDone: () {},
  );

  group('預設支付方法 == X50Pay', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({"store_id": "7037656"});

      when(() => mockRepo.selGame(any())).thenAnswer((_) async {
        const rawResponse =
            '''{"message":"done","code":200,"re":[["05-27 13:00 ~ 16:00","maiDX-\u2606\u897f\u9580\u4e8c\u5e97\u2605"]],"note":[0,"1F/\u9032\u9580\u53f3\u5074","1F/\u9032\u9580\u5de6\u524d",false,"one"],"cabinet":[{"num":1,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3 (DX\u6846\u6309\u9375)","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true},{"num":2,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6 (DX\u6846\u6309\u9375)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true}],"caboid":"632904081eb45d31f0a1185c","pad":true,"padmid":"50Pad02","padlid":"twommdx"}''';
        return CabinetModel.fromJson(json.decode(rawResponse));
      });
      when(() => mockSettingRepo.getQuickPaySettings()).thenAnswer((_) async {
        return PaymentSettingsModel(
          mtpMode: DefaultCabPayment.x50pay.value,
          aGV: true,
          nfcAuto: true,
          nfcQuic: true,
          nfcTicket: true,
          nfcNVSV: "0",
          nfcSDVX: "0",
          nfcTwo: "0",
          nfcQlock: 15,
        );
      });
    });
    test('測試第三方支付路由回傳', () async {
      final result = await viewModel.checkThirdPartyPaymentRedirect();
      expect(result, true);
    });
  });

  group('預設支付方法 == jkopay', () {
    test('測試第三方支付路由回傳', () async {
      final result = await viewModel.checkThirdPartyPaymentRedirect();
      expect(result, true);
    });
  });
  group('預設支付方法 == ask', () {
    test('測試第三方支付路由回傳', () async {
      final result = await viewModel.checkThirdPartyPaymentRedirect();
      expect(result, true);
    });
  });
}
