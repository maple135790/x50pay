import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:local_auth/local_auth.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/repository.dart';

class LoginViewModel extends BaseViewModel {
  final _repo = Repository();
  BasicResponse? response;

  /// 錯誤訊息，若無錯誤則為 null
  String? get errorMsg => _errorMsg;
  String? _errorMsg;
  set errorMsg(String? value) {
    _errorMsg = value;
    notifyListeners();
  }

  /// 是否開啟生物辨識登入
  bool get enableBiometricsLogin => _enableBiometricsLogin;
  bool _enableBiometricsLogin = false;
  set enableBiometricsLogin(bool value) {
    _enableBiometricsLogin = value;
    notifyListeners();
  }

  /// 是否隱藏密碼。使用於密碼欄位的眼睛
  bool get hidePassword => _hidePassword;
  bool _hidePassword = true;
  set hidePassword(bool value) {
    _hidePassword = value;
    notifyListeners();
  }

  /// 登入的實體方法
  void _login(
    String email,
    String password,
    VoidCallback onLoginSuccess,
    bool isShowSuccessLogin, {
    int debugFlag = 200,
  }) async {
    EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      if (!kDebugMode || isForceFetch) {
        response = await _repo.login(email: email, password: password);
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
    } catch (e, stacktrace) {
      errorMsg = '未知錯誤，請通知開發者';
      log('', error: e, stackTrace: stacktrace, name: 'LoginViewModel.login');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// 帳號密碼的登入
  ///
  /// 需傳入帳號 [email] 及密碼 [password]。
  void login({
    required String email,
    required String password,
    required VoidCallback onLoginSuccess,
    bool isShowSuccessLogin = true,
  }) async {
    _login(email, password, onLoginSuccess, isShowSuccessLogin);
  }

  /// 使用生物辨識的登入
  ///
  /// 會找尋儲存於 [FlutterSecureStorage] 的帳號及密碼。
  /// 並傳至內部登入方法 [_login]
  void biometricsLogin({required VoidCallback onLoginSuccess}) async {
    final email = await Prefs.secureRead(SecurePrefsToken.username) as String;
    final password =
        await Prefs.secureRead(SecurePrefsToken.password) as String;
    _login(email, password, onLoginSuccess, true);
  }

  /// 成功登入
  void _successLogin(
    VoidCallback onLoginSuccess,
    bool isShowSuccessLogin,
  ) async {
    GlobalSingleton.instance.isLogined = true;
    if (isShowSuccessLogin) {
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 150));
      EasyLoading.showSuccess(
        '登入成功，歡迎回來',
        duration: const Duration(milliseconds: 800),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 350));
    }
    onLoginSuccess.call();
  }

  /// 檢查是否可以開啟生物辨識登入
  Future<void> checkEnableBiometricsLogin() async {
    final auth = LocalAuthentication();
    final hasUsername =
        await Prefs.secureContainsKey(SecurePrefsToken.username);
    final hasPwd = await Prefs.secureContainsKey(SecurePrefsToken.password);
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    enableBiometricsLogin = canAuthenticate && hasUsername && hasPwd;
  }

  String testResponse({int? code = 200}) =>
      """{"code": $code,"message": "smth"}""";
}
