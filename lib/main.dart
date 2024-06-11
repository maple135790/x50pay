import 'dart:developer';

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
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/providers/app_settings_provider.dart';
import 'package:x50pay/providers/coin_insertion_provider.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/providers/theme_provider.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/repository.dart';

final languageProvider = LanguageProvider();
final themeProvider = AppThemeProvider();

/// 檢查登入狀態
Future<bool> getLoginStatus() async {
  late final bool isLogined;
  log('get login status...', name: 'getLoginStatus');
  try {
    // 檢查是否存在之前登入的session
    final sess = await Prefs.secureRead(SecurePrefsToken.session);
    if (sess == null) {
      log('no session', name: 'getLoginStatus');

      return false;
    }
    // 嘗試登入，檢查session是否有效
    final fetchedUser = await Repository().getUser();
    if (fetchedUser == null || fetchedUser.code != 200) {
      log('session invalid', name: 'getLoginStatus');
      isLogined = false;
    } else {
      log('session valid', name: 'getLoginStatus');
      isLogined = true;
    }
    return isLogined;
  } catch (e, stacktrace) {
    log('', error: e, stackTrace: stacktrace, name: 'getLoginStatus');
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  themeProvider.configLoadingStyle();

  final appLocale = await languageProvider.getUserPrefLocale();
  final packageInfo = await PackageInfo.fromPlatform();
  GlobalSingleton.instance.setAppVersion =
      "${packageInfo.version}+${packageInfo.buildNumber}";
  languageProvider.currentLocale = appLocale;

  final isInitiallyLogin = await getLoginStatus();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await themeProvider.init();

  runApp(MyApp(
    AppRouter.config(isInitiallyLogin),
  ));
}

class MyApp extends StatelessWidget {
  final RouterConfig<Object> routeConfig;
  const MyApp(this.routeConfig, {super.key});

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
    final repo = Repository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => CoinInsertionProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => EntryProvider(repo: repo)),
        ChangeNotifierProvider(create: (_) => LoginProvider(repo: repo)),
        ChangeNotifierProvider(create: (_) => UserProvider(repo: repo)),
      ],
      builder: (context, child) {
        return LifecycleManager(
          callback: AppLifeCycles.instance,
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
                routerConfig: routeConfig,
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
        );
      },
    );
  }
}
