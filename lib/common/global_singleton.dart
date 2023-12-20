import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/repository.dart';

/// 全域變數
///
/// 用於儲存全域變數，例如使用者資料、最近遊玩的機台資料等。
class GlobalSingleton {
  bool get _duringTest => Platform.environment.containsKey('FLUTTER_TEST');

  /// 使用者資料註冊器
  final ValueNotifier<UserModel?> userNotifier = ValueNotifier(null);

  /// Entry 資料註冊器
  final ValueNotifier<EntryModel?> entryNotifier = ValueNotifier(null);

  /// 服務是否連接到X50Pay。
  ///
  /// 服務連接到X50Pay時，會將此值設為true。User 資料等會從伺服器取得。
  final isServiceOnline = kReleaseMode || true;

  /// 全域的 navigatorKey
  ///
  /// 在不特定頁面顯示 dialog 時使用
  static final navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'Global navigatorKey');

  /// 是否正在顯示 NfcPay 的 dialog
  ///
  /// 用來防止重複顯示 dialog
  bool isNfcPayDialogOpen = false;

  /// 是否已經登入
  ///
  /// 用於確認是否要顯示登入頁面，於 app 啟動時檢查。
  bool isLogined = false;

  /// 現在的頁面是否在首頁
  ///
  /// 用於確認是否要取得 Entry 資料，因為只有在首頁才需要取得。
  bool isAtHome = true;

  /// 開發用，模擬扣點
  final _devPCostEnabled = true;

  /// 開發用，模擬GR2點數增加
  final _devGr2GainEnabled = true;

  /// 開發用，模擬Staff
  final _devUserToStaff = false;

  /// 開發用，模擬所持點數
  double _devPoint = 220;

  /// 開發用，模擬 GR2 點數
  double _devGr2Point = 157.31;

  /// 開發用，模擬 fP 點數
  double _devfPPoint = 0;

  /// 上次檢查使用者資料的時間
  int _lastChkUser = -1;

  /// 最近遊玩的機台資料
  ({Cabinet cabinet, String caboid, int cabNum})? recentPlayedCabinetData;

  /// App 版本，例如 `X50Pay app v1.0.0 + 1`
  String get appVersion => _appVersion;
  String _appVersion = '';
  set setAppVersion(String value) {
    _appVersion = 'X50Pay app v$value';
  }

  /// 是否在掃描QRCode頁面的旗標
  ///
  /// 由於go_router 在pushNamed 無法取得location，
  /// 因此使用此旗標來判斷是否在掃描QRCode頁面。
  bool isInCameraPage = false;

  var refreshKey = GlobalKey();

  final _repo = Repository();

  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  /// 清除使用者資料
  void clearUser() {
    isLogined = false;
    userNotifier.value = null;
  }

  /// 檢查使用者資料
  ///
  /// 取得使用者資料，並將資料存入 [userNotifier] 變數中。
  /// 回傳是否成功取得使用者資料。
  ///
  /// [force] 強制檢查使用者資料
  Future<bool> checkUser() async {
    if (_duringTest) return true;
    log('check user...', name: 'checkUser');

    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final current = DateTime.now().millisecondsSinceEpoch;
      final isLess500ms =
          Duration(milliseconds: current - _lastChkUser).inMilliseconds < 500;

      if (isLess500ms) return true;
      _lastChkUser = DateTime.now().millisecondsSinceEpoch;
      if (!kDebugMode || isServiceOnline) {
        final fetchedUser = await _repo.getUser();

        // 未回傳UserModel
        if (fetchedUser == null) return false;
        // 回傳UserModel, 驗證失敗或是伺服器錯誤
        if (fetchedUser.code != 200) return false;
        // 與現有資料相同，不需要更新
        if (userNotifier.value?.equals(fetchedUser) ?? false) return true;
        userNotifier.value = fetchedUser;
        return true;
      } else {
        userNotifier.value = UserModel(
          message: "done",
          code: 200,
          doorpwd: "本期門禁密碼爲 : 1743#",
          vip: false,
          phoneactive: true,
          vipdate: UserModel.setVipDate(641865600000),
          fpoint: 0,
          givebool: 0,
          name: "testUser",
          email: "testUser@testUser",
          point: _devPCostEnabled ? _devPoint -= 20 : _devPoint,
          uid: _devUserToStaff ? "X938" : "938",
          sid: "",
          sixn: "805349",
          tphone: 1,
          ticketint: 10,
        );
        return true;
      }
    } catch (e, stacktrace) {
      log('', error: e, stackTrace: stacktrace, name: 'checkUser');
      return false;
    }
  }

  /// 檢查 Entry 資料
  ///
  /// 取得 Entry 資料，並將資料存入 [entryNotifier] 變數中。
  /// 回傳是否成功取得 Entry 資料。
  Future<bool> checkEntry() async {
    if (!isAtHome || _duringTest) return true;
    await Future.delayed(const Duration(milliseconds: 100));
    log('check entry...', name: 'checkEntry');

    try {
      if (!kDebugMode || isServiceOnline) {
        final fetchedEntry = await _repo.getEntry();
        if (fetchedEntry == null || fetchedEntry.code != 200) return false;

        entryNotifier.value = fetchedEntry;
        return true;
      } else {
        entryNotifier.value = EntryModel(
          message: "done",
          code: 200,
          gr2: [
            _devGr2GainEnabled ? _devGr2Point += 30 : _devGr2GainEnabled,
            220,
            3,
            "250",
            "12/13 - 0",
            "01/16",
            "",
            "",
            true,
            42.79,
            15,
            25,
            0,
            _devGr2GainEnabled ? _devfPPoint += 30 : _devfPPoint
          ],
        );
        return true;
      }
    } catch (e, stacktrace) {
      log('', error: e, stackTrace: stacktrace, name: 'checkEntry');
      return false;
    }
  }

  /// 檢查登入狀態
  Future<void> getLoginStatus() async {
    if (_duringTest) return;
    log('get login status...', name: 'getLoginStatus');
    try {
      // 檢查是否存在之前登入的session
      final sess = await Prefs.secureRead(SecurePrefsToken.session);
      if (sess == null) {
        isLogined = false;
        return;
      }
      // 嘗試登入，檢查session是否有效
      final fetchedUser = await _repo.getUser();
      if (fetchedUser == null || fetchedUser.code != 200) {
        isLogined = false;
      } else {
        isLogined = true;
      }
    } catch (e, stacktrace) {
      log('', error: e, stackTrace: stacktrace, name: 'getLoginStatus');
      return;
    }
  }
}
