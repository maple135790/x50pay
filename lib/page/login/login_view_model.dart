import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:local_auth/local_auth.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/repository/repository.dart';

class LoginViewModel extends BaseViewModel {
  final repo = Repository();
  BasicResponse? response;

  String? get errorMsg => _errorMsg;
  String? _errorMsg;
  set errorMsg(String? value) {
    _errorMsg = value;
    notifyListeners();
  }

  bool get enableBiometricsLogin => _enableBiometricsLogin;
  bool _enableBiometricsLogin = false;
  set enableBiometricsLogin(bool value) {
    _enableBiometricsLogin = value;
    notifyListeners();
  }

  void _login(
    String email,
    String password,
    VoidCallback onLoginSuccess,
    bool isShowSuccessLogin, {
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForceFetch) {
        response = await repo.login(email: email, password: password);
      } else {
        response =
            BasicResponse.fromJson(jsonDecode(testResponse(code: debugFlag)));
      }
      EasyLoading.dismiss();
      final code = response?.code ?? 0;
      switch (code) {
        case 400:
          errorMsg = '帳號或密碼錯誤';
          break;
        case 401:
          errorMsg = 'Email尚未驗證，請先驗證信箱\n若有問題請聯絡X50粉絲團';
          break;
        case 402:
          errorMsg = 'nologin';
          break;
        case 200:
          errorMsg = null;
          _successLogin(onLoginSuccess, isShowSuccessLogin);
          break;
        default:
          errorMsg = '未知錯誤';
      }
    } catch (e) {
      errorMsg = '未知錯誤，請通知開發者';
      log('', error: e, name: 'LoginViewModel.login');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void login({
    required String email,
    required String password,
    required VoidCallback onLoginSuccess,
    bool isShowSuccessLogin = true,
  }) async {
    _login(email, password, onLoginSuccess, isShowSuccessLogin);
  }

  void biometricsLogin({required VoidCallback onLoginSuccess}) async {
    final email = await GlobalSingleton.instance.secureStorage
        .read(key: 'x50username') as String;
    final password = await GlobalSingleton.instance.secureStorage
        .read(key: 'x50password') as String;
    _login(email, password, onLoginSuccess, true);
  }

  void _successLogin(
    VoidCallback onLoginSuccess,
    bool isShowSuccessLogin,
  ) async {
    GlobalSingleton.instance.checkUser(force: true);
    GlobalSingleton.instance.isLogined = true;
    if (isShowSuccessLogin) {
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 200));
      EasyLoading.showSuccess('登入成功，歡迎回來',
          duration: const Duration(milliseconds: 800));
      await Future.delayed(const Duration(milliseconds: 800));
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 400));
    }
    onLoginSuccess.call();
  }

  Future<void> checkEnableBiometricsLogin() async {
    final auth = LocalAuthentication();
    final hasUsername = await GlobalSingleton.instance.secureStorage
        .containsKey(key: 'x50username');
    final hasPwd = await GlobalSingleton.instance.secureStorage
        .containsKey(key: 'x50password');
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    enableBiometricsLogin = canAuthenticate && hasUsername && hasPwd;
  }

  String testResponse({int? code = 200}) =>
      """{"code": $code,"message": "smth"}""";
}
