import 'package:flutter/widgets.dart';

class HomeRefreshProvider {
  VoidCallback? _refreshCallback;

  void refresh() {
    _refreshCallback?.call();
  }

  void registerRefreshCallback(VoidCallback callback) {
    if (_refreshCallback != null) return;
    _refreshCallback = callback;
  }
}
