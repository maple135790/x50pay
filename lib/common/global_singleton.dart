import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

class GlobalSingleton {
  final ValueNotifier<UserModel?> userNotifier = ValueNotifier(null);
  final isServiceOnline = kReleaseMode || false;
  final _costEnabled = false;
  UserModel? user;
  int _lastChkMe = -1;
  double _point = 220;
  bool isLogin = false;
  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  void clearUser() {
    user = null;
    userNotifier.value = null;
  }

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
        if (_costEnabled) {
          _point -= 20;
        }
        final customMap = {
          "point": _point,
          "email": "testUser@testUser",
          "name": "testUser",
        };
        var rawUserJson = jsonDecode(
                r"""{"message":"done","code":200,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","uid":"938","ticketint":2,"phoneactive":true,"vip":true,"vipdate":{"$date":1685957759681},"sid":"","sixn":"842232","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#"}""")
            as Map<String, dynamic>
          ..addAll(customMap);
        user = UserModel.fromJson(rawUserJson);
        userNotifier.value = user;
        return true;
      }
    } on Exception catch (_) {
      return false;
    }
  }
}
