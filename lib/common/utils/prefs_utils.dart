import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/providers/theme_provider.dart';

class Prefs {
  static bool get _duringTest =>
      Platform.environment.containsKey('FLUTTER_TEST');

  static FlutterSecureStorage get _secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  static Future<String?> getString(PrefsToken token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(token.value);
  }

  static Future<bool?> getBool(PrefsToken token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(token.value);
  }

  static Future<int?> getInt(PrefsToken token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt(token.value);
  }

  static Future<void> setString(PrefsToken token, String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(token.value, value);
  }

  static Future<void> setBool(PrefsToken token, bool value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(token.value, value);
  }

  static Future<void> setInt(PrefsToken token, int value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt(token.value, value);
  }

  static Future<void> remove(PrefsToken token) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(token.value);
  }

  static Future<void> secureWrite(SecurePrefsToken token, String value) async {
    if (_duringTest) return;

    _secureStorage.write(key: token.value, value: value);
  }

  static Future<String?> secureRead(SecurePrefsToken token) async {
    if (_duringTest) return '';
    return _secureStorage.read(key: token.value);
  }

  static Future<void> secureDelete(SecurePrefsToken token) async {
    if (_duringTest) return;

    _secureStorage.delete(key: token.value);
  }

  static Future<bool> secureContainsKey(SecurePrefsToken token) async {
    if (_duringTest) return false;

    return _secureStorage.containsKey(key: token.value);
  }
}

enum PrefsToken {
  cardEmulationInterval('card_emulation_interval', defaultValue: -1),
  enabledFastQRPay('fast_qrpay', defaultValue: true),
  enabledInAppNfcScan('in_app_nfc_scan', defaultValue: true),
  enableSummarizedRecord('summarized_record', defaultValue: false),
  enableDarkTheme('dark_theme', defaultValue: true),
  seedColor('theme_seed_color',
      defaultValue: AppThemeProvider.defaultSeedColor),
  favGameName('fav_game_name'),
  appLang('app_lang', defaultValue: 'zh-tw'),
  storeId('store_id'),
  storeName('store_name');

  final String value;
  final dynamic defaultValue;

  const PrefsToken(this.value, {this.defaultValue});
}

enum SecurePrefsToken {
  session('session'),
  username('x50username'),
  password('x50password');

  final String value;

  const SecurePrefsToken(this.value);
}
