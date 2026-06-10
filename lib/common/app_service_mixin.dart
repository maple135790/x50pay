import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:x50pay/generated/l10n.dart';

mixin AppServiceMixin {
  BuildContext get context;

  String get serviceErrorText => S.of(context).serviceError;

  void showServiceError() {
    EasyLoading.showError(
      serviceErrorText,
      dismissOnTap: false,
      duration: const Duration(seconds: 2),
    );
  }
}
