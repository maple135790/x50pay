import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static bool get _duringTest =>
      Platform.environment.containsKey('FLUTTER_TEST');

  static FlutterSecureStorage get _secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
          preferencesKeyPrefix: 'x50pay_',
        ),
      );

  static Future<String?> getString(PrefsToken token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(token.value);
  }

  static Future<bool?> getBool(PrefsToken token) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(token.value);
  }

  static Future<void> setString(PrefsToken token, String value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(token.value, value);
  }

  static Future<void> setBool(PrefsToken token, bool value) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(token.value, value);
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
  enabledFastQRPay('fastQRPay', defaultValue: false),
  enabledInAppNfcScan('inAppNfcScan', defaultValue: false),
  appLang('appLang', defaultValue: 'zh-tw'),
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
