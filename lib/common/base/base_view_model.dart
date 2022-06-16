import 'package:flutter/material.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isFloatHeader = false;
  bool get isFloatHeader => _isFloatHeader;

  set isFloatHeader(bool value) {
    _isFloatHeader = value;
    notifyListeners();
  }

  bool _isShowFooter = false;
  bool get isShowFooter => _isShowFooter;

  set isShowFooter(bool value) {
    _isShowFooter = value;
    notifyListeners();
  }

  bool _isHeaderBackType = false;
  bool get isHeaderBackType => _isHeaderBackType;

  set isHeaderBackType(bool value) {
    _isHeaderBackType = value;
    notifyListeners();
  }
}
