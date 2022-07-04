import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class Api {
  static String get domainBase => 'https://pay.x50.fun/api/v1';

  static Uri destURL(String dest) => Uri.parse(domainBase + dest);

  static Future makeRequest({
    required String dest,
    required Map<String, dynamic> body,
    Function(Map<String, dynamic>)? onSuccess,
    required HttpMethod method,
    Map<String, String>? session,
    Function(int, String)? onError,
    Function(Map<String, String>)? responseHeader,
    bool withSession = false,
  }) async {
    bool isEmptyBody = body.isEmpty;
    String? session;

    if (withSession) {
      final pref = await SharedPreferences.getInstance();
      session = pref.getString('session');
    }

    switch (method) {
      case HttpMethod.post:
        var response = await http.post(
          destURL(dest),
          body: isEmptyBody ? '' : jsonEncode(body),
          headers: withSession ? {'Cookie': 'session=$session'} : null,
        );
        if (response.statusCode == 200) {
          onSuccess?.call(jsonDecode(response.body));
        } else {
          onError?.call(response.statusCode, response.body);
          throw Exception(['response code: ', response.statusCode, '\nresponse body: ', response.body]);
        }
        responseHeader?.call(response.headers);
        break;
      case HttpMethod.get:
        break;
    }
  }
}

enum HttpMethod { post, get }
