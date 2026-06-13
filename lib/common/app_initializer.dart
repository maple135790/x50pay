import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logging/logging.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/providers/theme_provider.dart';

class AppInitializer {
  final LanguageProvider _langProvider;
  final AppThemeProvider _themeProvider;
  final LoginProvider _loginProvider;

  AppInitializer(this._langProvider, this._themeProvider, this._loginProvider);

  bool _splashRemoved = false;

  Future<void> initialize() async {
    _initLogger();
    _themeProvider.configLoadingStyle();

    final (appLocale, _, _) = await (
      _langProvider.getUserPrefLocale(),
      _themeProvider.init(),
      _loginProvider.autoLogin(),
    ).wait;

    _langProvider.currentLocale = appLocale;

    if (!_splashRemoved) {
      _splashRemoved = true;
      FlutterNativeSplash.remove();
    }
  }

  void _initLogger() {
    hierarchicalLoggingEnabled = true;
    Logger.root.level = kReleaseMode ? Level.WARNING : Level.ALL;
    Logger.root.onRecord.listen((record) {
      log(
        record.message,
        time: record.time,
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
        name: record.loggerName,
      );
      if (kReleaseMode) {
        // TODO: 新增 FirebaseCrashlytics
      }
    });
  }
}
