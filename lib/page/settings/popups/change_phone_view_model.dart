import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/repository/setting_repository/setting_repository.dart';

class ChangePhoneViewModel extends BaseViewModel {
  final SettingRepository settingRepo;

  ChangePhoneViewModel(this.settingRepo);

  final phoneRegex = RegExp("^09\\d{2}-?\\d{3}-?\\d{3}\$");

  String? _errorText;
  String? get errorText => _errorText;

  bool _isSentSmsCode = false;
  bool get isSentSmsCode => _isSentSmsCode;

  /// 變更手機號碼API
  ///
  /// 用於取消綁定手機號碼
  Future<bool> removePhone() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final response = await settingRepo.changePhone();
      return response.code == 200;
    } catch (e) {
      log('', name: 'detachPhone', error: e);
      return false;
    } finally {
      dismissLoading();
    }
  }

  /// 變更手機號碼
  ///
  /// 用於綁定新手機號碼，需要傳入新手機號碼 [phone]
  Future<void> changePhone({
    required String phone,
    required VoidCallback onChangeFailed,
    required VoidCallback onChangeSuccess,
  }) async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final response = await settingRepo.doChangePhone(phone: phone);
      if (response == BasicResponse.empty() || response.code != 200) {
        onChangeFailed.call();
        return;
      }

      onChangeSuccess.call();
      _isSentSmsCode = true;
      notifyListeners();
    } on Exception catch (e, s) {
      log('', name: 'changePhone', error: e, stackTrace: s);

      onChangeFailed.call();
    } finally {
      dismissLoading();
    }
  }

  /// 驗證簡訊碼
  ///
  /// 用於驗證新手機號碼，需要傳入簡訊驗證碼 [smsCode]
  Future<void> smsActivate({
    required String smsCode,
    required VoidCallback onActivateFailed,
    required VoidCallback onActivateSuccess,
  }) async {
    if (smsCode.length != 6) {
      _errorText = '驗證碼長度錯誤';
      notifyListeners();
      return;
    }

    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      final response = await settingRepo.smsActivate(sms: smsCode);

      if (response == BasicResponse.empty()) {
        onActivateFailed.call();
        return;
      } else if (response.code == 700) {
        showError('驗證碼輸入錯誤，請檢查');
        return;
      } else if (response.code != 200) {
        onActivateFailed.call();
        return;
      }

      showSuccess('簡訊驗證成功！');
      await Future.delayed(const Duration(seconds: 2));
      onActivateSuccess.call();
    } on Exception catch (e, s) {
      log('', name: 'smsActivate', error: e, stackTrace: s);
      onActivateFailed.call();
    } finally {
      dismissLoading();
    }
  }

  bool checkPhoneFormat(String phone) {
    final isValidPhone = phoneRegex.hasMatch(phone);
    if (!isValidPhone) {
      _errorText = '手機號碼格式錯誤';
    } else {
      _errorText = null;
    }
    notifyListeners();
    return isValidPhone;
  }
}
