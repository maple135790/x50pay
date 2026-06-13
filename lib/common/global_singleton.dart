import 'package:x50pay/common/models/cabinet/cabinet.dart';

/// 全域變數
///
/// 用於儲存全域變數，例如最近遊玩的機台資料、服務連接位置等。
class GlobalSingleton {
  static GlobalSingleton? _instance;

  GlobalSingleton._();

  static GlobalSingleton get instance => _instance ??= GlobalSingleton._();

  /// 最近遊玩的機台資料
  ({Cabinet cabinet, String caboid, int cabNum})? recentPlayedCabinetData;
}
