import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/providers/theme_provider.dart';

mixin AppThemeMixin {
  BuildContext get context;

  bool get isDarkTheme => Theme.brightnessOf(context) == Brightness.dark;

  SystemUiOverlayStyle get overlayStyle =>
      isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

  Color get iconColor => isDarkTheme
      ? CustomColorThemes.iconColorDark
      : CustomColorThemes.iconColorLight;

  Color get borderColor => isDarkTheme
      ? CustomColorThemes.borderColorDark
      : CustomColorThemes.borderColorLight;

  Color get scaffoldBackgroundColor =>
      Theme.of(context).scaffoldBackgroundColor;

  Color get dialogButtomBarColor => isDarkTheme
      ? CustomColorThemes.dialogButtomBarColorDark
      : CustomColorThemes.dialogButtomBarColorLight;

  Color get cardColor => isDarkTheme
      ? CustomColorThemes.cardColorDark
      : CustomColorThemes.cardColorLight;

  ButtonStyle get buttonStyle =>
      isDarkTheme ? buttonStyleDark : buttonStyleLight;

  ButtonStyle get buttonStyleDark => ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    foregroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) {
        return const Color(0xff1e1e1e).withValues(alpha: 0.5);
      }
      return const Color(0xff1e1e1e);
    }),
    backgroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) {
        return const Color(0xfffafafa).withValues(alpha: 0.5);
      }
      return const Color(0xfffafafa);
    }),
  );

  ButtonStyle get buttonStyleLight => ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
    foregroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) {
        return const Color(0xfffafafa).withValues(alpha: 0.5);
      }
      return const Color(0xfffafafa);
    }),
    backgroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) {
        return const Color(0xff3a3a3a).withValues(alpha: 0.2);
      }
      return const Color(0xff3a3a3a);
    }),
  );
}
