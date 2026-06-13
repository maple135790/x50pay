import 'dart:developer';

import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/repository/main_repository/repository.dart';

class EntryProvider extends BaseViewModel {
  final Repository repo;

  EntryProvider({required this.repo});

  EntryModel? _entry;
  EntryModel? get entry => _entry;

  /// 檢查 Entry 資料
  ///
  /// 取得 Entry 資料，並將資料存入 [entryNotifier] 變數中。
  /// 回傳是否成功取得 Entry 資料。
  Future<bool> checkEntry() async {
    log('check entry...', name: 'checkEntry');
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final fetchedEntry = await repo.getEntry();
      if (fetchedEntry == null || fetchedEntry.code != 200) return false;
      _entry = fetchedEntry;
      return true;
    } catch (e, stacktrace) {
      log('', error: e, stackTrace: stacktrace, name: 'checkEntry');
      return false;
    } finally {
      notifyListeners();
    }
  }
}
