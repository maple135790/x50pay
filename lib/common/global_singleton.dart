import 'package:flutter/foundation.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

class GlobalSingleton {
  final isOnline = false;
  UserModel? user;
  int _lastChkMe = -1;
  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  void clearUser() {
    user = null;
  }

  Future<bool> checkUser({bool force = false}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final current = DateTime.now().millisecondsSinceEpoch;
      final isLess30Sec = (current ~/ 1000) - _lastChkMe < 30;

      if (isLess30Sec && !force) return false;
      final repo = Repository();
      _lastChkMe = DateTime.now().millisecondsSinceEpoch;
      if (!kDebugMode || isOnline) {
        user = await repo.getUser();
        // 未回傳UserModel
        if (user == null) return false;
        // 回傳UserModel, 驗證失敗或是伺服器錯誤
        if (user!.code != 200) return false;
        return true;
      } else {
        user = UserModel(
            message: "done",
            code: 200,
            userimg: 'https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250',
            email: "maple135790@gmail.com",
            uid: '938',
            point: 222,
            name: "testUser (Offline)",
            ticketint: 9,
            phoneactive: true,
            vip: true,
            vipdate: const VipDate(date: 1657660411780),
            sid: "",
            sixn: "575707",
            tphone: 1,
            doorpwd: "本期門禁密碼爲 : 1743#");
        return true;
      }
    } on Exception catch (_) {
      return false;
    }
  }
}
