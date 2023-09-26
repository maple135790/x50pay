import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/global_singleton.dart';

class BaseViewModel extends ChangeNotifier {
  final isForceFetch = GlobalSingleton.instance.isServiceOnline;

  bool get _duringTest => Platform.environment.containsKey('FLUTTER_TEST');

  void showLoading() {
    if (_duringTest) return;
    dismissLoading();
    EasyLoading.show();
  }

  void dismissLoading() {
    if (_duringTest) return;
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  bool _isFunctionalHeader = true;
  bool get isFunctionalHeader => _isFunctionalHeader;

  set isFunctionalHeader(bool value) {
    _isFunctionalHeader = value;
    notifyListeners();
  }

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

  String? _floatHeaderText;
  String? get floatHeaderText => _floatHeaderText;

  set floatHeaderText(String? value) {
    _floatHeaderText = value;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
