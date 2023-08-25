import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  String serviceErrorText = '伺服器錯誤，請嘗試重新整理或回報X50';
  void showServiceError() {
    EasyLoading.showError(serviceErrorText,
        dismissOnTap: false, duration: const Duration(seconds: 2));
  }
}
