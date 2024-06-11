import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  final Repository repo;

  UserProvider({required this.repo});

  /// 清除使用者資料
  void clearUser() {
    _user = null;
    notifyListeners();
  }

  /// 檢查使用者資料
  ///
  /// 取得使用者資料，並將資料存入 [userNotifier] 變數中。
  /// 回傳是否成功取得使用者資料。
  ///
  /// [force] 強制檢查使用者資料
  Future<bool> checkUser() async {
    log('check user...', name: 'checkUser');

    await Future.delayed(const Duration(milliseconds: 100));
    try {
      if (GlobalSingleton.instance.isServiceOnline) {
        final fetchedUser = await repo.getUser();

        // 未回傳UserModel
        if (fetchedUser == null) return false;
        // 回傳UserModel, 驗證失敗或是伺服器錯誤
        if (fetchedUser.code != 200) return false;
        // 與現有資料相同，不需要更新
        if (user == fetchedUser) return true;

        _user = fetchedUser;
      } else {
        _user = const UserModel.empty();
      }
      return true;
    } catch (e, stacktrace) {
      log('', error: e, stackTrace: stacktrace, name: 'checkUser');
      return false;
    } finally {
      notifyListeners();
    }
  }
}
