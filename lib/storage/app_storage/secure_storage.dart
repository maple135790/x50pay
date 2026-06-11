import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:x50pay/storage/storage.dart';

class SecureStorage implements Storage {
  const SecureStorage();

  static const _secure = FlutterSecureStorage();

  @override
  Future<String?> read(String key) async {
    return await _secure.read(key: key);
  }

  @override
  Future<void> write(String key, String value) async {
    await _secure.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _secure.delete(key: key);
  }

  @override
  @visibleForTesting
  Future<void> clear() async {
    await _secure.deleteAll();
  }
}
