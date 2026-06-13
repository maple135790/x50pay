import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:x50pay/common/client/request_handler.dart';
import 'package:x50pay/storage/cookie_storage.dart';

class AppClient extends RequestHandler {
  final http.Client _client;
  final CookieStorage _cookieStorage;

  static final _logger = Logger('AppClient');

  @visibleForTesting
  AppClient.internal(this._client, this._cookieStorage);

  AppClient(this._cookieStorage) : _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }

  @override
  Future<http.Response> request(
    Uri url, {
    required HttpMethod method,
    Map<String, dynamic> rawBody = const {},
    ContentType contentType = ContentType.json,
    Map<String, String> customHeaders = const {},
    bool withSession = true,
  }) async {
    final headers = Map.of(customHeaders);
    try {
      headers.addAll({
        "Referer": "https://pay.x50.fun/",
        if (method != HttpMethod.get) "Origin": "https://pay.x50.fun",
        if (method != HttpMethod.get) "Content-Type": contentType.value,
        if (withSession) "Cookie": _cookieStorage.getCachedCookie(),
      });
    } on CookieNotFoundException catch (e) {
      _logger.warning('', e);
    }

    final req = http.Request(method.value, url)..headers.addAll(headers);
    if (method == HttpMethod.post && contentType == ContentType.json) {
      req.bodyBytes = json.encode(rawBody).codeUnits;
    }

    final res = await http.Response.fromStream(await send(req));

    if (res.headers.containsKey(CookieStorage.key)) {
      await _cookieStorage.setCookie(res.headers);
    }

    return res;
  }
}
