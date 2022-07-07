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

  Future<void> checkUser({bool force = false}) async {
    try {
      final current = DateTime.now().millisecondsSinceEpoch;
      final isLess30Sec = (current ~/ 1000) - _lastChkMe < 30;

      if (isLess30Sec && !force) return;
      final repo = Repository();
      _lastChkMe = DateTime.now().millisecondsSinceEpoch;
      if (!kDebugMode || isOnline) {
        user = await repo.getUser();
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
            sid: "",
            sixn: "575707",
            tphone: 1,
            doorpwd: "本期門禁密碼爲 : 1743#");
      }
    } on Exception catch (_) {}
  }
}
