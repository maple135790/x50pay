import 'dart:io';

import 'package:flutter/material.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/storage/app_storage/app_storage.dart';

class LanguageProvider extends ChangeNotifier {
  final AppStorage _storage;

  @visibleForTesting
  LanguageProvider.internal(this._storage);

  LanguageProvider() : _storage = AppStorage.prefs();

  /// 預設語系
  static const defaultAppLocale = Locale("zh", "TW");

  /// 當前語系
  Locale get currentLocale => _currentLocale;
  late Locale _currentLocale;

  set currentLocale(Locale value) {
    _currentLocale = value;
    notifyListeners();
  }

  /// 取得有效的語系
  ///
  /// 判斷是否在 App 存在與系統相同的語系，若沒有則回傳 [defaultAppLocale]。
  /// 有則回傳該語系
  Locale _getEffectiveLocale() {
    late Locale locale;
    final supportLocales = S.delegate.supportedLocales;
    final systemLanguageCode = Platform.localeName.split('_').first;
    if (supportLocales.any((l) => l.languageCode == systemLanguageCode)) {
      locale = supportLocales.firstWhere(
        (l) => l.languageCode == systemLanguageCode,
      );
    } else {
      locale = defaultAppLocale;
    }
    setUserPrefLocale(locale);
    return locale;
  }

  /// 取得使用者偏好語系
  ///
  /// 會從 [_storage] 中取得使用者偏好語系，若沒有則回傳 [defaultAppLocale]。
  /// 儲存的語系標籤為 `zh-TW`、`en-US`、`ja-JP`。
  Future<Locale> getUserPrefLocale() async {
    final locale = await _storage.read(StorageKey.appLang);
    if (locale == null) return _getEffectiveLocale();
    final lc = locale.split('-')[0];
    final cc = locale.split('-')[1];

    return Locale.fromSubtags(languageCode: lc, countryCode: cc);
  }

  /// 設定使用者偏好語系
  ///
  /// 會將語系設定儲存至 [SharedPreferences] 中，並且重新載入語系檔。
  /// 並且會清除 store_id、store_name，讓使用者重新選店。
  void setUserPrefLocale(Locale locale) async {
    currentLocale = locale;
    _storage
      ..write(.appLang, locale.toLanguageTag())
      ..delete(.storeId)
      ..delete(.storeName);
    S.load(locale);
  }
}
