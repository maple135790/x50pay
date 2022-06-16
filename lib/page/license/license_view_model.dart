import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/r.g.dart';

class LicenseViewModel extends BaseViewModel {
  Future<String> getLicense() async {
    String l = await R.text.license_txt();
    return l;
  }
}
