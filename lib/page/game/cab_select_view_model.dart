import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/repository/repository.dart';

class CabSelectViewModel extends BaseViewModel {
  final repo = Repository();

  Future<BasicResponse?> doInsert(
      {required bool isTicket,
      required String id,
      required int index,
      required num mode,
      int debugFlag = 200}) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      late final BasicResponse response;
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');
      log(
        'index: $index, id: $id/$sid$index, mode: $mode, isTicket: $isTicket',
        name: 'doInsert',
      );

      if (!kDebugMode || isForceFetch) {
        response = await repo.doInsert(isTicket, '$id/$sid$index', mode);
      } else {
        response =
            BasicResponse.fromJson(jsonDecode(testResponse(code: debugFlag)));
      }
      await EasyLoading.dismiss();

      return response;
    } catch (e) {
      log('', error: '$e', name: 'doInsert');
      return null;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  String testResponse({int code = 200}) =>
      '''{"code":$code,"message":"smth"}''';
}
