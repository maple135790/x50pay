import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/generated/l10n.dart';

abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  late final i18n = S.of(context);
  late String serviceErrorText = i18n.serviceError;
  void showServiceError() {
    EasyLoading.showError(serviceErrorText,
        dismissOnTap: false, duration: const Duration(seconds: 2));
  }
}
