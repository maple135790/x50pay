import 'package:flutter/material.dart';

extension LocaleText on Locale {
  /// 語系標籤
  ///
  /// 例如 `zh-TW`、`en-US`、`ja-JP`
  String get tagName => '$languageCode-$countryCode';

  /// 語系顯示文字
  ///
  /// 例如 `繁體中文`、`English`、`日本語`
  String get displayText {
    switch (tagName) {
      case 'zh-TW':
        return '繁體中文';
      case 'en-US':
        return 'English';
      case 'ja-JP':
        return '日本語';
      default:
        return '繁體中文';
    }
  }
}
