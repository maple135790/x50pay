import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';

class HomeViewModel extends BaseViewModel {
  User? _user;
  User? get user => _user;

  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  Entry? _entry;
  Entry? get entry => _entry;

  set entry(Entry? value) {
    _entry = value;
    notifyListeners();
  }

  Future<bool> initHome() async {
    // isLoading = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    user = await getUser();
    entry = await getEntry();
    // isLoading = false;

    return entry != null && user != null;
  }

  Future<User>? getUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return testUser;
  }

  Future<Entry>? getEntry() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return testEntry;
  }
}
