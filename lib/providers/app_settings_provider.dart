import 'package:flutter/foundation.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/storage/app_storage/app_storage.dart';

class AppSettingsProvider extends ChangeNotifier {
  final AppStorage _storage;

  AppSettingsProvider() : _storage = AppStorage.prefs();

  String? get favGameName => _favGameName;
  String? _favGameName;

  final _useLiquidGlassThemeFallback = true;

  set favGameName(String? value) {
    _favGameName = value;
    notifyListeners();
  }

  void setFavGameName(String? name) {
    Prefs.setString(PrefsToken.summaryFavGameName, name ?? '');
    favGameName = name;
  }

  Future<void> getSummaryFavGameName() async {
    final name = await Prefs.getString(PrefsToken.summaryFavGameName);
    favGameName = name;
    return;
  }

  Future<bool> getIsEnableSummarizedRecord() async {
    final enabled = await Prefs.getBool(PrefsToken.enableSummarizedRecord);
    // TODO(kenneth) : 等待0mu web 版寫完後開放
    return (enabled ?? PrefsToken.enableSummarizedRecord.defaultValue) &&
        kDebugMode;
  }

  Future<bool> getUseLiquidGlassTheme() async {
    final value = await _storage.read(StorageKey.useLiquidGlassTheme) ?? "";
    return bool.tryParse(value) ?? _useLiquidGlassThemeFallback;
  }
}
