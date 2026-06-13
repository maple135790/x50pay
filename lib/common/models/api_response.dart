import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:x50pay/common/models/result.dart';

typedef ErrorDetails = (Object error, StackTrace stackTrace);

class ApiResponse<T> {
  static final _logger = Logger('ApiResponse');

  final Result<T> result;
  final int? code;

  const ApiResponse._(this.result, {this.code});

  @visibleForTesting
  factory ApiResponse.createSuccess(T data) {
    return ApiResponse<T>._(Result.ok(data), code: 200);
  }

  @visibleForTesting
  factory ApiResponse.createFailed(T data) {
    return ApiResponse<T>._(Result.error({}));
  }

  factory ApiResponse.fromJson(
    http.Response response, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    final Result<T> result;
    final Map<String, dynamic> rawJson;
    try {
      rawJson = json.decode(response.body) as Map<String, dynamic>;
    } catch (e, s) {
      result = Result.notJson(response.body, e, s);
      return ApiResponse<T>._(result);
    }
    final code = rawJson['code'];
    final T model;
    try {
      model = fromJson(rawJson);
    } catch (e, s) {
      _logger.warning('fromJson failed.', e, s);
      result = Result.error(rawJson, e, s);
      return ApiResponse<T>._(result, code: code);
    }
    if (code != 200) {
      _logger.info('Code not 200');
      result = Result.error(rawJson);
    } else {
      result = Result.ok(model);
    }

    return ApiResponse<T>._(result, code: code);
  }
}
