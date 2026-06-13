import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:x50pay/common/client/request_handler.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/repository/base_repository.dart';
import 'package:x50pay/repository/setting_repository/setting_repository.dart';

class ApiSettingRepository extends BaseRepository implements SettingRepository {
  const ApiSettingRepository(super.client);

  Uri _endpoint(String path) {
    return Uri.parse('https://pay.x50.fun/api/v1$path');
  }

  Map<String, dynamic> _decodeRes(http.Response res) {
    return json.decode(res.body);
  }

  /// 取得快速付款偏好設定API
  @override
  Future<PaymentSettingsModel> getQuickPaySettings() async {
    final res = await client.request(
      _endpoint('/nfc/getSettings'),
      method: HttpMethod.get,
    );
    return PaymentSettingsModel.fromJson(_decodeRes(res));
  }

  /// 設定 Quic Pay 偏好API
  ///
  /// 需要傳入 [atq] 和 [atql]
  @override
  Future<http.Response> quicConfirm({
    required bool atq,
    required String atql,
  }) async {
    final response = await client.request(
      _endpoint('/quicConfirm'),
      method: HttpMethod.post,
      rawBody: {'atq': atq, 'atql': atql},
    );
    return response;
  }

  /// 變更密碼API
  ///
  /// 需要傳入舊密碼[oldPwd] 和 新密碼[pwd]
  @override
  Future<BasicResponse> changePassword({
    required String oldPwd,
    required String pwd,
  }) async {
    final res = await client.request(
      _endpoint('/setting/chgpwd'),
      contentType: ContentType.xForm,
      method: HttpMethod.post,
      rawBody: {'old_pwd': oldPwd, 'pwd': pwd},
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 變更電子郵件API
  ///
  /// 需要傳入新電子郵件[remail]
  @override
  Future<BasicResponse> changeEmail({required String remail}) async {
    final res = await client.request(
      _endpoint('/setting/chgemail'),
      method: HttpMethod.post,
      rawBody: {'remail': remail},
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 變更手機號碼API
  ///
  /// 用於取消綁定手機號碼
  @override
  Future<BasicResponse> changePhone() async {
    final res = await client.request(
      _endpoint('/setting/chgphone'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 變更手機號碼API
  ///
  /// 用於綁定新手機號碼，需要傳入新手機號碼 [phone]
  @override
  Future<BasicResponse> doChangePhone({required String phone}) async {
    final res = await client.request(
      _endpoint('/setting/activePhone'),
      method: HttpMethod.post,
      rawBody: {'phone': phone},
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 變更手機號碼API
  ///
  /// 用於驗證新手機號碼，需要傳入簡訊驗證碼 [sms]
  @override
  Future<BasicResponse> smsActivate({required String sms}) async {
    final res = await client.request(
      _endpoint('/setting/activeSms'),
      method: HttpMethod.post,
      rawBody: {'sms': sms},
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 取得獲券紀錄API
  ///
  /// 回傳獲券紀錄 [TicDateLogModel]
  @override
  Future<TicDateLogModel> getTicDateLog() async {
    final res = await client.request(
      _endpoint('/log/ticDate'),
      method: HttpMethod.get,
    );
    return TicDateLogModel.fromJson(_decodeRes(res));
  }

  /// 取得儲值紀錄API
  ///
  /// 回傳儲值紀錄 [PayLogModel]
  @override
  Future<BidLogModel> getBidLog() async {
    final res = await client.request(
      _endpoint('/log/Bid'),
      method: HttpMethod.get,
    );
    return BidLogModel.fromJson(_decodeRes(res));
  }

  /// 取得P點付費明細API
  ///
  /// 回傳付費明細 [PayLogModel]
  @override
  Future<PlayRecordModel> getPlayLog() async {
    final res = await client.request(
      _endpoint('/log/Play'),
      method: HttpMethod.get,
    );
    return PlayRecordModel.fromJson(_decodeRes(res));
  }

  /// 取得P點付費明細API
  ///
  /// 回傳付費明細 [PayLogModel]
  @override
  Future<FreePointModel> getFreePLog() async {
    final res = await client.request(
      _endpoint('/log/FreeP'),
      method: HttpMethod.get,
    );
    return FreePointModel.fromJson(_decodeRes(res));
  }

  /// 取得扣券明細API
  ///
  /// 回傳扣券明細 [TicUsedModel]
  @override
  Future<TicUsedModel> getTicUsedLog() async {
    final res = await client.request(
      _endpoint('/log/ticUsed'),
      method: HttpMethod.get,
    );
    return TicUsedModel.fromJson(_decodeRes(res));
  }

  /// 設定排隊平板偏好API
  @override
  Future<http.Response> setPadSettings({
    required bool shid,
    required String shcolor,
    required String shname,
  }) async {
    final response = await client.request(
      _endpoint('/settingPadConfirm'),
      method: HttpMethod.post,
      rawBody: {'shid': shid, 'shcolor': shcolor, 'shname': shname},
    );
    return response;
  }

  /// 回傳快速付款偏好設定API
  ///
  /// - [atc] 是否啟用預設扣券
  /// - [atn] 女武神預設扣款模式
  /// - [atp] 是否啟用 NFC 自動扣款
  /// - [atq] 是否啟用 QuiC 靠卡扣款
  /// - [ats] SDVX預設扣款模式 (已無作用)
  /// - [att] 雙人遊玩機種預設扣款模式
  /// - [mtp] 機台付款碼預設
  /// - [agv] 是否預設使用回饋點數
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
  }) async {
    final response = await client.request(
      _endpoint('/autoConfirm'),
      rawBody: {
        'atc': atc,
        'atn': atn,
        'atp': atp,
        'atq': atq,
        'ats': ats,
        'att': att,
        'mtp': mtp,
        'agv': agv,
      },
      method: HttpMethod.post,
    );

    return response;
  }

  /// 取得排隊平板設定API
  @override
  Future<PadSettingsModel> getPadSettings() async {
    final res = await client.request(
      _endpoint('/pad/getSettings'),
      method: HttpMethod.get,
    );
    return PadSettingsModel.fromJson(_decodeRes(res));
  }

  @override
  Future<String> getQuicDocument() async {
    final response = await client.request(
      _endpoint('/quic/view-v4'),
      method: HttpMethod.get,
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }
}
