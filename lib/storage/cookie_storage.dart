import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:x50pay/storage/app_storage/app_storage.dart';

class CookieStorage {
  final AppStorage _storage;

  @visibleForTesting
  CookieStorage.internal(this._storage);

  CookieStorage() : _storage = AppStorage.secure();

  static const key = "Cookie";

  String? _cache;

  Future<String> getCookie() async {
    if (_cache != null) return _cache!;
    final cookie = await _storage.read(StorageKey.cookie);
    if (cookie == null) throw CookieNotFoundException();
    return cookie;
  }

  Future<void> setCookie(Map<String, String> headers) {
    final cookie = headers.entries.firstWhereOrNull((e) => e.key == key);
    if (cookie == null) return Future.value();
    _cache = cookie.value;
    return _storage.write(StorageKey.cookie, cookie.value);
  }
}

class CookieNotFoundException implements Exception {
  @override
  String toString() => "Requesting cookie but nothing found.";
}
