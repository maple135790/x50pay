import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:x50pay/storage/storage.dart';

class SecureStorage implements Storage {
  const SecureStorage();

  static const _secure = FlutterSecureStorage();

  @override
  Future<String?> read(String key) {
    return _secure.read(key: key);
  }

  @override
  Future<void> write(String key, String value) {
    return _secure.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) {
    return _secure.delete(key: key);
  }

  @override
  @visibleForTesting
  Future<void> clear() {
    return _secure.deleteAll();
  }

  @override
  Future<Map<String, dynamic>> readAll(Set<String> keys) async {
    final map = await _secure.readAll();
    return map..removeWhere((k, _) => !keys.contains(k));
  }
}
