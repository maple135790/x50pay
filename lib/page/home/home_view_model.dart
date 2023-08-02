// ignore_for_file: unnecessary_string_escapes

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

class HomeViewModel extends BaseViewModel {
  final repo = Repository();
  final isForce = GlobalSingleton.instance.devIsServiceOnline;
  UserModel? user;
  EntryModel? _entry;
  EntryModel? get entry => _entry;
  BasicResponse? response;

  set entry(EntryModel? value) {
    _entry = value;
    notifyListeners();
  }

  EntryModel _decodeAndParseJson(String encodedJson) {
    final jsonData = jsonDecode(encodedJson);
    return EntryModel.fromJson(jsonData);
  }

  Future<bool> initHome({int debugFlag = 200}) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      await GlobalSingleton.instance.checkUser(force: true);
      if (!kDebugMode || isForce) {
        entry = await repo.getEntry();
      } else {
        entry = await compute<String, EntryModel>(
          _decodeAndParseJson,
          await rootBundle.loadString('assets/tests/entry.json'),
        );
      }
      user = GlobalSingleton.instance.user;
      await EasyLoading.dismiss();
      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> chgGradev2(
      {int debugFlag = 200, required String gid, required String grid}) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      await GlobalSingleton.instance.checkUser(force: true);
      if (!kDebugMode || isForce) {
        response = await repo.chgGradev2(gid: gid, grid: grid);
      }
      await EasyLoading.dismiss();
      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  String testUser({int code = 200}) =>
      '''{"message":"done","code":$code,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","email":"maple135790@gmail.com","uid":"938","point":18.0,"name":"\u9bd6\u7f36","ticketint":7,"phoneactive":true,"vip":true,"vipdate":{"\$date":1657660411780},"sid":"","sixn":"523964","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#"}''';
}
