import 'dart:convert';

import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class Api {
  static String get domainBase => 'https://pay.x50.fun/api/v1';

  static Uri destURL(String dest) => Uri.parse(domainBase + dest);

  static Future makeRequest({
    ContentType contentType = ContentType.json,
    Map<String, String>? session,
    String? customDest,
    bool verbose = false,
    required String dest,
    required Map<String, dynamic> body,
    required HttpMethod method,
    Function(Map<String, dynamic>)? onSuccess,
    Function(String)? onSuccessString,
    Function(int, String)? onError,
    Function(Map<String, String>)? responseHeader,
    bool withSession = false,
  }) async {
    http.Response response;
    bool isResponseString = onSuccessString != null;
    bool isEmptyBody = body.isEmpty;
    String? session;

    if (withSession) {
      final pref = await SharedPreferences.getInstance();
      session = pref.getString('session');
    }

    switch (method) {
      case HttpMethod.post:
        response = await http.post(customDest != null ? Uri.parse(customDest) : destURL(dest),
            body: isEmptyBody
                ? ''
                : contentType == ContentType.json
                    ? jsonEncode(body)
                    : body,
            headers: withSession
                ? {
                    'Cookie': 'session=$session',
                    "Content-Type": contentType == ContentType.json
                        ? 'application/json'
                        : 'application/x-www-form-urlencoded'
                  }
                : null,
            encoding: Encoding.getByName('utf-8'));
        if (response.statusCode == 200) {
          isResponseString ? onSuccessString.call(response.body) : onSuccess?.call(jsonDecode(response.body));
        } else {
          onError?.call(response.statusCode, response.body);
          throw Exception(['response code: ', response.statusCode, '\nresponse body: ', response.body]);
        }
        responseHeader?.call(response.headers);
        break;

      case HttpMethod.get:
        response = await http.get(
          customDest != null ? Uri.parse(customDest) : destURL(dest),
          headers: withSession ? {'Cookie': 'session=$session'} : null,
        );
        if (response.statusCode == 200) {
          isResponseString ? onSuccessString.call(response.body) : onSuccess?.call(jsonDecode(response.body));
        } else {
          onError?.call(response.statusCode, response.body);
          throw Exception(['response code: ', response.statusCode, '\nresponse body: ', response.body]);
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
      print(response.body);
    }
  }
}

enum HttpMethod { post, get }

enum ContentType { json, xForm }
