import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:local_auth/local_auth.dart';
import 'package:logging/logging.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/main_repository/repository.dart';
import 'package:x50pay/storage/app_storage/app_storage.dart';
import 'package:x50pay/storage/cookie_storage.dart';

class LoginProvider extends BaseViewModel {
  final Repository _repo;
  final AppStorage _storage;
  final CookieStorage _cookieStorage;
  final VoidCallback _onInvalidCookie;
  final Future<void> Function() _onShowLoginSuccessDialog;

  LoginProvider(
    this._repo,
    this._cookieStorage, {
    required this._onInvalidCookie,
    required this._onShowLoginSuccessDialog,
  }) : _storage = AppStorage.secure();

  final _logger = Logger('LoginProvider');

  bool _isLoggedIn = false;

  /// 是否已經登入
  ///
  /// 用於確認是否要顯示登入頁面，於 app 啟動時檢查。
  bool get isLoggedIn => _isLoggedIn;

  LoginErrorType? _errorType;

  LoginErrorType? get errorType => _errorType;

  /// 是否開啟生物辨識登入
  bool get enableBiometricsLogin => _enableBiometricsLogin;
  bool _enableBiometricsLogin = false;
  set enableBiometricsLogin(bool value) {
    _enableBiometricsLogin = value;
    notifyListeners();
  }

  /// 是否隱藏密碼。使用於密碼欄位的眼睛
  bool get isPasswordObscure => _hidePassword;
  bool _hidePassword = true;
  set isPasswordObscure(bool value) {
    _hidePassword = value;
    notifyListeners();
  }

  /// 帳號密碼的登入
  ///
  /// 需傳入帳號 [email] 及密碼 [password]。
  void login({
    required String email,
    required String password,
    VoidCallback? onLoggedIn,
    bool showSuccessDialog = true,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _errorType = LoginErrorType.emptyField;
      return;
    }
    BasicResponse? response;
    EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      response = await _repo.login(email: email, password: password);
    } catch (e, stacktrace) {
      _errorType = LoginErrorType.unknown;
      log('', error: e, stackTrace: stacktrace, name: 'LoginViewModel.login');
    }

    EasyLoading.dismiss();
    final code = response?.code;
    if (code == null) {
      _errorType = LoginErrorType.unknown;
    } else if (code != 200) {
      _errorType = LoginErrorType.fromCode(code);
    } else {
      _errorType = null;
      _isLoggedIn = true;
      if (showSuccessDialog) await _onShowLoginSuccessDialog();
      onLoggedIn?.call();
    }
    notifyListeners();
  }

  /// 使用生物辨識的登入
  ///
  /// 會找尋儲存於 [FlutterSecureStorage] 的帳號及密碼。
  /// 並傳至內部登入方法 [doLogin]
  void biometricsLogin({VoidCallback? onLoggedIn}) async {
    final map = await _storage.readAll([
      StorageKey.username,
      StorageKey.password,
    ]);

    final email = map[StorageKey.username]?.toString();
    final password = map[StorageKey.password]?.toString();

    if (email == null || password == null) {
      _errorType = LoginErrorType.credentialCorrupted;
      notifyListeners();
      return;
    }

    login(email: email, password: password, onLoggedIn: onLoggedIn);
  }

  /// 成功登入
  @visibleForTesting
  void successLogin(
    VoidCallback onLoginSuccess,
    bool isShowSuccessLogin,
  ) async {
    _isLoggedIn = true;
    if (isShowSuccessLogin) {
      _onShowLoginSuccessDialog();
    }
    onLoginSuccess.call();
  }

  /// 檢查是否可以開啟生物辨識登入
  Future<void> checkEnableBiometricsLogin() async {
    final auth = LocalAuthentication();
    final hasUsername = await Prefs.secureContainsKey(
      SecurePrefsToken.username,
    );
    final hasPwd = await Prefs.secureContainsKey(SecurePrefsToken.password);
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    enableBiometricsLogin = canAuthenticate && hasUsername && hasPwd;
  }

  Future<bool> logout({int debugFlag = 200}) async {
    EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      await _repo.logout();

      return true;
    } on Exception catch (e) {
      log('', name: 'LoginProvider logout', error: e);

      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> autoLogin() async {
    bool isValidCookie = false;
    try {
      final cookie = await _cookieStorage.getStoredCookie(
        validate: true,
        setCacheAfterValidate: true,
      );
      isValidCookie = cookie != null;
    } on CookieExpiredException {
      _logger.info('cookie expired.');
    } catch (e, s) {
      _logger.warning('unknown error.', e, s);
    }

    if (!isValidCookie) {
      _onAutoLoginFailed();
      return;
    }

    final res = await _repo.getUser();
    if (res.result.isError) {
      _onAutoLoginFailed();
      return;
    }

    _logger.info('Has valid cookie!');
    _isLoggedIn = true;
    notifyListeners();
  }

  void _onAutoLoginFailed() {
    _isLoggedIn = false;
    _cookieStorage.clear();
    _onInvalidCookie();
    notifyListeners();
  }
}

enum LoginErrorType {
  credentialError(400),
  emailNotVerified(401),
  noLogin(402),
  unknown(-1),
  emptyField(-2),
  credentialCorrupted(-3);

  final int code;

  const LoginErrorType(this.code);

  factory LoginErrorType.fromCode(int code) {
    return values.firstWhere((e) => e.code == code, orElse: () => unknown);
  }
}
