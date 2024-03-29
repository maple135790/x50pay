import 'package:flutter/material.dart';
import 'package:x50pay/common/theme/theme.dart';

class CustomButtonThemes {
  static ButtonStyle pale({
    EdgeInsetsGeometry? padding,
    VisualDensity? vd,
    bool isDarkMode = true,
  }) {
    return isDarkMode
        ? ButtonStyle(
            padding: MaterialStateProperty.all(padding),
            splashFactory: NoSplash.splashFactory,
            visualDensity: vd,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(const Color(0xff1e1e1e)),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.isDisabled) {
                return const Color(0xfffafafa).withOpacity(0.5);
              }
              return const Color(0xfffafafa);
            }),
          )
        : ButtonStyle(
            padding: MaterialStateProperty.all(padding),
            splashFactory: NoSplash.splashFactory,
            visualDensity: vd,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.isDisabled) {
                return const Color(0xff373737).withOpacity(0.5);
              }
              return const Color(0xff373737);
            }),
          );
  }

  static ButtonStyle grey({bool isDarkMode = true}) {
    return ButtonStyle(
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      splashFactory: NoSplash.splashFactory,
      foregroundColor: MaterialStateProperty.all(const Color(0xff5a5a5a)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.isPressed) return const Color(0xffbfbfbf);
        if (states.isDisabled) return const Color(0xffdcead3);
        return const Color(0xffc3c3c3);
      }),
    );
  }

  static ButtonStyle severe({
    bool isDarkMode = true,
    bool isV4 = false,
    bool isRRect = true,
    EdgeInsetsGeometry? padding,
    OutlinedBorder? outlinedBorder,
  }) {
    if (isV4) {
      return ButtonStyle(
        padding: MaterialStateProperty.all(padding),
        shape: isRRect
            ? MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)))
            : MaterialStateProperty.all(outlinedBorder),
        foregroundColor: isRRect
            ? const MaterialStatePropertyAll(Color(0xfffafafa))
            : MaterialStateProperty.resolveWith((states) {
                if (states.isDisabled) return const Color(0xff8e8e8e);
                return const Color(0xfffafafa);
              }),
        backgroundColor: isRRect
            ? const MaterialStatePropertyAll(Color(0xffF5222D))
            : MaterialStateProperty.resolveWith((states) {
                if (states.isDisabled) return const Color(0xff892025);
                return const Color(0xffF5222D);
              }),
      );
    } else {
      return ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        foregroundColor: MaterialStateProperty.all(const Color(0xfffafafa)),
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
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
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      foregroundColor: MaterialStateColor.resolveWith((states) {
        if (states.isDisabled) return foregroundColor.withOpacity(0.5);
        return foregroundColor;
      }),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.isDisabled) return backgroundColor.withOpacity(0.5);
        return backgroundColor;
      }),
    );
  }
}
