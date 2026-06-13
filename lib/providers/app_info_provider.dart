import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoProvider extends ChangeNotifier {
  final PackageInfo _packageInfo;

  /// App 版本，例如 `1.0.0 + 1`
  String get appVersion =>
      '${_packageInfo.version}+${_packageInfo.buildNumber}';

  AppInfoProvider(this._packageInfo);
}
