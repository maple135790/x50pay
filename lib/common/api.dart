import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:x50pay/common/global_singleton.dart';

class Api {
  /// X50Pay API domain
  static String get domainBase => 'https://pay.x50.fun/api/v1';

  /// 完整的URL，包含X50Pay domain
  static Uri _fullURL(String dest) => Uri.parse(domainBase + dest);

  static void _checkNewSession(Map<String, String> headers) async {
    if (headers['set-cookie']?.isEmpty ?? true) return;
    String newSession = '';
    final cookies = headers['set-cookie']!.split(';');
    for (var cookie in cookies) {
      if (!cookie.contains('session=')) continue;
      newSession = cookie.split('=').last;
    }
    if (newSession.isEmpty) return;
    GlobalSingleton.instance.secureStorage
        .write(key: 'session', value: newSession);
  }

  /// 通用的API請求
  ///
  /// - [dest] 請求的目的地，例如 /user/me
  /// - [body] 請求的內容
  ///
  /// 以下為可選參數
  ///
  /// - [contentType] 請求的內容類型，預設為 [ContentType.json]
  /// - [method] 請求的方法，預設為 [HttpMethod.post]
  /// - [session] 用於請求時的session，預設為`null`
  /// - [customDest] 自訂目的地，不會使用預設X50 domain，預設為`null`
  /// - [verbose] 是否顯示請求與回應的詳細資訊，預設為`false`
  /// - [withSession] 是否使用session，預設為`false`
  /// - [onSuccess] 請求成功時的callback函式
  /// - [onSuccessString] 請求成功時的callback函式，回傳的資料為String
  /// - [onError] 請求失敗時的callback函式
  /// - [onResponseHeader] 回應的header
  static Future<http.Response> makeRequest({
    ContentType contentType = ContentType.json,
    Map<String, String>? session,
    Map<String, String> customHeaders = const {},
    String? customDest,
    bool verbose = false,
    bool withSession = false,
    required String dest,
    required Map<String, dynamic> body,
    required HttpMethod method,
    Function(Map<String, dynamic>)? onSuccess,
    Function(String)? onSuccessString,
    Function(int statusCode, String body)? onError,
    Function(Map<String, String> headers)? onResponseHeader,
  }) async {
    http.Response response;
    final client = http.Client();
    bool isResponseString = onSuccessString != null;
    bool isEmptyBody = body.isEmpty;
    String? session;
    Uri url = customDest != null ? Uri.parse(customDest) : _fullURL(dest);

    const fixHeaders = {
      "Host": "pay.x50.fun",
      "Origin": "https://pay.x50.fun",
      "Referer": "https://pay.x50.fun/"
    };

    /// 建立請求的header
    Map<String, String> buildHeaders({bool httpGet = false}) {
      Map<String, String> headers = {};
      if (withSession) {
        headers.addAll({
          'Cookie': 'session=$session',
          "Content-Type": contentType.value,
        });
      }
      headers
        ..addAll(fixHeaders)
        ..addAll(customHeaders);

      if (httpGet) {
        headers
          ..remove('Content-Type')
          ..remove('Origin');
      }
      return headers;
    }

    /// 字串化請求的body
    String stringifyBody() {
      if (isEmptyBody) return '';
      return jsonEncode(body);
    }

    /// 建立請求的body
    Object buildBody() {
      if (contentType == ContentType.json) return stringifyBody();
      return body;
    }

    void checkNewSession(Map<String, String> headers) async {
      if (headers['set-cookie']?.isEmpty ?? true) return;
      String newSession = '';
      final cookies = headers['set-cookie']!.split(';');
      for (var cookie in cookies) {
        if (!cookie.contains('session=')) continue;
        newSession = cookie.split('=').last;
      }
      if (newSession.isEmpty) return;
      GlobalSingleton.instance.secureStorage
          .write(key: 'session', value: newSession);
    }

    if (verbose) log('request: $url', name: 'Api');
    if (withSession) {
      session =
          await GlobalSingleton.instance.secureStorage.read(key: 'session');
    }

    switch (method) {
      case HttpMethod.post:
        response = await client.post(
          url,
          body: buildBody(),
          headers: buildHeaders(),
          encoding: Encoding.getByName('utf-8'),
        );

        if (response.statusCode == 200) {
          isResponseString
              ? onSuccessString.call(response.body)
              : onSuccess?.call(jsonDecode(response.body));
        } else {
          onError?.call(response.statusCode, response.body);
          log('',
              error: 'statusCode: ${response.statusCode},\n${response.body}');
          throw Exception([
            'response code: ',
            response.statusCode,
            '\nresponse body: ',
            response.body
          ]);
        }
        checkNewSession(response.headers);
        onResponseHeader?.call(response.headers);
        break;

      case HttpMethod.get:
        response = await client.get(
          url,
          headers: buildHeaders(httpGet: true),
        );
        if (response.statusCode == 200) {
          isResponseString
              ? onSuccessString.call(response.body)
              : onSuccess?.call(jsonDecode(response.body));
        } else {
          onError?.call(response.statusCode, response.body);
          throw Exception([
            'response code: ',
            response.statusCode,
            '\nresponse body: ',
            response.body
          ]);
        }
        checkNewSession(response.headers);
        onResponseHeader?.call(response.headers);
        break;
    }
    if (verbose && kDebugMode) {
      log('request:', name: 'Api request');
      log("headers: ${response.request?.headers.toString()}",
          name: 'Api request');
      log("${response.request}", name: 'Api request');
      log('response: ${response.statusCode}', name: 'Api response');
      log(response.headers.toString(), name: 'Api response');
      log(response.body, name: 'Api response');
    }
    return response;
  }

  static Future<http.Response> makeRequestNoFR({
    required HttpMethod method,
    required String customDest,
    bool withSession = true,
  }) async {
    String? session;
    if (withSession) {
      session =
          await GlobalSingleton.instance.secureStorage.read(key: 'session');
    }

    final url = Uri.parse(customDest);
    final client = http.Client();
    final r = http.Request(method.name, url)
      ..followRedirects = false
      ..headers.addAll({
        'Host': 'pay.x50.fun',
        'Origin': 'https://pay.x50.fun',
        'Referer': 'https://pay.x50.fun/',
        if (withSession) 'Cookie': 'session=$session',
      });
    final a = await client.send(r);
    var response = await http.Response.fromStream(a);
    _checkNewSession(response.headers);
    return response;
  }
}

enum HttpMethod {
  post,
  get;
}

enum ContentType {
  json('application/json'),
  xForm('application/x-www-form-urlencoded'),
  none('');

  final String value;
  const ContentType(this.value);
}
