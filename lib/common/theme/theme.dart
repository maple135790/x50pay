import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/theme/color_theme.dart';

extension MaterialStateSet on Set<MaterialState> {
  bool get isHovered => contains(MaterialState.hovered);
  bool get isDisabled => contains(MaterialState.disabled);
  bool get isPressed => contains(MaterialState.pressed);
  bool get isSelected => contains(MaterialState.selected);
  bool get isFocused => contains(MaterialState.focused);
}

class AppThemeData {
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );
  ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scrollbarTheme: ScrollbarThemeData(
      radius: const Radius.circular(1.5),
      thumbColor: MaterialStateProperty.all(const Color(0x80FFFFFF)),
    ),
    colorSchemeSeed: const Color(0xb3e3c81b),
    splashColor: Colors.white12,
    highlightColor: Colors.white12,
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
          border: Border.all(color: CustomColorThemes.borderColorDark)),
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
      tabAlignment: TabAlignment.start,
      labelColor: Colors.white,
      dividerColor: Colors.transparent,
    ),
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
      backgroundColor: CustomColorThemes.pageDialogBackgroundColorDark,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
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
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(width: 3)),
    ),
  );
}
