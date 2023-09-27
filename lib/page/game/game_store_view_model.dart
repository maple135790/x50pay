import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/repository/repository.dart';

class GameStoreViewModel extends BaseViewModel {
  final Repository repository;

  GameStoreViewModel({required this.repository});

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
}
