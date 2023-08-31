import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension MaterialStateSet on Set<MaterialState> {
  bool get isHovered => contains(MaterialState.hovered);
  bool get isDisabled => contains(MaterialState.disabled);
  bool get isPressed => contains(MaterialState.pressed);
  bool get isSelected => contains(MaterialState.selected);
  bool get isFocused => contains(MaterialState.focused);
}

class AppThemeData {
  ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: CupertinoColors.activeBlue,
          barBackgroundColor: Color(0xff1e1e1e),
          scaffoldBackgroundColor: Color(0xff1e1e1e),
          textTheme: CupertinoTextThemeData(
            pickerTextStyle: TextStyle(color: Color(0xfffafafa)),
            navTitleTextStyle: TextStyle(color: Color(0xfffafafa)),
            navActionTextStyle: TextStyle(color: CupertinoColors.activeBlue),
            textStyle: TextStyle(color: Color(0xfffafafa)),
          )),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: const TextStyle(color: Color(0xfffafafa)),
        headingRowColor: MaterialStateProperty.all(const Color(0xff2a2a2a)),
        decoration: BoxDecoration(
            color: const Color(0xff1e1e1e),
            border: Border.all(color: Themes.borderColor)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      }),
      dialogTheme: const DialogTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Color(0xff1e1e1e),
          titleTextStyle: TextStyle(
              color: Color(0xfffafafa), fontSize: 20, wordSpacing: 0.15)),
      dialogBackgroundColor: const Color(0xff1e1e1e),
      dividerTheme: const DividerThemeData(color: Color(0xff3e3e3e)),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        dividerColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xfffafafa)),
          bodyMedium: TextStyle(color: Color(0xfffafafa)),
          titleMedium: TextStyle(color: Color(0xfffafafa))),
      scaffoldBackgroundColor: const Color(0xff1e1e1e),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xff1e1e1e),
        indicatorColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.isSelected) {
            return const TextStyle(color: Color(0xffe3c81b), fontSize: 11);
          }
          return null;
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.isSelected) {
            return const IconThemeData(color: Color(0xfffafafa));
          }
          return const IconThemeData(color: Color(0xffb4b4b4));
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.white),
      inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xff2a2a2a),
          hintStyle: TextStyle(color: Color(0xff757575)),
          prefixIconColor: Color(0xfffafafa),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff505050), width: 3)),
          isDense: true,
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5))),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 3))),
    );
  }
}

class Themes {
  static const borderColor = Color(0xff505050);
  static ButtonStyle pale({EdgeInsetsGeometry? padding, VisualDensity? vd}) {
    return ButtonStyle(
      padding: MaterialStateProperty.all(padding),
      splashFactory: NoSplash.splashFactory,
      visualDensity: vd,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      foregroundColor: MaterialStateProperty.all(const Color(0xff1e1e1e)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.isDisabled) return const Color(0xfffafafa).withOpacity(0.5);
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
      {bool isV4 = false,
      bool isRRect = false,
      EdgeInsetsGeometry? padding,
      OutlinedBorder? outlinedBorder}) {
    return isV4
        ? isRRect
            ? ButtonStyle(
                foregroundColor:
                    const MaterialStatePropertyAll(Color(0xfffafafa)),
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6))),
                backgroundColor: MaterialStateColor.resolveWith((states) {
                  return const Color(0xffF5222D);
                }),
              )
            : ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                padding: MaterialStateProperty.all(padding),
                shape: MaterialStateProperty.all(outlinedBorder),
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
        side: MaterialStateProperty.all(
            const BorderSide(color: Color(0xffCE5F58), width: 1)));
  }
}
