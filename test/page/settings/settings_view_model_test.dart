import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/setting_repository.dart';

class MockSettingRepository extends Mock implements SettingRepository {}

final mockRepo = MockSettingRepository();

void main() {
  setUp(() {
    when(() => mockRepo.autoConfirm(
          agv: any(named: 'agv'),
          atq: any(named: 'atq'),
          atc: any(named: 'atc'),
          atn: any(named: 'atn'),
          atp: any(named: 'atp'),
          ats: any(named: 'ats'),
          att: any(named: 'att'),
          mtp: any(named: 'mtp'),
        )).thenAnswer((_) async {
      const rawResponse =
          r'''{"nfcAuto": true, "nfcTicket": false, "nfcTwo": "0", "nfcSDVX": "0", "nfcNVSV": "0", "nfcQuic": true, "aGV": false, "nfcQlock": 15, "mtpMode": 0}''';
      return http.Response(rawResponse, 200);
    });
    when(mockRepo.getBidLog).thenAnswer((_) async {
      const rawResponse =
          r'''{"message":"done","code":200,"log":[{"_id":{"$oid":"62bd79dbfe009eb67dc4f853"},"uid":"938","point":500.0,"shop":"37656","time":"2022-06-30 18:24"},{"_id":{"$oid":"62baf388e4f0f77b8c3738df"},"uid":"938","point":400.0,"shop":"37656","time":"2022-06-28 20:26"},{"_id":{"$oid":"62a5f9b1c3ee84ed28fe0780"},"uid":"938","point":500.0,"shop":"37656","time":"2022-06-12 22:35"},{"_id":{"$oid":"62a5e647c3ee84ed28fe075e"},"uid":"938","point":200.0,"shop":"37656","time":"2022-06-12 21:12"},{"_id":{"$oid":"62a5e584c3ee84ed28fe0758"},"uid":"938","point":200.0,"shop":"37656","time":"2022-06-12 21:09"},{"_id":{"$oid":"6273bf5ee0223d7557c05626"},"uid":"938","point":500,"shop":"37656","3kcre":true,"time":"2022-05-05 20:13"}]}''';
      return BidLogModel.fromJson(json.decode(rawResponse));
    });
    when(mockRepo.getPlayLog).thenAnswer((_) async {
      const rawResponse =
          r'''{"message":"done","code":200,"log":[{"_id":{"$oid":"66530312bf464606ab088e22"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-26T09:38:26.080Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":36.0,"sid":"7037656","time":"2024-05-26 17:38"},{"_id":{"$oid":"6653030abf464606ab088e20"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-26T09:38:18.669Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":81.0,"sid":"7037656","time":"2024-05-26 17:38"},{"_id":{"$oid":"6652ffce77db7609aec98097"},"uid":"X938","mid":"Jubeat","cid":1,"inittime":{"$date":"2024-05-26T09:24:30.374Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":20.0,"sid":"7037656","time":"2024-05-26 17:24"},{"_id":{"$oid":"6652f4c377db7609aec9804f"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-26T08:37:23.431Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":36.0,"sid":"7037656","time":"2024-05-26 16:37"},{"_id":{"$oid":"6652f4ba77db7609aec9804d"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-26T08:37:14.125Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":81.0,"sid":"7037656","time":"2024-05-26 16:37"},{"_id":{"$oid":"6652ec1f77db7609aec98002"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-26T08:00:31.786Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":36.0,"sid":"7037656","time":"2024-05-26 16:00"},{"_id":{"$oid":"6652ec17bf464606ab088dcb"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-26T08:00:23.957Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":81.0,"sid":"7037656","time":"2024-05-26 16:00"},{"_id":{"$oid":"6652e8bd77db7609aec97fe2"},"uid":"X938","mid":"Jubeat","cid":1,"inittime":{"$date":"2024-05-26T07:46:05.989Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":20.0,"sid":"7037656","time":"2024-05-26 15:46"},{"_id":{"$oid":"6652e55c77db7609aec97fca"},"uid":"X938","mid":"Jubeat","cid":1,"inittime":{"$date":"2024-05-26T07:31:40.962Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":20.0,"sid":"7037656","time":"2024-05-26 15:31"},{"_id":{"$oid":"6652e24577db7609aec97fa7"},"uid":"X938","mid":"Jubeat","cid":1,"inittime":{"$date":"2024-05-26T07:18:29.844Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":20.0,"sid":"7037656","time":"2024-05-26 15:18"},{"_id":{"$oid":"6650b9abbf464606ab0889c6"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-24T16:00:43.833Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":36.0,"sid":"7037656","time":"2024-05-25 00:00"},{"_id":{"$oid":"6650b99d77db7609aec976e4"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-24T16:00:29.138Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":81.0,"sid":"7037656","time":"2024-05-25 00:00"},{"_id":{"$oid":"6650b5f077db7609aec976cf"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-24T15:44:48.885Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":72.0,"sid":"7037656","time":"2024-05-24 23:44"},{"_id":{"$oid":"6650af4a77db7609aec976a0"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-24T15:16:26.306Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":36.0,"sid":"7037656","time":"2024-05-24 23:16"},{"_id":{"$oid":"6650af34bf464606ab088999"},"uid":"X938","mid":"DanceDanceRevolution","cid":1,"inittime":{"$date":"2024-05-24T15:16:04.698Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":36.0,"sid":"7037656","time":"2024-05-24 23:16"},{"_id":{"$oid":"6650a84d77db7609aec9766c"},"uid":"X938","mid":"Jubeat","cid":1,"inittime":{"$date":"2024-05-24T14:46:37.856Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":20.0,"sid":"7037656","time":"2024-05-24 22:46"},{"_id":{"$oid":"6650a20d77db7609aec9763a"},"uid":"X938","mid":"Jubeat","cid":1,"inittime":{"$date":"2024-05-24T14:19:57.186Z"},"status":"payment done","done":true,"disbool":false,"freep":0.0,"loraval":0,"price":20.0,"sid":"7037656","time":"2024-05-24 22:19"}]}''';
      return PlayRecordModel.fromJson(json.decode(rawResponse));
    });
    when(mockRepo.getTicDateLog).thenAnswer((_) async {
      const rawResponse =
          r'''{"message":"done","code":200,"log":[[2,"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","2022-07-17 02:13",[],"0","\u5168\u5e97\u53ef\u7528"],[1,"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","2022-07-27 02:53",[],"0","\u5168\u5e97\u53ef\u7528"],[4,"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","2049-10-27 21:13",[]]]}''';
      return TicDateLogModel.fromJson(json.decode(rawResponse));
    });
    when(mockRepo.getFreePLog).thenAnswer((_) async {
      const rawResponse =
          r'''{"message":"done","code":200,"log":[{"_id":{"$oid":"64f9f38253a65c8baa2855fa"},"uid":"X938","limittime":"2023-10-08 00:00","fpoint":25.0,"much":25.0,"expire":false}]}''';
      return FreePointModel.fromJson(json.decode(rawResponse));
    });
    when(mockRepo.getTicUsedLog).thenAnswer((_) async {
      const rawResponse =
          r'''{"message":"done","code":200,"log":[{"_id":{"$oid":"62bb2192efae537097a37415"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022-06-28 23:43"},{"_id":{"$oid":"62b5ef80b2ec8bf8003b7721"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022-06-25 01:08"},{"_id":{"$oid":"62b5ecf5b2ec8bf8003b7718"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022-06-25 00:57"},{"_id":{"$oid":"62a5f52b068521b28ed06950"},"uid":"938","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"price":27.0,"disbool":false,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022-06-12 22:16"},{"_id":{"$oid":"6273e32fb252e619099e4e1d"},"uid":"938","mid":"[\u897f\u9580] SDVX - Valkyrie Model","cid":2,"price":36.0,"disbool":false,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022-05-05 22:46"}]}''';
      return TicUsedModel.fromJson(json.decode(rawResponse));
    });
    when(mockRepo.getQuickPaySettings).thenAnswer((_) async {
      const rawResponse =
          """{"nfcAuto": true, "nfcTicket": true, "nfcTwo": "0", "nfcSDVX": "0", "nfcNVSV": "0", "nfcQuic": true, "aGV": false, "nfcQlock": 15, "mtpMode": 0}""";
      return PaymentSettingsModel.fromJson(json.decode(rawResponse));
    });
  });
  final viewModel = SettingsViewModel(settingRepo: mockRepo);

  group('快速付款偏好設定', () {
    test('測試取得快速付款偏好設定', () async {
      final quickPay = await viewModel.getPaymentSettings(enableDelay: false);
      expect(quickPay, isNotNull);
    });
    test('測試送出 autoConfirm，預期得到 statusCode 200', () async {
      final result = await viewModel.confirmQuickPay(
        autoNVSV: '',
        autoSDVX: '',
        autoTicket: false,
        autoTwo: '',
        mtp: 0,
        autoPay: false,
        autoQuicPay: true,
        autoRewardPoint: false,
      );
      expect(result, true);
    });
  });

  group('紀錄類', () {
    test('測試取得儲值紀錄', () async {
      final bidLog = await viewModel.getBidLog();
      expect(bidLog, isNotNull);
    });
    test('測試取得P點付費紀錄', () async {
      final playLog = await viewModel.getPlayRecord();
      expect(playLog, isNotNull);
    });
    test('測試取得獲券紀錄', () async {
      final ticLog = await viewModel.getTicketLog();
      expect(ticLog, isNotNull);
    });
    test('測試取得回饋點數紀錄', () async {
      final freePLog = await viewModel.getFreePointRecord();
      expect(freePLog, isNotNull);
    });
    test('測試取得使用券紀錄', () async {
      final ticUsedLog = await viewModel.getTicUsedLog();
      expect(ticUsedLog, isNotNull);
    });
  });
}
