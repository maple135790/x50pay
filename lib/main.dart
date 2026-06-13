import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/app_lifecycle.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/client/app_client.dart';
import 'package:x50pay/common/life_cycle_manager.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/providers/app_info_provider.dart';
import 'package:x50pay/providers/app_settings_provider.dart';
import 'package:x50pay/providers/coin_insertion_provider.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/environment_provider.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/providers/theme_provider.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/main_repository/api_main_repository.dart';
import 'package:x50pay/repository/main_repository/local_main_repository.dart';
import 'package:x50pay/repository/repository_factory.dart';
import 'package:x50pay/repository/setting_repository/api_setting_repository.dart';
import 'package:x50pay/repository/setting_repository/local_settings_repository.dart';
import 'package:x50pay/route/app_router.dart';
import 'package:x50pay/service/game_insert_service.dart';
import 'package:x50pay/service/qr_pay_service.dart';
import 'package:x50pay/storage/cookie_storage.dart';

void main() async {
  final widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final languageProvider = LanguageProvider();
  final themeProvider = AppThemeProvider();
  final envProvider = EnvironmentProvider();
  final cookieStorage = CookieStorage();
  final appClient = AppClient(cookieStorage);
  final appRouter = AppRouter();
  final repo = RepositoryFactory.create(
    envProvider,
    apiBuilder: () => ApiMainRepository(appClient),
    localBuilder: () => LocalMainRepository(),
  );
  final settingsRepo = RepositoryFactory.create(
    envProvider,
    apiBuilder: () => ApiSettingRepository(appClient),
    localBuilder: () => LocalSettingsRepository(),
  );
  final entryProvider = EntryProvider(repo: repo);
  final userProvider = UserProvider(repo: repo);
  final loginProvider = LoginProvider(
    repo,
    cookieStorage,
    onInvalidCookie: () {
      appRouter.router.refresh();
    },
    onShowLoginSuccessDialog: () async {
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 150));
      EasyLoading.showSuccess(
        '登入成功，歡迎回來',
        duration: const Duration(milliseconds: 800),
      );
      await Future.delayed(const Duration(milliseconds: 800));
      EasyLoading.dismiss();
      await Future.delayed(const Duration(milliseconds: 350));
    },
  );

  final gameInsertService = GameInsertService(
    repository: repo,
    onAfterInserted: () async {
      await userProvider.checkUser();
      await entryProvider.checkEntry();
    },
  );

  final qrPayService = QRPayService(
    repository: repo,
    onAfterInserted: () async {
      await userProvider.checkUser();
      await entryProvider.checkEntry();
    },
    settingRepo: settingsRepo,
    gameInsertService: gameInsertService,
  );
  final appLifeCycles = AppLifeCycles(
    repo,
    settingsRepo,
    gameInsertService,
    loginProvider,
    onShowQrPayCabSelectDialog: (qrPayData) async {
      EasyLoading.dismiss();
      await showDialog(
        context: AppRouter.rootNavigatorKey.currentContext!,
        builder: (context) => CabSelect.fromQRPay(qrPayData: qrPayData),
      );
    },
  );
  final initializer = AppInitializer(
    languageProvider,
    themeProvider,
    loginProvider,
  );

  final (packageInfo,) = await initializer.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: loginProvider),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider.value(value: entryProvider),
        ChangeNotifierProvider.value(value: envProvider),
        ChangeNotifierProvider(create: (_) => CoinInsertionProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => AppInfoProvider(packageInfo)),
        Provider.value(value: repo),
        Provider.value(value: settingsRepo),
        Provider.value(value: gameInsertService),
        Provider.value(value: qrPayService),
      ],
      child: LifecycleManager(callback: appLifeCycles, child: MyApp(appRouter)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp(this.appRouter, {super.key});

  static bool _rootFeedbackServiceCreated = false;

  void _registerFeedbackService(BuildContext context) {
    final rootUserFeedbackService = _RootAppFeedbackService(context);
    GameInsertService.registerRootFeedbackService(rootUserFeedbackService);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, AppThemeProvider>(
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
          routerConfig: appRouter.router,
          locale: langVM.currentLocale,
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          builder: (context, child) {
            if (!_rootFeedbackServiceCreated) {
              _registerFeedbackService(context);
              _rootFeedbackServiceCreated = true;
            }

            return EasyLoading.init()(context, child);
          },
        );
      },
    );
  }
}

ThemeData _buildThemeData({
  required ThemeData baseTheme,
  required Locale locale,
  required Color seedColor,
}) {
  final resolvedTextTheme = switch (locale.languageCode) {
    'zh' => GoogleFonts.notoSansTcTextTheme(baseTheme.textTheme),
    'ja' => GoogleFonts.notoSansJpTextTheme(baseTheme.textTheme),
    'en' || _ => GoogleFonts.notoSansTextTheme(baseTheme.textTheme),
  };
  return baseTheme.copyWith(
    textTheme: resolvedTextTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: baseTheme.brightness,
    ),
  );
}

class _RootAppFeedbackService with AppFeedbackMixin {
  @override
  final BuildContext context;

  const _RootAppFeedbackService(this.context);
}
