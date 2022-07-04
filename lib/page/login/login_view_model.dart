import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/repository/repository.dart';

class LoginViewModel extends BaseViewModel {
  final repo = Repository();
  // final repo = Repository();
  BasicResponse? response;

  Future<bool> login(
      {required String email, required String password, int debugFlag = 200, bool force = false}) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || force) {
        response = await repo.login(email: email, password: password);
      } else {
        if (debugFlag != 200) {
          response = BasicResponse.fromJson(jsonDecode(testResponse(code: debugFlag)));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  String testResponse({int? code = 200}) => """{"code": $code,"message": "smth"}""";
}
