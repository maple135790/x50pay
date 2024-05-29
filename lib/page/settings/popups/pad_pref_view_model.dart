import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/repository/setting_repository.dart';

class PadPrefsViewModel extends BaseViewModel {
  final SettingRepository settingRepo;

  PadPrefsViewModel(this.settingRepo);

  static const defaultColor = Colors.black;

  String _nickname = '';
  String get nickname => _nickname;

  Color _showColor = defaultColor;
  Color get showColor => _showColor;

  bool _isNameHidden = false;
  bool get isNameHidden => _isNameHidden;

  void onIsNameShownChanged(bool value) {
    _isNameHidden = value;
    notifyListeners();
  }

  void onShowColorChanged(Color color) {
    _showColor = color;
    notifyListeners();
  }

  void onNicknameChanged(String value) {
    _nickname = value;
    notifyListeners();
  }

  /// 設定排隊平板偏好
  Future<void> setPadSettings({
    required VoidCallback onNotSet,
    required VoidCallback onSet,
  }) async {
    log('$isNameHidden, $showColor, $nickname', name: 'setPadSettings');

    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (kDebugMode && !isForceFetch) onSet.call();

      await settingRepo.setPadSettings(
        shname: nickname,
        shid: isNameHidden,
        shcolor: convertColorToHex(showColor),
      );
      final padPrefs = await settingRepo.getPadSettings();
      final returnedNickname = padPrefs.shname;

      if (returnedNickname != _nickname) throw const NicknameNotSetException();
      onSet.call();
    } on NicknameNotSetException {
      onNotSet.call();
      return;
    } on Exception catch (e) {
      log('', name: 'setPadSettings error', error: e);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  /// 取得排隊平板設定
  Future<void> getPadSettings() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final padPrefs = await settingRepo.getPadSettings();
      _nickname = padPrefs.shname;
      _isNameHidden = padPrefs.shid;
      _showColor = convertHexToColor(padPrefs.shcolor);

      log('$_nickname, $_isNameHidden, $_showColor', name: 'getPadSettings');
    } catch (e) {
      log('', name: 'getPadSettings', error: e);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  @visibleForTesting
  Color convertHexToColor(String hex) {
    final colorHex = hex.replaceFirst("#", '').padLeft(8, 'FF');
    return Color(int.parse(colorHex, radix: 16));
  }

  @visibleForTesting
  String convertColorToHex(Color color) {
    return color.value.toRadixString(16).substring(2).padLeft(7, '#');
  }
}

class NicknameNotSetException implements Exception {
  const NicknameNotSetException();
}
