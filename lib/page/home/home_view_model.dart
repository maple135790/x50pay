import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/repository/repository.dart';

class HomeViewModel extends BaseViewModel {
  final repo = Repository();
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
      if (!kDebugMode || isForceFetch) {
        entry = await repo.getEntry();
      } else {
        entry = await compute<String, EntryModel>(
          _decodeAndParseJson,
          await rootBundle.loadString('assets/tests/entry.json'),
        );
      }
      await EasyLoading.dismiss();
      return true;
    } catch (e) {
      log('', error: e, name: 'home init');
      await EasyLoading.dismiss();
      return false;
    }
  }
}
