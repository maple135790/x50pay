import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/repository/repository.dart';

class GameStoreViewModel extends BaseViewModel {
  final repo = Repository();

  /// 取得店家資料
  Future<StoreModel?> getStoreData({
    int debugFlag = 200,
  }) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));

      late final StoreModel stores;
      if (!kDebugMode || isForceFetch) {
        stores = await repo.getStores();
      } else {
        stores = StoreModel.fromJson(jsonDecode(testStorelist));
      }
      await EasyLoading.dismiss();
      return stores;
    } catch (e) {
      log('', error: '$e', name: 'getStoreData');
      return null;
    }
  }

  String testStorelist =
      '''{"prefix":"70","storelist":[{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u6b66\u660c\u8857\u4e8c\u6bb5134\u865f1\u6a13","name":"\u897f\u9580\u4e00\u5e97","sid":37656},{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u5eb7\u5b9a\u8def10\u865f1\u6a13","name":"\u897f\u9580\u4e8c\u5e97","sid":37658}]}''';
}
