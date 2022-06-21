import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/user/user.dart';

class GameViewModel extends BaseViewModel {
  Store? store;
  User? user;

  Future<bool> initStore() async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      String jsonRaw = '''
{
  "prefix": "70",
  "storelist": [
{
  "address": "臺北市萬華區武昌街二段134號1樓",
  "name": "西門店",
  "sid": 37656
},
{
  "address": "臺北市士林區大南路48號2樓",
  "name": "士林店",
  "sid": 37657
}
  ]
}
''';
      store ??= Store.fromJson(jsonDecode(jsonRaw));
      user ??= await getUser();
      GlobalSingleton.instance.user = user;
      await EasyLoading.dismiss();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<User>? getUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return testUser;
  }
}
