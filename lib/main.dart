import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/app_lifecycle.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/go_route_generator.dart';
import 'package:x50pay/common/life_cycle_manager.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/app_settings_provider.dart';
import 'package:x50pay/providers/language_provider.dart';

final languageProvider = LanguageProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configLoadingStyle();

  final appLocale = await languageProvider.getUserPrefLocale();
  final packageInfo = await PackageInfo.fromPlatform();
  await GlobalSingleton.instance.getLoginStatus();
  GlobalSingleton.instance.setAppVersion =
      "${packageInfo.version}+${packageInfo.buildNumber}";
  languageProvider.currentLocale = appLocale;

  runApp(const MyApp());
}

/// [EasyLoading] 的設定
void configLoadingStyle() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..infoWidget = const SvgPicture(
      Svgs.torii,
      width: 80,
      height: 80,
      colorFilter: ColorFilter.mode(Color(0xfffafafa), BlendMode.srcIn),
    )
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
  static final router = goRouteConfig();

  const MyApp({super.key});

  ThemeData _buildTheme(Locale locale) {
    final baseTheme = AppThemeData().appTheme;
    late final TextTheme resolvedTextTheme;

    switch (locale.languageCode) {
      case 'zh':
        resolvedTextTheme =
            GoogleFonts.notoSansTcTextTheme(baseTheme.textTheme);
        break;
      case 'ja':
        resolvedTextTheme =
            GoogleFonts.notoSansJpTextTheme(baseTheme.textTheme);
        break;
      case 'en':
        resolvedTextTheme = GoogleFonts.notoSansTextTheme(baseTheme.textTheme);
        break;
      default:
        resolvedTextTheme = GoogleFonts.notoSansTextTheme(baseTheme.textTheme);
        break;
    }

    return baseTheme.copyWith(textTheme: resolvedTextTheme);
  }

  @override
  Widget build(BuildContext context) {
    return LifecycleManager(
      callback: AppLifeCycles.instance,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: languageProvider),
          ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ],
        child: Consumer<LanguageProvider>(
          builder: (context, vm, child) => MaterialApp.router(
            theme: _buildTheme(vm.currentLocale),
            builder: EasyLoading.init(),
            routerConfig: router,
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
        child: const SvgPicture(
          Svgs.spinnerSolid,
          width: 42,
          height: 42,
          colorFilter: ColorFilter.mode(Color(0xfffafafa), BlendMode.srcIn),
        ),
      ),
    );
  }
}
