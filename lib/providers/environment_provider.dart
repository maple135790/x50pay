import 'package:flutter/foundation.dart';

class EnvironmentProvider extends ChangeNotifier {
  bool _debugIsServiceOnline = true;

  bool get debugIsServiceOnline => _debugIsServiceOnline;

  bool get isServiceOnline => kReleaseMode || debugIsServiceOnline;

  void toggleDebugServiceStatus() {
    _debugIsServiceOnline = !_debugIsServiceOnline;
    notifyListeners();
  }
}
