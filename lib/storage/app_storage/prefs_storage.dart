import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/storage/storage.dart';

class PrefsStorage implements Storage {
  const PrefsStorage();

  SharedPreferencesAsync get _sp => SharedPreferencesAsync();

  @override
  Future<String?> read(String key) async {
    final value = await _sp.getString(key);
    if (value == 'null') return null;
    return value;
  }

  @override
  Future<void> write(String key, String value) {
    return _sp.setString(key, value);
  }

  @override
  Future<void> delete(String key) {
    return _sp.remove(key);
  }

  @override
  @visibleForTesting
  Future<void> clear() {
    return _sp.clear();
  }

  @override
  Future<Map<String, Object?>> readAll(Set<String> keys) {
    return _sp.getAll(allowList: keys);
  }
}
