import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  /// X50Pay API domain
  static String get domainBase => 'https://pay.x50.fun/api/v1';

  /// 完整的URL，包含X50Pay domain
  static Uri _fullURL(String dest) => Uri.parse(domainBase + dest);

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
  /// - [responseHeader] 回應的header
  static Future<http.Response> makeRequest({
    ContentType contentType = ContentType.json,
    Map<String, String>? session,
    String? customDest,
    bool verbose = false,
    bool withSession = false,
    required String dest,
    required Map<String, dynamic> body,
    required HttpMethod method,
    Function(Map<String, dynamic>)? onSuccess,
    Function(String)? onSuccessString,
    Function(int statusCode, String body)? onError,
    Function(Map<String, String>)? responseHeader,
  }) async {
    http.Response response;
    bool isResponseString = onSuccessString != null;
    bool isEmptyBody = body.isEmpty;
    String? session;

    const fixHeaders = {
      "Host": "pay.x50.fun",
      "Origin": "https://pay.x50.fun",
      "Referer": "https://pay.x50.fun/"
    };

    if (withSession) {
      final pref = await SharedPreferences.getInstance();
      session = pref.getString('session');
    }

    /// 建立請求的header
    Map<String, String> buildHeaders() {
      Map<String, String> headers = {};
      if (withSession) {
        headers.addAll({
          'Cookie': 'session=$session',
          if (contentType != ContentType.none) "Content-Type": contentType.value
        });
      }
      headers.addAll(fixHeaders);
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

    switch (method) {
      case HttpMethod.post:
        response = await http.post(
          customDest != null ? Uri.parse(customDest) : _fullURL(dest),
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
        responseHeader?.call(response.headers);
        break;

      case HttpMethod.get:
        response = await http.get(
          customDest != null ? Uri.parse(customDest) : _fullURL(dest),
          headers: withSession ? {'Cookie': 'session=$session'} : null,
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
        responseHeader?.call(response.headers);
        break;
    }
    if (verbose && kDebugMode) {
      log('request:', name: 'Api');
      log("${response.request}", name: 'Api');
      log('response:', name: 'Api');
      log(response.body, name: 'Api');
    }
    return response;
  }
}

enum HttpMethod { post, get }

enum ContentType {
  json('application/json'),
  xForm('application/x-www-form-urlencoded'),
  none('');

  final String value;
  const ContentType(this.value);
}
