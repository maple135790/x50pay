import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:x50pay/generated/l10n.dart';

mixin AppFeedbackMixin {
  BuildContext get context;

  String get serviceErrorText => S.of(context).serviceError;

  Future<void> showServiceError() {
    return EasyLoading.showError(
      serviceErrorText,
      dismissOnTap: false,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> showLoading() {
    dismissLoading();
    return EasyLoading.show();
  }

  Future<void> dismissLoading() {
    if (!EasyLoading.isShow) return Future.value();
    return EasyLoading.dismiss();
  }

  Future<void> showSuccess(String text) {
    return EasyLoading.showSuccess(text);
  }

  Future<void> showError(String text) {
    return EasyLoading.showError(text);
  }

  Future<void> showInfo(
    String text, {
    Duration duration = const Duration(seconds: 1),
  }) {
    return EasyLoading.showInfo(text, duration: duration);
  }
}
