import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  final MainRepository repo;
  final _logger = Logger('UserProvider');

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
  Future<bool> checkUser() async {
    _logger.info('check user...');

    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final res = await repo.getUser();
      final result = res.result;

      if (result.isError) return false;

      // 與現有資料相同，不需要更新
      if (user == result.successData) return true;

      _user = result.successData;
      return true;
    } catch (e, stacktrace) {
      _logger.warning('', e, stacktrace);
      return false;
    } finally {
      notifyListeners();
    }
  }
}
