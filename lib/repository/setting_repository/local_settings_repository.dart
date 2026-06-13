import 'package:http/http.dart' as http;
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/repository/setting_repository/setting_repository.dart';

class LocalSettingsRepository implements SettingRepository {
  final _fakeResponse = const BasicResponse(
    code: 200,
    message: 'fake success, no api is called.',
  );

  @override
  Future<http.Response> autoConfirm({
    required bool atc,
    required String atn,
    required bool atp,
    required bool atq,
    required String ats,
    required String att,
    required int mtp,
    required bool agv,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BasicResponse> changeEmail({required String remail}) async {
    return _fakeResponse;
  }

  @override
  Future<BasicResponse> changePassword({
    required String oldPwd,
    required String pwd,
  }) async {
    return _fakeResponse;
  }

  @override
  Future<BasicResponse> changePhone() async {
    return _fakeResponse;
  }

  @override
  Future<BasicResponse> doChangePhone({required String phone}) async {
    return _fakeResponse;
  }

  @override
  Future<BidLogModel> getBidLog() {
    throw UnimplementedError();
  }

  @override
  Future<FreePointModel> getFreePLog() {
    throw UnimplementedError();
  }

  @override
  Future<PadSettingsModel> getPadSettings() {
    throw UnimplementedError();
  }

  @override
  Future<PlayRecordModel> getPlayLog() {
    throw UnimplementedError();
  }

  @override
  Future<String> getQuicDocument() {
    throw UnimplementedError();
  }

  @override
  Future<PaymentSettingsModel> getQuickPaySettings() {
    throw UnimplementedError();
  }

  @override
  Future<TicDateLogModel> getTicDateLog() {
    throw UnimplementedError();
  }

  @override
  Future<TicUsedModel> getTicUsedLog() {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> quicConfirm({
    required bool atq,
    required String atql,
  }) async {
    return http.Response(r'"{"code": 200,"message": "smth"}"', 200);
  }

  @override
  Future<http.Response> setPadSettings({
    required bool shid,
    required String shcolor,
    required String shname,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BasicResponse> smsActivate({required String sms}) async {
    return _fakeResponse;
  }
}
