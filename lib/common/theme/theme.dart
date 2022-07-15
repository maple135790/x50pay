import 'package:flutter/material.dart';

extension MaterialStateSet on Set<MaterialState> {
  bool get isHovered => contains(MaterialState.hovered);
  bool get isDisabled => contains(MaterialState.disabled);
  bool get isPressed => contains(MaterialState.pressed);
}

class AppThemeData {
  ThemeData get materialTheme {
    return ThemeData(
      dataTableTheme: DataTableThemeData(
        headingTextStyle: const TextStyle(color: Color(0xfffafafa)),
        headingRowColor: MaterialStateProperty.all(const Color(0xff2a2a2a)),
        decoration: BoxDecoration(
            color: const Color(0xff1e1e1e), border: Border.all(color: Themes.borderColor, width: 1)),
      ),
      dialogBackgroundColor: const Color(0xff1e1e1e),
      dividerColor: const Color(0xff3e3e3e),
      textTheme: const TextTheme(
          bodyText1: TextStyle(color: Color(0xfffafafa)),
          bodyText2: TextStyle(color: Color(0xfffafafa)),
          subtitle1: TextStyle(color: Color(0xfffafafa))),
      scaffoldBackgroundColor: const Color(0xff1e1e1e),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xff2a2a2a),
          hintStyle: TextStyle(color: Color(0xff757575)),
          prefixIconColor: Color(0xfffafafa),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff505050), width: 3)),
          isDense: true,
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5))),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 3))),
    );
  }
}

class Themes {
  static const borderColor = Color(0xff3e3e3e);
  static ButtonStyle pale({EdgeInsetsGeometry? padding, VisualDensity? vd}) {
    return ButtonStyle(
      padding: MaterialStateProperty.all(padding),
      splashFactory: NoSplash.splashFactory,
      visualDensity: vd,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.all(const Color(0xff1e1e1e)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        return const Color(0xfffafafa);
      }),
    );
  }

  static ButtonStyle energy() {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.isPressed) return const Color(0xff005a8b);
        if (states.isDisabled) return const Color(0xffdcead3);
        return const Color(0xff00adea);
      }),
    );
  }

  static ButtonStyle grey() {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      foregroundColor: MaterialStateProperty.all(const Color(0xff5a5a5a)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.isPressed) return const Color(0xffbfbfbf);
        if (states.isDisabled) return const Color(0xffdcead3);
        return const Color(0xffd9d9d9);
      }),
    );
  }

  static ButtonStyle confirm() {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      foregroundColor: MaterialStateProperty.all(Colors.white),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.isPressed) return const Color(0xff677A40);
        if (states.isDisabled) return const Color(0xffdcead3);
        return const Color(0xff8bb96e);
      }),
    );
  }

  static ButtonStyle severe(
      {bool isV4 = false, EdgeInsetsGeometry? padding, OutlinedBorder? outlinedBorder}) {
    return isV4
        ? ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            padding: MaterialStateProperty.all(padding),
            shape: MaterialStateProperty.all(outlinedBorder),
            // foregroundColor: MaterialStateProperty.all(const Color(0xfffafafa)),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.isDisabled) return const Color(0xff8e8e8e);
              return const Color(0xfffafafa);
            }),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.isPressed) return const Color(0xff8a3145);
              if (states.isDisabled) return const Color(0xff892025);
              return const Color(0xffF5222D);
            }),
          )
        : ButtonStyle(
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

  static ButtonStyle cancel() {
    return ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      foregroundColor: MaterialStateProperty.all(const Color(0xff404040)),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
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
        overlayColor: MaterialStateProperty.all(Colors.transparent),
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
