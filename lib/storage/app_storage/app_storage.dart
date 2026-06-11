import 'package:meta/meta.dart';
import 'package:x50pay/storage/app_storage/memory_storage.dart';
import 'package:x50pay/storage/app_storage/prefs_storage.dart';
import 'package:x50pay/storage/app_storage/secure_storage.dart';
import 'package:x50pay/storage/storage.dart';

class AppStorage {
  final Storage _storage;

  @visibleForTesting
  const AppStorage.internal({required this._storage});

  factory AppStorage.secure() {
    return const AppStorage.internal(storage: SecureStorage());
  }

  factory AppStorage.prefs() {
    return const AppStorage.internal(storage: PrefsStorage());
  }

  factory AppStorage.memory() {
    return AppStorage.internal(storage: MemoryStorage.instance);
  }

  Future<String?> read(StorageKey key) {
    return _storage.read(key.name);
  }

  Future<void> write(StorageKey key, String value) {
    return _storage.write(key.name, value);
  }

  Future<void> delete(StorageKey key) {
    return _storage.delete(key.name);
  }

  Future<void> copy(StorageKey from, {required StorageKey to}) async {
    final value = await read(from);
    if (value == null) return;
    return write(to, value);
  }

  @visibleForTesting
  Future<void> clearAll() {
    return _storage.clear();
  }
}

enum StorageKey { cookie }
