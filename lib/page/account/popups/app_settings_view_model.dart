import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/global_singleton.dart';

class AppSettingsViewModel extends BaseViewModel {
  bool get isEnabledFastQRPay => _isEnabledFastQRPay;
  bool _isEnabledFastQRPay = false;
  set isEnabledFastQRPay(bool value) {
    _isEnabledFastQRPay = value;
    notifyListeners();
  }

  bool get isEnabledBiometricsLogin => _isEnabledBiometricsLogin;
  bool _isEnabledBiometricsLogin = false;
  set isEnabledBiometricsLogin(bool value) {
    _isEnabledBiometricsLogin = value;
    notifyListeners();
  }

  Future<bool> isBiomerticsAvailable() async {
    final auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> _getIsEnabledFastQRPay() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('fastQRPay') ?? false;
  }

  Future<bool> _getIsEnabledBiometricsLogin() async {
    final hasUsername = await GlobalSingleton.instance.secureStorage
        .containsKey(key: 'x50username');
    final hasPwd = await GlobalSingleton.instance.secureStorage
        .containsKey(key: 'x50password');
    return hasUsername && hasPwd;
  }

  void enableBiometricsLogin(String email, String pasword) async {
    await GlobalSingleton.instance.secureStorage.write(
      key: 'x50username',
      value: email,
    );
    await GlobalSingleton.instance.secureStorage.write(
      key: 'x50password',
      value: pasword,
    );
    isEnabledBiometricsLogin = true;
  }

  void disableBiometricsLogin() async {
    await GlobalSingleton.instance.secureStorage.delete(key: 'x50username');
    await GlobalSingleton.instance.secureStorage.delete(key: 'x50password');
    isEnabledBiometricsLogin = false;
  }

  void enableFastQRPay() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('fastQRPay', true);
    isEnabledFastQRPay = true;
  }

  void disableFastQRPay() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('fastQRPay', false);
    isEnabledFastQRPay = false;
  }

  Future<void> getAppSettings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    isEnabledFastQRPay = await _getIsEnabledFastQRPay();
    isEnabledBiometricsLogin = await _getIsEnabledBiometricsLogin();
    return;
  }
}
