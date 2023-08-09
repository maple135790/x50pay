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
  final isServiceOnline = kReleaseMode || false;

  /// 開發用，模擬扣點
  final _devCostEnabled = false;

  /// 開發用，模擬Staff
  final _devUserToStaff = false;

  /// 開發用，模擬所持點數
  double _devPoint = 220;

  /// 使用者資料
  ///
  /// (之後將 deprecate 這個變數，改用 `userNotifier`)
  UserModel? user;

  /// 上次檢查使用者資料的時間
  int _lastChkMe = -1;

  /// 是否登入
  bool isLogin = false;

  /// 最近遊玩的機台資料
  ({Cabinet cabinet, String caboid})? recentPlayedCabinetData;

  bool isInCameraPage = false;

  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  /// 清除使用者資料
  void clearUser() {
    user = null;
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
        user = await repo.getUser();
        userNotifier.value = user;
        // 未回傳UserModel
        if (user == null) return false;
        // 回傳UserModel, 驗證失敗或是伺服器錯誤
        if (user!.code != 200) return false;
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
                r"""{"message":"done","code":200,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","ticketint":2,"phoneactive":true,"vip":true,"vipdate":{"$date":1685957759681},"sid":"","sixn":"842232","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#"}""")
            as Map<String, dynamic>
          ..addAll(customMap);
        user = UserModel.fromJson(rawUserJson);
        userNotifier.value = user;
        return true;
      }
    } catch (e) {
      log('', error: e, name: 'checkUser');
      return false;
    }
  }
}
