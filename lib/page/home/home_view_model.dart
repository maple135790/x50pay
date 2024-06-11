import 'dart:developer';

import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/user_provider.dart';

class HomeViewModel extends BaseViewModel {
  final UserProvider userProvider;
  final EntryProvider entryProvider;

  HomeViewModel({
    required this.userProvider,
    required this.entryProvider,
  });

  Future<bool> initHome() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final gotUser = await userProvider.checkUser();
      final gotEntry = await entryProvider.checkEntry();
      return gotUser && gotEntry;
    } catch (e, stackTrace) {
      log('', error: e, stackTrace: stackTrace, name: 'home init');
      return false;
    } finally {
      dismissLoading();
    }
  }
}
