import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';

class HomeViewModel extends BaseViewModel {
  User? user;
  Entry? _entry;
  Entry? get entry => _entry;

  set entry(Entry? value) {
    _entry = value;
    notifyListeners();
  }

  Future<bool> initHome() async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 100));
    user = await fakeGetUser();
    GlobalSingleton.instance.user = user;
    entry = await getEntry();
    await EasyLoading.dismiss();

    return entry != null && user != null;
  }

  Future<User>? fakeGetUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return testUser;
  }

  Future<User>? getUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return testUser;
  }

  Future<Entry>? getEntry() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return testEntry;
  }
}
