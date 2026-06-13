import 'dart:io';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:x50pay/storage/app_storage/app_storage.dart';

class CookieStorage {
  final AppStorage _storage;

  @visibleForTesting
  CookieStorage.internal(this._storage);

  CookieStorage() : _storage = AppStorage.secure();

  static const key = "set-cookie";
  static const _sessionKey = "session_id";

  String? _cache;
  DateTime? _expiresAt;

  void clear() {
    _storage.delete(StorageKey.cookie);
  }

  String getCachedCookie() {
    if (_expiresAt != null && DateTime.now().isAfter(_expiresAt!)) {
      throw CookieExpiredException();
    }
    return _cache!;
  }

  Future<String?> getStoredCookie({
    bool validate = false,
    bool setCacheAfterValidate = false,
  }) async {
    String? cookie = await _storage.read(StorageKey.cookie);
    if (!validate) return cookie;
    if (cookie == null) return null;
    final isValid = _validate(cookie);
    if (!isValid) return null;
    if (setCacheAfterValidate) _cache = cookie;
    return cookie;
  }

  bool _validate(String cookie) {
    if (_ageValidate(cookie) == false) return false;
    return _hasSessionId(cookie);
  }

  Future<void> setCookie(Map<String, String> headers) {
    final cookie = headers.entries.firstWhereOrNull((e) => e.key == key);
    if (cookie == null || !_hasSessionId(cookie.value)) return Future.value();
    _cache = cookie.value;
    final maxAge = Cookie.fromSetCookieValue(cookie.value).maxAge;
    if (maxAge != null) {
      _expiresAt = DateTime.now().add(Duration(seconds: maxAge));
    } else {
      _expiresAt = null;
    }

    return _storage.write(StorageKey.cookie, cookie.value);
  }

  bool _hasSessionId(String cookie) {
    return cookie.contains(_sessionKey);
  }

  bool? _ageValidate(String cookie) {
    final maxAge = Cookie.fromSetCookieValue(cookie).maxAge;
    if (maxAge == null) return null;
    return maxAge >= 60;
  }
}

class CookieNotFoundException implements Exception {
  @override
  String toString() => "Requesting cookie but nothing found.";
}

class CookieExpiredException implements Exception {
  @override
  String toString() => "Cookie has expired.";
}
