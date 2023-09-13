import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/app_lifecycle.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/go_route_generator.dart';
import 'package:x50pay/common/life_cycle_manager.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/language_view_model.dart';
import 'package:x50pay/r.g.dart';

/// 檢查是否有登入
///
/// 檢查 [SharedPreferences] 中是否有 [session] 的 key，
/// 若有效則回傳 true，否則回傳 false
Future<bool> _checkLogin() async {
  final pref = await SharedPreferences.getInstance();
  final sess = pref.getString('session');
  if (sess == null) return false;
  return await GlobalSingleton.instance.checkUser();
}

final languageViewModel = LanguageViewModel();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appLocale = await languageViewModel.getUserPrefLocale();
  final packageInfo = await PackageInfo.fromPlatform();
  final islogin = await _checkLogin();
  log('isServiceOnline: ${GlobalSingleton.instance.isServiceOnline}',
      name: 'main');
  log('islogin: $islogin', name: 'main');
  configLoadingStyle();
  GlobalSingleton.instance.setAppVersion =
      "${packageInfo.version}+${packageInfo.buildNumber}";
  languageViewModel.currentLocale = appLocale;
  runApp(MyApp(isLogin: islogin));
}

/// [EasyLoading] 的設定
void configLoadingStyle() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..infoWidget = Image(
        image: R.svg.torii(width: 80, height: 80),
        color: const Color(0xfffafafa))
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = const Color(0xff2a2a2a)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..indicatorSize = 80
    ..contentPadding =
        const EdgeInsets.symmetric(vertical: 22.5, horizontal: 15)
    ..indicatorWidget = const _Spinner()
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({required this.isLogin, super.key});

  @override
  Widget build(BuildContext context) {
    return LifecycleManager(
      callback: AppLifeCycles(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: languageViewModel),
        ],
        child: Consumer<LanguageViewModel>(
          builder: (context, vm, child) => MaterialApp.router(
            theme: AppThemeData().materialTheme,
            builder: EasyLoading.init(),
            routerConfig: goRouteConfig(isLogin),
            locale: vm.currentLocale,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          ),
        ),
      ),
    );
  }
}

/// 旋轉的圖示
///
/// 用於 [EasyLoading] 的 [indicatorWidget]
class _Spinner extends StatefulWidget {
  const _Spinner();

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
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
        child: Image(
            image: R.svg.spinner_solid(width: 42, height: 42),
            color: Colors.white),
      ),
    );
  }
}
