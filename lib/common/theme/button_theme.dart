import 'package:flutter/material.dart';
import 'package:x50pay/providers/theme_provider.dart';

class CustomButtonThemes {
  static ButtonStyle pale({
    EdgeInsetsGeometry? padding,
    VisualDensity? vd,
    bool isDarkMode = true,
  }) {
    return isDarkMode
        ? ButtonStyle(
            padding: WidgetStateProperty.all(padding),
            splashFactory: NoSplash.splashFactory,
            visualDensity: vd,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            foregroundColor: WidgetStateProperty.all(const Color(0xff1e1e1e)),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.isDisabled) {
                return const Color(0xfffafafa).withOpacity(0.5);
              }
              return const Color(0xfffafafa);
            }),
          )
        : ButtonStyle(
            padding: WidgetStateProperty.all(padding),
            splashFactory: NoSplash.splashFactory,
            visualDensity: vd,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.isDisabled) {
                return const Color(0xff373737).withOpacity(0.5);
              }
              return const Color(0xff373737);
            }),
          );
  }

  static ButtonStyle grey({bool isDarkMode = true}) {
    return ButtonStyle(
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      splashFactory: NoSplash.splashFactory,
      foregroundColor: WidgetStateProperty.all(const Color(0xff5a5a5a)),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.isPressed) return const Color(0xffbfbfbf);
        if (states.isDisabled) return const Color(0xffdcead3);
        return const Color(0xffc3c3c3);
      }),
    );
  }

  static ButtonStyle severe({
    bool isDarkMode = true,
    bool isV4 = true,
    bool isRRect = true,
    EdgeInsetsGeometry? padding,
    OutlinedBorder? outlinedBorder,
  }) {
    if (isV4) {
      return ButtonStyle(
        padding: WidgetStateProperty.all(padding),
        shape: isRRect
            ? WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))
            : WidgetStateProperty.all(outlinedBorder),
        foregroundColor: isRRect
            ? const WidgetStatePropertyAll(Color(0xfffafafa))
            : WidgetStateProperty.resolveWith((states) {
                if (states.isDisabled) return const Color(0xff8e8e8e);
                return const Color(0xfffafafa);
              }),
        backgroundColor: isRRect
            ? const WidgetStatePropertyAll(Color(0xffF5222D))
            : WidgetStateProperty.resolveWith((states) {
                if (states.isDisabled) return const Color(0xff892025);
                return const Color(0xffF5222D);
              }),
      );
    } else {
      return ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: WidgetStateProperty.all(const Color(0xfffafafa)),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.isPressed) return const Color(0xff8a3145);
          if (states.isDisabled) return const Color(0xffdcead3);
          return const Color(0xffB85052);
        }),
      );
    }
  }

  static ButtonStyle cancel({bool isDarkMode = true}) {
    late final Color foregroundColor;
    late final Color backgroundColor;

    if (isDarkMode) {
      foregroundColor = const Color(0xff404040);
      backgroundColor = const Color(0xffeeeeee);
    } else {
      foregroundColor = const Color(0xfffafafa);
      backgroundColor = const Color(0xff3a3a3a);
    }
    return ButtonStyle(
      shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      foregroundColor: WidgetStateColor.resolveWith((states) {
        if (states.isDisabled) return foregroundColor.withOpacity(0.5);
        return foregroundColor;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.isDisabled) return backgroundColor.withOpacity(0.5);
        return backgroundColor;
      }),
    );
  }
}
