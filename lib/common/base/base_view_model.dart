import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/generated/l10n.dart';

class BaseViewModel extends ChangeNotifier {
  final isForceFetch = GlobalSingleton.instance.isServiceOnline;

  static bool get duringTest =>
      Platform.environment.containsKey('FLUTTER_TEST');

  String get serviceErrorMessage => duringTest ? '' : S.current.serviceError;

  void showLoading() {
    if (duringTest) return;
    dismissLoading();
    EasyLoading.show();
  }

  void dismissLoading() {
    if (duringTest) return;
    if (EasyLoading.isShow) EasyLoading.dismiss();
  }

  void showSuccess(String text) {
    if (duringTest) return;
    EasyLoading.showSuccess(text);
  }

  void showError(String text) {
    if (duringTest) return;
    EasyLoading.showError(text);
  }

  void showInfo(String text, {Duration duration = const Duration(seconds: 1)}) {
    if (duringTest) return;
    EasyLoading.showInfo(text, duration: duration);
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
