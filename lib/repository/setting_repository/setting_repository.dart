import 'package:http/http.dart' as http;
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';

abstract class SettingRepository {
  /// 取得快速付款偏好設定API
  Future<PaymentSettingsModel> getQuickPaySettings();

  /// 設定 Quic Pay 偏好API
  ///
  /// 需要傳入 [atq] 和 [atql]
  Future<http.Response> quicConfirm({required bool atq, required String atql});

  /// 變更密碼API
  ///
  /// 需要傳入舊密碼[oldPwd] 和 新密碼[pwd]
  Future<BasicResponse> changePassword({
    required String oldPwd,
    required String pwd,
  });

  /// 變更電子郵件API
  ///
  /// 需要傳入新電子郵件[remail]
  Future<BasicResponse> changeEmail({required String remail});

  /// 變更手機號碼API
  ///
  /// 用於取消綁定手機號碼
  Future<BasicResponse> changePhone();

  /// 變更手機號碼API
  ///
  /// 用於綁定新手機號碼，需要傳入新手機號碼 [phone]
  Future<BasicResponse> doChangePhone({required String phone});

  /// 變更手機號碼API
  ///
  /// 用於驗證新手機號碼，需要傳入簡訊驗證碼 [sms]
  Future<BasicResponse> smsActivate({required String sms});

  /// 取得獲券紀錄API
  ///
  /// 回傳獲券紀錄 [TicDateLogModel]
  Future<TicDateLogModel> getTicDateLog();

  /// 取得儲值紀錄API
  ///
  /// 回傳儲值紀錄 [PayLogModel]
  Future<BidLogModel> getBidLog();

  /// 取得P點付費明細API
  ///
  /// 回傳付費明細 [PayLogModel]
  Future<PlayRecordModel> getPlayLog();

  /// 取得P點付費明細API
  ///
  /// 回傳付費明細 [PayLogModel]
  Future<FreePointModel> getFreePLog();

  /// 取得扣券明細API
  ///
  /// 回傳扣券明細 [TicUsedModel]
  Future<TicUsedModel> getTicUsedLog();

  /// 設定排隊平板偏好API
  Future<http.Response> setPadSettings({
    required bool shid,
    required String shcolor,
    required String shname,
  });

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
  });

  /// 取得排隊平板設定API
  Future<PadSettingsModel> getPadSettings();

  Future<String> getQuicDocument();
}
