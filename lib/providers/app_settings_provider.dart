import 'package:flutter/foundation.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';

class AppSettingsProvider extends ChangeNotifier {
  String? get favGameName => _favGameName;
  String? _favGameName;
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
}
