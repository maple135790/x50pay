import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:x50pay/common/api.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';

class SettingRepository extends Api {
  /// 取得快速付款偏好設定API
  Future<PaymentSettingsModel> getQuickPaySettings() async {
    late PaymentSettingsModel quicSettingsModel;

    await Api.makeRequest(
      dest: '/nfc/getSettings',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        quicSettingsModel = PaymentSettingsModel.fromJson(json);
      },
    );
    return quicSettingsModel;
  }

  /// 設定 Quic Pay 偏好API
  ///
  /// 需要傳入 [atq] 和 [atql]
  Future<http.Response> quicConfirm({
    required bool atq,
    required String atql,
  }) async {
    final response = await Api.makeRequest(
      dest: '/quicConfirm',
      method: HttpMethod.post,
      contentType: ContentType.json,
      withSession: true,
      body: {'atq': atq, 'atql': atql},
    );
    return response;
  }

  /// 變更密碼API
  ///
  /// 需要傳入舊密碼[oldPwd] 和 新密碼[pwd]
  Future<BasicResponse> changePassword({
    required String oldPwd,
    required String pwd,
  }) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/chgpwd',
      contentType: ContentType.xForm,
      method: HttpMethod.post,
      withSession: true,
      body: {'old_pwd': oldPwd, 'pwd': pwd},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  /// 變更電子郵件API
  ///
  /// 需要傳入新電子郵件[remail]
  Future<BasicResponse> changeEmail({required String remail}) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/chgemail',
      method: HttpMethod.post,
      withSession: true,
      body: {'remail': remail},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  /// 變更手機號碼API
  ///
  /// 用於取消綁定手機號碼
  Future<BasicResponse> changePhone() async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/chgphone',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      contentType: ContentType.json,
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  /// 變更手機號碼API
  ///
  /// 用於綁定新手機號碼，需要傳入新手機號碼 [phone]
  Future<BasicResponse> doChangePhone({required String phone}) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/activePhone',
      method: HttpMethod.post,
      withSession: true,
      contentType: ContentType.json,
      body: {'phone': phone},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  /// 變更手機號碼API
  ///
  /// 用於驗證新手機號碼，需要傳入簡訊驗證碼 [sms]
  Future<BasicResponse> smsActivate({required String sms}) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/activeSms',
      method: HttpMethod.post,
      withSession: true,
      body: {'sms': sms},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  /// 取得獲券紀錄API
  ///
  /// 回傳獲券紀錄 [TicDateLogModel]
  Future<TicDateLogModel> getTicDateLog() async {
    late TicDateLogModel ticDateLogModel;

    await Api.makeRequest(
      dest: '/log/ticDate',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        ticDateLogModel = TicDateLogModel.fromJson(json);
      },
    );
    return ticDateLogModel;
  }

  /// 取得儲值紀錄API
  ///
  /// 回傳儲值紀錄 [PayLogModel]
  Future<BidLogModel> getBidLog() async {
    late BidLogModel bidLogModel;

    await Api.makeRequest(
      dest: '/log/Bid',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        bidLogModel = BidLogModel.fromJson(json);
      },
    );
    return bidLogModel;
  }

  /// 取得P點付費明細API
  ///
  /// 回傳付費明細 [PayLogModel]
  Future<PlayRecordModel> getPlayLog() async {
    late PlayRecordModel playRecordModel;

    await Api.makeRequest(
      dest: '/log/Play',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        playRecordModel = PlayRecordModel.fromJson(json);
      },
    );
    return playRecordModel;
  }

  /// 取得P點付費明細API
  ///
  /// 回傳付費明細 [PayLogModel]
  Future<FreePointModel> getFreePLog() async {
    late FreePointModel freePModel;

    await Api.makeRequest(
      dest: '/log/FreeP',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        freePModel = FreePointModel.fromJson(json);
      },
    );
    return freePModel;
  }

  /// 取得扣券明細API
  ///
  /// 回傳扣券明細 [TicUsedModel]
  Future<TicUsedModel> getTicUsedLog() async {
    late TicUsedModel ticUsedModel;

    await Api.makeRequest(
      dest: '/log/ticUsed',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        ticUsedModel = TicUsedModel.fromJson(json);
      },
    );
    return ticUsedModel;
  }

  /// 設定排隊平板偏好API
  Future<http.Response> setPadSettings({
    required bool shid,
    required String shcolor,
    required String shname,
  }) async {
    final response = await Api.makeRequest(
      dest: '/settingPadConfirm',
      method: HttpMethod.post,
      withSession: true,
      body: {'shid': shid, 'shcolor': shcolor, 'shname': shname},
      onSuccessString: (_) {},
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
    final response = await Api.makeRequest(
      dest: '/autoConfirm',
      body: {
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
      withSession: true,
      contentType: ContentType.json,
    );

    return response;
  }

  /// 取得排隊平板設定API
  Future<PadSettingsModel> getPadSettings() async {
    late PadSettingsModel padSettingsModel;

    await Api.makeRequest(
      dest: '/pad/getSettings',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        padSettingsModel = PadSettingsModel.fromJson(json);
      },
    );
    return padSettingsModel;
  }

  Future<String> getQuicDocument() async {
    final response = await Api.makeRequest(
      dest: '/quic/view-v4',
      method: HttpMethod.get,
      withSession: true,
      body: {},
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }
}
