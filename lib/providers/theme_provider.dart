import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';

extension MaterialStateSet on Set<WidgetState> {
  bool get isHovered => contains(WidgetState.hovered);
  bool get isDisabled => contains(WidgetState.disabled);
  bool get isPressed => contains(WidgetState.pressed);
  bool get isSelected => contains(WidgetState.selected);
  bool get isFocused => contains(WidgetState.focused);
}

extension AppThemeMode on ThemeMode {
  ThemeData get themeData {
    switch (this) {
      case ThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          }),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(1.5),
            thumbColor: WidgetStateProperty.all(const Color(0x80FFFFFF)),
          ),
          scaffoldBackgroundColor: const Color(0xfff2f2f2),
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.transparent,
            backgroundColor: CustomColorThemes.pageDialogBackgroundColorLight,
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Color(0xfff2f2f2),
            contentTextStyle: TextStyle(color: Color(0xff1e1e1e)),
          ),
          dataTableTheme: DataTableThemeData(
            headingTextStyle: const TextStyle(color: Color(0xff5a5a5a)),
            headingRowColor: WidgetStateProperty.all(const Color(0xfff2f2f2)),
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              border: Border.all(
                color: CustomColorThemes.borderColorLight,
              ),
            ),
          ),
          navigationBarTheme: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            labelTextStyle: WidgetStateProperty.resolveWith(
              (states) {
                if (!states.isSelected) return null;
                return TextStyle(
                  color: Color.alphaBlend(
                    const Color(0x55000000),
                    const Color(0xb3e3c81b),
                  ),
                  fontSize: 11,
                );
              },
            ),
          ),
          tabBarTheme: const TabBarTheme(
            tabAlignment: TabAlignment.start,
            dividerHeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            splashFactory: NoSplash.splashFactory,
            dividerColor: Colors.transparent,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xffd2d2d2),
            hintStyle: TextStyle(color: Color(0xff757575)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff505050),
                width: 3,
              ),
            ),
            isDense: true,
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 3,
              ),
            ),
          ),
        );

      case ThemeMode.system:
      case ThemeMode.dark:
        return ThemeData(
          useMaterial3: true,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(1.5),
            thumbColor: WidgetStateProperty.all(const Color(0x80FFFFFF)),
          ),
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
            ),
          ),
          dataTableTheme: DataTableThemeData(
            headingTextStyle: const TextStyle(color: Color(0xfffafafa)),
            headingRowColor: WidgetStateProperty.all(const Color(0xff2a2a2a)),
            decoration: BoxDecoration(
              color: const Color(0xff1e1e1e),
              border: Border.all(
                color: CustomColorThemes.borderColorDark,
              ),
            ),
          ),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          }),
          dialogTheme: const DialogTheme(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Color(0xff1e1e1e),
            titleTextStyle: TextStyle(
              color: Color(0xfffafafa),
              fontSize: 20,
              wordSpacing: 0.15,
            ),
          ),
          dialogBackgroundColor: const Color(0xff1e1e1e),
          dividerTheme: const DividerThemeData(color: Color(0xff3e3e3e)),
          tabBarTheme: const TabBarTheme(
            tabAlignment: TabAlignment.start,
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
          ),
          scaffoldBackgroundColor: const Color(0xff1e1e1e),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: Color(0xff1e1e1e),
            contentTextStyle: TextStyle(color: Color(0xfffafafa)),
          ),
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: const Color(0xff1e1e1e),
            indicatorColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (!states.isSelected) return null;
              return const TextStyle(
                color: Color(0xb3e3c81b),
                fontSize: 11,
              );
            }),
            iconTheme: WidgetStateProperty.resolveWith((states) {
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
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.white),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xff2a2a2a),
            hintStyle: TextStyle(color: Color(0xff757575)),
            prefixIconColor: Color(0xfffafafa),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff505050),
                width: 3,
              ),
            ),
            isDense: true,
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
                width: 3,
              ),
            ),
          ),
        );
    }
  }
}

class AppThemeProvider extends ChangeNotifier {
  static const defaultSeedColor = Color(0xffE3C81B);

  ThemeData get themeData => currentMode.themeData;

  Color get seedColor => _seedColor;
  Color _seedColor = defaultSeedColor;
  set seedColor(Color value) {
    _seedColor = value;
    notifyListeners();
  }

  ThemeMode get currentMode => _currentMode;
  ThemeMode _currentMode = ThemeMode.dark;
  set currentMode(ThemeMode value) {
    _currentMode = value;
    notifyListeners();
  }

  void configLoadingStyle() {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..infoWidget = SvgPicture(
        Svgs.torii,
        width: 80,
        height: 80,
        colorFilter: ColorFilter.mode(
          currentMode == ThemeMode.dark
              ? const Color(0xfffafafa)
              : const Color(0xff1e1e1e),
          BlendMode.srcIn,
        ),
      )
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = currentMode == ThemeMode.dark
          ? const Color(0xff2a2a2a)
          : const Color(0xfff2f2f2)
      ..indicatorColor =
          currentMode == ThemeMode.dark ? Colors.white : Colors.black
      ..textColor = currentMode == ThemeMode.dark ? Colors.white : Colors.black
      ..indicatorSize = 80
      ..contentPadding =
          const EdgeInsets.symmetric(vertical: 22.5, horizontal: 15)
      ..indicatorWidget = const _Spinner()
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  Future<void> init() async {
    final isEnabledDarkTheme = await Prefs.getBool(PrefsToken.enableDarkTheme);
    final seedColor = await Prefs.getInt(PrefsToken.seedColor);
    if (isEnabledDarkTheme != null) {
      currentMode = isEnabledDarkTheme ? ThemeMode.dark : ThemeMode.light;
    }
    if (seedColor != null) {
      this.seedColor = Color(seedColor);
    }
    configLoadingStyle();
    return;
  }

  void resetTheme() {
    seedColor = defaultSeedColor;
    currentMode = ThemeMode.dark;
    configLoadingStyle();
    return;
  }

  void changeBrightness(Brightness brightness) {
    currentMode =
        brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
    configLoadingStyle();
    return;
  }
}

/// 旋轉的圖示
///
/// 用於 [EasyLoading.indicatorWidget]
class _Spinner extends StatefulWidget {
  const _Spinner();

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: RotationTransition(
        turns: _animation,
        child: SvgPicture(
          Svgs.spinnerSolid,
          width: 42,
          height: 42,
          colorFilter: const ColorFilter.mode(
            Color(0xfffafafa),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
