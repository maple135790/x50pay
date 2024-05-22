import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/theme/color_theme.dart';

import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/theme_provider.dart';

abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  late final i18n = S.of(context);
  late String serviceErrorText = i18n.serviceError;

  bool get isDarkTheme => Theme.of(context).brightness == Brightness.dark;

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

  final buttonStyleDark = ButtonStyle(
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
    foregroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xff1e1e1e).withOpacity(0.5);
      return const Color(0xff1e1e1e);
    }),
    backgroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xfffafafa).withOpacity(0.5);
      return const Color(0xfffafafa);
    }),
  );

  final buttonStyleLight = ButtonStyle(
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
    foregroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xfffafafa).withOpacity(0.5);
      return const Color(0xfffafafa);
    }),
    backgroundColor: WidgetStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xff3a3a3a).withOpacity(0.2);
      return const Color(0xff3a3a3a);
    }),
  );

  void showServiceError() {
    EasyLoading.showError(serviceErrorText,
        dismissOnTap: false, duration: const Duration(seconds: 2));
  }
}
