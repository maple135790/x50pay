import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';

/// 全域變數
///
/// 用於儲存全域變數，例如最近遊玩的機台資料、服務連接位置等。
class GlobalSingleton {
  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  static final duringTest = Platform.environment.containsKey('FLUTTER_TEST');

  /// 服務是否連接到X50Pay。
  ///
  /// 服務連接到X50Pay時，會將此值設為true。User 資料等會從伺服器取得。
  final isServiceOnline = (kReleaseMode || duringTest) || true;

  /// 全域的 navigatorKey
  ///
  /// 在不特定頁面顯示 dialog 時使用
  static final appNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'Global navigatorKey');

  /// 是否正在顯示 NfcPay 的 dialog
  ///
  /// 用來防止重複顯示 dialog
  bool isNfcPayDialogOpen = false;

  /// 最近遊玩的機台資料
  ({Cabinet cabinet, String caboid, int cabNum})? recentPlayedCabinetData;

  /// App 版本，例如 `X50Pay app v1.0.0 + 1`
  String get appVersion => _appVersion;
  String _appVersion = '';
  set setAppVersion(String value) {
    _appVersion = 'X50Pay app v$value';
  }

  /// 是否在掃描QRCode頁面的旗標
  ///
  /// 由於go_router 在pushNamed 無法取得location，
  /// 因此使用此旗標來判斷是否在掃描QRCode頁面。
  bool isInCameraPage = false;
}
