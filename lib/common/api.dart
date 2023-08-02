import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class Api {
  static String get domainBase => 'https://pay.x50.fun/api/v1';

  static Uri destURL(String dest) => Uri.parse(domainBase + dest);

  static Future<http.Response> makeRequest({
    ContentType contentType = ContentType.json,
    Map<String, String>? session,
    String? customDest,
    bool verbose = false,
    required String dest,
    required Map<String, dynamic> body,
    required HttpMethod method,
    Function(Map<String, dynamic>)? onSuccess,
    Function(String)? onSuccessString,
    Function(int statusCode, String body)? onError,
    Function(Map<String, String>)? responseHeader,
    bool withSession = false,
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

    Map<String, String> getHeaders() {
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

    switch (method) {
      case HttpMethod.post:
        response = await http.post(
          customDest != null ? Uri.parse(customDest) : destURL(dest),
          body: isEmptyBody
              ? ''
              : contentType == ContentType.json
                  ? jsonEncode(body)
                  : body,
          headers: getHeaders(),
          encoding: Encoding.getByName('utf-8'),
        );
        log("url: ${response.request!.url}", name: 'request url');
        log("header: ${response.request!.headers}", name: 'request header');
        log("response: ${response.body.length > 5000 ? 'too long' : response.body}",
            name: 'request response');

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

      case HttpMethod.get:
        response = await http.get(
          customDest != null ? Uri.parse(customDest) : destURL(dest),
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
      // ignore: avoid_print
      print('request:');
      // ignore: avoid_print
      print(response.request);
      // ignore: avoid_print
      print('response:');
      // ignore: avoid_print
      debugPrint(response.body);
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
