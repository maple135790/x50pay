import 'dart:developer';

import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/repository/repository.dart';

class HomeViewModel extends BaseViewModel {
  final Repository repository;

  HomeViewModel({required this.repository});

  Future<bool> initHome() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final gotUser = await GlobalSingleton.instance.checkUser();
      final gotEntry = await GlobalSingleton.instance.checkEntry();
      return gotUser && gotEntry;
    } catch (e, stackTrace) {
      log('', error: e, stackTrace: stackTrace, name: 'home init');
      return false;
    } finally {
      dismissLoading();
    }
  }
}
