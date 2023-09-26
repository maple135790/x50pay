import 'dart:developer';

import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/repository/repository.dart';

class HomeViewModel extends BaseViewModel {
  final Repository repository;

  HomeViewModel({required this.repository});
  
  BasicResponse? response;
  EntryModel? _entry;
  EntryModel? get entry => _entry;
  set entry(EntryModel? value) {
    _entry = value;
    notifyListeners();
  }

  Future<void> initHome() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      await GlobalSingleton.instance.checkUser(force: true);
      entry = await repository.getEntry();
    } catch (e) {
      log('', error: e, name: 'home init');
    } finally {
      dismissLoading();
    }
  }
}
