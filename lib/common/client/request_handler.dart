import 'package:http/http.dart' as http;

abstract class RequestHandler extends http.BaseClient {
  Future<http.Response> request(
    Uri url, {
    required HttpMethod method,
    Map<String, dynamic> rawBody = const {},
    ContentType contentType = ContentType.json,
    Map<String, String> customHeaders = const {},
    bool withSession = true,
  });
}

enum HttpMethod {
  post("POST"),
  get("GET");

  final String value;
  const HttpMethod(this.value);
}

enum ContentType {
  json('application/json'),
  xForm('application/x-www-form-urlencoded'),
  none('');

  final String value;
  const ContentType(this.value);
}
