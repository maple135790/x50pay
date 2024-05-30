import 'package:flutter/services.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/gen/assets.gen.dart';

class LicenseViewModel extends BaseViewModel {
  Future<String> getLicense() async {
    final l = await rootBundle.loadString(R.texts.license);
    return l;
  }
}
