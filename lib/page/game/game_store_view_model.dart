import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/repository.dart';

class GameStoreViewModel extends BaseViewModel {
  final Repository repository;

  GameStoreViewModel({required this.repository});

  bool get isStoreSelected => _isStoreSelected;
  bool _isStoreSelected = false;
  set isStoreSelected(bool value) {
    _isStoreSelected = value;
    notifyListeners();
  }

  /// 取得店家資料
  Future<StoreModel?> getStoreData({required Locale currentLocale}) async {
    try {
      showLoading();
      await Future.delayed(const Duration(milliseconds: 100));

      late final StoreModel stores;
      stores = await repository.getStores(currentLocale);

      return stores;
    } catch (e, stacktrace) {
      log('', error: '$e', name: 'getStoreData', stackTrace: stacktrace);
      return null;
    } finally {
      dismissLoading();
    }
  }

  Future<void> onStoreSelected(Store store, String prefix,
      {required VoidCallback onPageChange}) async {
    isStoreSelected = true;
    showInfo('已切換至${store.name}\n\n少女祈禱中...',
        duration: const Duration(milliseconds: 650));
    Prefs.setString(PrefsToken.storeName, store.name!);
    Prefs.setString(PrefsToken.storeId, prefix + (store.sid!.toString()));
    await Future.delayed(const Duration(milliseconds: 800));
    dismissLoading();
    await Future.delayed(const Duration(milliseconds: 450));
    onPageChange.call();
    return;
  }
}
