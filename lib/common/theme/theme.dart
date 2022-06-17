import 'package:flutter/material.dart';

extension MaterialStateSet on Set<MaterialState> {
  bool get isHovered => contains(MaterialState.hovered);
  bool get isDisabled => contains(MaterialState.disabled);
  bool get isPressed => contains(MaterialState.pressed);
}

class AppThemeData {
  ThemeData get materialTheme {
    return ThemeData(
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black)),
      inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1))),
    );
  }
}

class Themes {
  static ButtonStyle confirm() {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.isPressed) return const Color(0xff677A40);
        if (states.isDisabled) return const Color(0xffdcead3);
        return const Color(0xff8bb96e);
      }),
    );
  }

  static ButtonStyle cancel() {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      foregroundColor: MaterialStateProperty.all(const Color(0xff404040)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return const Color(0xffbfbfbf);
        }
        return const Color(0xffeeeeee);
      }),
    );
  }

  static ButtonStyle outlinedRed() {
    return ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return const Color(0xffCE5F58);
          }
          return Colors.white;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.white;
          }
          return const Color(0xffCE5F58);
        }),
        side: MaterialStateProperty.all(const BorderSide(color: Color(0xffCE5F58), width: 1)));
  }
}
