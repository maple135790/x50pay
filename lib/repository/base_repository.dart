import 'package:x50pay/common/client/request_handler.dart';

abstract class BaseRepository {
  final RequestHandler client;

  const BaseRepository(this.client);
}
