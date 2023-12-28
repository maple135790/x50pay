import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/providers/theme_provider.dart';

enum CardEmulationIntervals {
  long(300),
  medium(200),
  short(100),
  disabled(-1);

  final int timeInMilliSeconds;
  final String text;
  const CardEmulationIntervals(this.timeInMilliSeconds)
      : text = timeInMilliSeconds == -1 ? "不模擬卡片" : "$timeInMilliSeconds ms";
}

class AppSettingsViewModel extends BaseViewModel {
  String get ceInterval => _ceInterval;
  String _ceInterval = CardEmulationIntervals.medium.text;
  set ceInterval(String value) {
    _ceInterval = value;
    notifyListeners();
  }

  List<String> pixelProductNames = [
    'flame', // pixel 4
    'coral', // pixel 4 xl
    'bramble', // pixel 4a 5g
    'sunfish', // pixel 4a
    'redfin', // pixel 5
    'barbet', // pixel 5a
    'oriole', // pixel 6
    'raven', // pixel 6 pro
    'blueay', // pixel 6a
    'panther', // pixel 7
    'cheetah', // pixel 7 pro
    'lynx', // pixel 7a
    'shiba', // pixel 8
    'husky', // pixel 8 pro
  ];

  bool get isSupportCE => _isSupportCE;
  bool _isSupportCE = false;
  set isSupportCE(bool value) {
    _isSupportCE = value;
    notifyListeners();
  }

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

  bool get isEnableSummarizedRecord => _isEnableSummarizedRecord;
  bool _isEnableSummarizedRecord = false;
  set isEnableSummarizedRecord(bool value) {
    _isEnableSummarizedRecord = value;
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

  Future<bool> getIsEnableSummarizedRecord() async {
    final enabled = await Prefs.getBool(PrefsToken.enableSummarizedRecord);
    return enabled ?? PrefsToken.enableSummarizedRecord.defaultValue;
  }

  Future<String> _getCEInterval() async {
    final interval = await Prefs.getInt(PrefsToken.cardEmulationInterval);
    final intv = CardEmulationIntervals.values.firstWhere(
      (element) => element.timeInMilliSeconds == interval,
      orElse: () => CardEmulationIntervals.disabled,
    );
    return intv.text;
  }

  void setInAppNfcScan(bool value) async {
    Prefs.setBool(PrefsToken.enabledInAppNfcScan, value);

    isEnableInAppNfcScan = value;
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

    isEnabledFastQRPay = value;
    return;
  }

  void setSummarizedRecord(bool value) async {
    Prefs.setBool(PrefsToken.enableSummarizedRecord, value);

    isEnableSummarizedRecord = value;
    return;
  }

  void setCEInterval(CardEmulationIntervals value) async {
    Prefs.setInt(PrefsToken.cardEmulationInterval, value.timeInMilliSeconds);

    ceInterval = value.text;
    return;
  }

  void onChangeTheme({
    required bool isDarkTheme,
    required AppThemeProvider themeProvider,
  }) async {
    final brightness = isDarkTheme ? Brightness.dark : Brightness.light;

    themeProvider.changeBrightness(brightness);
    await Prefs.setBool(PrefsToken.enableDarkTheme, isDarkTheme);
  }

  Future<void> getAppSettings() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    isEnabledFastQRPay = await _getIsEnabledFastQRPay();
    isEnabledBiometricsLogin = await _getIsEnabledBiometricsLogin();
    isEnableInAppNfcScan = await _getIsEnableInAppNfcScan();
    isEnableSummarizedRecord = await getIsEnableSummarizedRecord();
    final androidinfo = await DeviceInfoPlugin().androidInfo;

    isSupportCE = pixelProductNames.contains(androidinfo.product.toLowerCase());
    ceInterval = await _getCEInterval();
    dismissLoading();
    return;
  }
}
