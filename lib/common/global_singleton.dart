import 'package:x50pay/common/models/user/user.dart';

class GlobalSingleton {
  User? user;
  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  void clearUser() {
    user = null;
  }
}
