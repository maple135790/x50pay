import 'package:flutter/material.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/generated/l10n.dart';

class LanguageViewModel extends ChangeNotifier {
  /// 語系相關的 ViewModel
  LanguageViewModel();

  /// 預設語系
  static const _defaultAppLocale =
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW');

  /// 當前語系
  Locale get currentLocale => _currentLocale;
  late Locale _currentLocale;
  set currentLocale(Locale value) {
    _currentLocale = value;
    notifyListeners();
  }

  /// 取得使用者偏好語系
  ///
  /// 會從 [SharedPreferences] 中取得使用者偏好語系，若沒有則回傳 [_defaultAppLocale]。
  /// 儲存的語系標籤為 `zh-TW`、`en-US`、`ja-JP`。
  Future<Locale> getUserPrefLocale() async {
    final locale = await Prefs.getString(PrefsToken.appLang);
    if (locale == null) return _defaultAppLocale;
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
    Prefs.setString(PrefsToken.appLang, locale.toLanguageTag());
    Prefs.remove(PrefsToken.storeId);
    Prefs.remove(PrefsToken.storeName);
    S.load(locale);
  }
}
