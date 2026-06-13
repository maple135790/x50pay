import 'package:x50pay/storage/storage.dart';

class MemoryStorage implements Storage {
  MemoryStorage._();

  static MemoryStorage get instance => _instance ??= MemoryStorage._();

  static MemoryStorage? _instance;

  final _storage = <String, String>{};

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<String?> read(String key) async {
    return _storage[key];
  }

  @override
  Future<void> write(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<Map<String, Object?>> readAll(Set<String> keys) async {
    return Map.of(_storage)..removeWhere((k, _) => !keys.contains(k));
  }
}
