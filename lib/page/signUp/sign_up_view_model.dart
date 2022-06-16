import 'package:x50pay/common/base/base.dart';

class SignUpViewModel extends BaseViewModel {
  bool _isPasswordValid = true;
  bool get isPasswordValid => _isPasswordValid;

  set isPasswordValid(bool value) {
    _isPasswordValid = value;
    notifyListeners();
  }

  void passwordChk(String? s, String? reS) {
    isPasswordValid = s == reS;
  }

  String? isEmpty(String? s) {
    if (s == null || s.isEmpty) return '請輸入文字';
    return null;
  }

  String? isDateValid(String? s) {
    if (s == null || s.isEmpty) return '請輸入文字';
    if (s.length < 8) return '格式錯誤(格式:19110101)';
    if (int.tryParse(s) == null) return '請輸入半形數字';
    return null;
  }

  String? isEmailValid(String? s) {
    if (s == null || s.isEmpty) return '請輸入文字';
    final emailReg = RegExp("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}");
    if (!emailReg.hasMatch(s)) return 'Email 格式錯誤';
    return null;
  }
}
