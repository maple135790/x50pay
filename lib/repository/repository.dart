import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:x50pay/common/api.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/user/user.dart';

part 'repository.g.dart';

@RestApi()
abstract class Repository extends Api {
  factory Repository() {
    Dio dio = Dio(BaseOptions(baseUrl: Api.domainBase));
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(responseBody: true, compact: false));
    }
    return _Repository(dio, baseUrl: dio.options.baseUrl);
  }
  @POST("/me")
  Future<User> getUser();

  @POST("/login")
  Future<int> login(@Field('email') String email, @Field('pwd') String pwd);

  @GET("/fuckout")
  Future<int> logout();

  @POST("/entry")
  Future<Entry> getEntry();

  @POST("/store/list")
  Future<Store> getStore();

  @POST("/gamelist")
  Future<Gamelist> getGameList(@Field('sid') String storeId);
}
