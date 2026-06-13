import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:x50pay/generated/l10n.dart';

mixin AppFeedbackMixin {
  BuildContext get context;

  String get serviceErrorText => S.of(context).serviceError;

  void showServiceError() {
    EasyLoading.showError(
      serviceErrorText,
      dismissOnTap: false,
      duration: const Duration(seconds: 2),
    );
  }

  void showLoading() {
    dismissLoading();
    EasyLoading.show();
  }

  void dismissLoading() {
    if (!EasyLoading.isShow) return;
    EasyLoading.dismiss();
  }

  void showSuccess(String text) {
    EasyLoading.showSuccess(text);
  }

  void showError(String text) {
    EasyLoading.showError(text);
  }

  void showInfo(String text, {Duration duration = const Duration(seconds: 1)}) {
    EasyLoading.showInfo(text, duration: duration);
  }
}
