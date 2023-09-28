import 'package:local_auth/local_auth.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';

class AppSettingsViewModel extends BaseViewModel {
  bool get isEnableInAppNfcScan => _isEnableInAppNfcScan;
  bool _isEnableInAppNfcScan = true;
  set isEnableInAppNfcScan(bool value) {
    _isEnableInAppNfcScan = value;
    notifyListeners();
  }

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
    final enabled = await Prefs.getBool(PrefsToken.enabledFastQRPay);
    return enabled ?? false;
  }

  Future<bool> _getIsEnabledBiometricsLogin() async {
    final hasUsername =
        await Prefs.secureContainsKey(SecurePrefsToken.username);
    final hasPwd = await Prefs.secureContainsKey(SecurePrefsToken.password);

    return hasUsername && hasPwd;
  }

  Future<bool> _getIsEnableInAppNfcScan() async {
    final enabled = await Prefs.getBool(PrefsToken.enabledInAppNfcScan);
    return enabled ?? PrefsToken.enabledInAppNfcScan.defaultValue;
  }

  void setInAppNfcScan() async {
    Prefs.setBool(PrefsToken.enabledInAppNfcScan, isEnableInAppNfcScan);
    return;
  }

  void enableBiometricsLogin(String email, String pasword) async {
    await Prefs.secureWrite(SecurePrefsToken.username, email);
    await Prefs.secureWrite(SecurePrefsToken.password, pasword);

    isEnabledBiometricsLogin = true;
  }

  void disableBiometricsLogin() async {
    await Prefs.secureDelete(SecurePrefsToken.username);
    await Prefs.secureDelete(SecurePrefsToken.password);

    isEnabledBiometricsLogin = false;
  }

  void setFastQRPay(bool value) async {
    Prefs.setBool(PrefsToken.enabledFastQRPay, value);
    return;
  }

  Future<void> getAppSettings() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    isEnabledFastQRPay = await _getIsEnabledFastQRPay();
    isEnabledBiometricsLogin = await _getIsEnabledBiometricsLogin();
    isEnableInAppNfcScan = await _getIsEnableInAppNfcScan();
    dismissLoading();
    return;
  }
}
