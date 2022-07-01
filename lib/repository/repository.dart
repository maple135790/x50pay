import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:x50pay/common/api.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
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

  @GET("/pad/getSettings")
  Future<PadSettingsModel> getPadSettings();

  @POST('/settingPadConfirm')
  Future<PadSettingsModel> setPadSettings(
      @Field('shid') String shid, @Field('shcolor') String shcolor, @Field('shname') String shname);

  @GET("/nfc/getSettings")
  Future<QuicSettingsModel> getQuicSettings();

  @POST("/quicConfirm")
  Future<void> quicConfirm(@Field('atq') String atq, @Field('atq1') String atq1);

  @POST("/setting/chgpwd")
  Future<BasicResponse> changePassword(@Field('old-pwd') String oldPwd, @Field('pwd') String pwd);

  @POST("/setting/chgemail")
  Future<BasicResponse> changeEmail(@Field('remail') String remail);

  @POST("/setting/chgphone")
  Future<BasicResponse> changePhone({String nullStr = ''});

  @POST("/setting/activePhone")
  Future<BasicResponse> doChangePhone(@Field('chg_phone') String phone);

  @POST("/setting/activeSms")
  Future<BasicResponse> smsActivate(@Field('sms') String sms);

  @GET("/log/ticDate")
  Future<TicDateLogModel> getTicDateLog();

  @GET("/log/Bid")
  Future<BidLogModel> getBidLog();

  @GET("/log/Play")
  Future<PlayRecordModel> getPlayLog();

  @GET("/log/ticUsed")
  Future<TicUsedModel> getTicUsedLog();
}
