import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

/// 全域變數
///
/// 用於儲存全域變數，例如使用者資料、最近遊玩的機台資料等。
class GlobalSingleton {
  /// 使用者資料註冊器
  final ValueNotifier<UserModel?> userNotifier = ValueNotifier(null);

  /// 服務是否連接到X50Pay。
  ///
  /// 服務連接到X50Pay時，會將此值設為true。User 資料等會從伺服器取得。
  final isServiceOnline = kReleaseMode || true;

  /// 開發用，模擬扣點
  final _devCostEnabled = false;

  /// 開發用，模擬Staff
  final _devUserToStaff = false;

  /// 開發用，模擬所持點數
  double _devPoint = 220;

  /// 上次檢查使用者資料的時間
  int _lastChkMe = -1;

  /// 是否登入
  bool isLogin = false;

  /// 最近遊玩的機台資料
  ({Cabinet cabinet, String caboid, int cabIndex})? recentPlayedCabinetData;

  String _appVersion = '';

  /// App 版本，例如 `X50Pay app v1.0.0 + 1`
  String get appVersion => _appVersion;

  set setAppVersion(String value) {
    _appVersion = 'X50Pay app v$value';
  }

  /// 是否在掃描QRCode頁面的旗標
  ///
  /// 由於go_router 在pushNamed 無法取得location，
  /// 因此使用此旗標來判斷是否在掃描QRCode頁面。
  bool isInCameraPage = false;

  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  // Future<Locale> getUserPrefLocale() async {
  //   final pref = await SharedPreferences.getInstance();
  //   final languageCode = pref.getString('languageCode');
  //   if (languageCode == null) return _defaultAppLocale;

  //   return Locale.fromSubtags(languageCode: languageCode);
  // }

  // void setUserPrefLocale(Locale locale) async {
  //   S.load(locale);
  //   currentLocale = locale;
  //   final pref = await SharedPreferences.getInstance();
  //   pref.setString('languageCode', locale.toString());
  // }

  /// 清除使用者資料
  void clearUser() {
    userNotifier.value = null;
  }

  /// 檢查使用者資料
  ///
  /// 取得使用者資料，並將資料存入 [userNotifier] 變數中。
  /// 回傳是否成功取得使用者資料。
  ///
  /// [force] 強制檢查使用者資料
  Future<bool> checkUser({bool force = false}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final current = DateTime.now().millisecondsSinceEpoch;
      final isLess30Sec = (current ~/ 1000) - _lastChkMe < 30;

      if (isLess30Sec && !force) return false;
      final repo = Repository();
      _lastChkMe = DateTime.now().millisecondsSinceEpoch;
      if (!kDebugMode || isServiceOnline) {
        userNotifier.value = await repo.getUser();
        // 未回傳UserModel
        if (userNotifier.value == null) return false;
        // 回傳UserModel, 驗證失敗或是伺服器錯誤
        if (userNotifier.value!.code != 200) return false;
        return true;
      } else {
        if (_devCostEnabled) _devPoint -= 20;
        final customMap = {
          "point": _devPoint,
          "email": "testUser@testUser",
          "name": "testUser",
          "uid": _devUserToStaff ? "X938" : "938",
        };
        var rawUserJson = jsonDecode(
                r"""{"message":"done","code":200,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","givebool":0,"ticketint":10,"phoneactive":true,"vip":false,"vipdate":{"$date":641865600000},"sid":"","sixn":"805349","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#","fpoint":0}""")
            as Map<String, dynamic>
          ..addAll(customMap);
        userNotifier.value = UserModel.fromJson(rawUserJson);
        return true;
      }
    } catch (e) {
      log('', error: e, name: 'checkUser');
      return false;
    }
  }
}
