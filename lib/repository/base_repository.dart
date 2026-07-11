import 'package:x50pay/common/client/request_handler.dart';

abstract class Repository {
  final RequestHandler client;

  const Repository(this.client);

  static const webDomain = "pay.x50.fun";
}
