import 'dart:io';

import 'package:x50pay/common/models/cabinet/cabinet.dart';

/// 全域變數
///
/// 用於儲存全域變數，例如最近遊玩的機台資料、服務連接位置等。
class GlobalSingleton {
  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  static final duringTest = Platform.environment.containsKey('FLUTTER_TEST');

  /// 是否正在顯示 NfcPay 的 dialog
  ///
  /// 用來防止重複顯示 dialog
  bool isNfcPayDialogOpen = false;

  /// 最近遊玩的機台資料
  ({Cabinet cabinet, String caboid, int cabNum})? recentPlayedCabinetData;

  /// 是否在掃描QRCode頁面的旗標
  ///
  /// 由於go_router 在pushNamed 無法取得location，
  /// 因此使用此旗標來判斷是否在掃描QRCode頁面。
  bool isInCameraPage = false;
}
