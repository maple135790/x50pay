import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/app_lifecycle.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/go_route_generator.dart';
import 'package:x50pay/common/life_cycle_manager.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/app_settings_provider.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/providers/theme_provider.dart';

final languageProvider = LanguageProvider();
final themeProvider = AppThemeProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  themeProvider.configLoadingStyle();

  final appLocale = await languageProvider.getUserPrefLocale();
  final packageInfo = await PackageInfo.fromPlatform();
  GlobalSingleton.instance.setAppVersion =
      "${packageInfo.version}+${packageInfo.buildNumber}";
  languageProvider.currentLocale = appLocale;

  await GlobalSingleton.instance.getLoginStatus();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final router = goRouteConfig();

  const MyApp({super.key});

  ThemeData _buildThemeData({
    required ThemeData baseTheme,
    required Locale locale,
    required Color seedColor,
  }) {
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
      default:
        resolvedTextTheme = GoogleFonts.notoSansTextTheme(baseTheme.textTheme);
        break;
    }

    return baseTheme.copyWith(
      textTheme: resolvedTextTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: baseTheme.brightness,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LifecycleManager(
      callback: AppLifeCycles.instance,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: languageProvider),
          ChangeNotifierProvider.value(value: themeProvider),
          ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ],
        child: Consumer2<LanguageProvider, AppThemeProvider>(
          builder: (context, langVM, themeVM, child) {
            return MaterialApp.router(
              themeAnimationCurve: Easing.emphasizedAccelerate,
              themeAnimationDuration: const Duration(milliseconds: 50),
              themeMode: themeVM.currentMode,
              theme: _buildThemeData(
                locale: langVM.currentLocale,
                baseTheme: themeVM.themeData,
                seedColor: themeVM.seedColor,
              ),
              builder: EasyLoading.init(),
              routerConfig: router,
              locale: langVM.currentLocale,
              supportedLocales: S.delegate.supportedLocales,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}
