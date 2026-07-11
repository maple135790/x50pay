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
    return switch (tagName) {
      'zh-TW' => '繁體中文',
      'en-US' => 'English',
      'ja-JP' => '日本語',
      _ => '繁體中文',
    };
  }

  String get displayTextShort {
    return switch (tagName) {
      'zh-TW' => 'TW',
      'en-US' => 'US',
      'ja-JP' => 'JP',
      _ => 'TW',
    };
  }
}
