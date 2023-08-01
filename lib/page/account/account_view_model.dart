import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/repository/repository.dart';

class AccountViewModel extends BaseViewModel {
  final repo = Repository();
  final isForce = GlobalSingleton.instance.devIsServiceOnline;

  QuicSettingsModel? quicSettingModel;
  PadSettingsModel? padSettingsModel;
  BidLogModel? bidModel;
  TicDateLogModel? ticDateLogModel;
  TicUsedModel? ticUsedModel;
  PlayRecordModel? playRecordModel;
  BasicResponse? response;

  Future<bool> quicConfirm(
      {required bool autoQuic, required String autoQlock}) async {
    log('autoQuic $autoQuic', name: 'quicConfirm');
    log('autoQlock $autoQlock', name: 'quicConfirm');

    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));
    late http.Response httpResponse;

    try {
      if (!kDebugMode || isForce) {
        httpResponse = await repo.quicConfirm(atq: autoQuic, atql: autoQlock);
      } else {
        httpResponse = http.Response(testResponse(), 200);
      }
      await EasyLoading.dismiss();

      return httpResponse.statusCode == 200;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> setPadSettings({
    required bool isNicknameShown,
    required String showColor,
    required String nickname,
  }) async {
    log('$isNicknameShown, $showColor, $nickname', name: 'setPadSettings');

    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));
    late http.Response httpResponse;

    try {
      if (!kDebugMode || isForce) {
        httpResponse = await repo.setPadSettings(
          shname: nickname,
          shid: isNicknameShown,
          shcolor: showColor,
        );
      } else {
        httpResponse = http.Response(testResponse(), 200);
      }
      await EasyLoading.dismiss();

      return httpResponse.statusCode == 200;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> confirmQuickPay({
    required bool autoPay,
    required bool autoQuicPay,
    required bool autoTicket,
    required String autoTwo,
    required String autoNVSV,
    required int mtp,
    required String autoSDVX,
  }) async {
    log('autoQuicPay $autoQuicPay', name: 'confirmQuickPay');
    log('autoPay $autoPay', name: 'confirmQuickPay');
    log('autoTicket $autoTicket', name: 'confirmQuickPay');
    log('autoSDVX $autoSDVX', name: 'confirmQuickPay');
    log('autoNVSV $autoNVSV', name: 'confirmQuickPay');
    log('mtp $mtp', name: 'confirmQuickPay');
    log('autoTwo $autoTwo', name: 'confirmQuickPay');

    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));
    late http.Response httpResponse;

    try {
      if (!kDebugMode || isForce) {
        httpResponse = await repo.autoConfirm(
            atc: autoTicket,
            atn: autoNVSV,
            atp: autoPay,
            atq: autoQuicPay,
            ats: autoSDVX,
            att: autoTwo,
            mtp: mtp);
      } else {
        httpResponse = http.Response(testAutoConfirm, 200);
      }
      await EasyLoading.dismiss();

      return httpResponse.statusCode == 200;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getQuicSettings() async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        quicSettingModel = await repo.getQuicSettings();
      } else {
        quicSettingModel =
            QuicSettingsModel.fromJson(jsonDecode(testQuicSettings));
      }
      await EasyLoading.dismiss();
      return true;
    } on Exception catch (e) {
      log('', name: 'getQuicSettings', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<PadSettingsModel?> getPadSettings() async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        padSettingsModel = await repo.getPadSettings();
      } else {
        padSettingsModel =
            PadSettingsModel.fromJson(jsonDecode(testPadSettings));
      }
      await EasyLoading.dismiss();

      return padSettingsModel;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return null;
    }
  }

  Future<bool> changePassword({
    required String oldPwd,
    required String pwd,
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        response = await repo.changePassword(oldPwd: oldPwd, pwd: pwd);
      } else {
        if (debugFlag == 700) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 700)));
        } else if (debugFlag == 701) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 701)));
        } else {
          response = BasicResponse.fromJson(jsonDecode(testResponse()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> changeEmail({
    required String email,
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        response = await repo.changeEmail(remail: email);
      } else {
        if (debugFlag == 700) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 700)));
        } else if (debugFlag == 701) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 701)));
        } else {
          response = BasicResponse.fromJson(jsonDecode(testResponse()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> detachPhone({
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        response = await repo.changePhone();
      } else {
        if (debugFlag == 700) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 700)));
        } else if (debugFlag == 701) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 701)));
        } else {
          response = BasicResponse.fromJson(jsonDecode(testResponse()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> doChangePhone({
    required String phone,
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        response = await repo.doChangePhone(phone: phone);
      } else {
        if (debugFlag == 700) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 700)));
        } else if (debugFlag == 701) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 701)));
        } else {
          response = BasicResponse.fromJson(jsonDecode(testResponse()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> smsActivate({
    required String smsCode,
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        response = await repo.smsActivate(sms: smsCode);
      } else {
        if (debugFlag == 700) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 700)));
        } else if (debugFlag == 701) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 701)));
        } else {
          response = BasicResponse.fromJson(jsonDecode(testResponse()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getBidLog({
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        bidModel = await repo.getBidLog();
      } else {
        if (debugFlag != 200) {
          bidModel = BidLogModel.fromJson(jsonDecode(testBidLog(code: 700)));
        } else {
          bidModel = BidLogModel.fromJson(jsonDecode(testBidLog()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getTicketLog({
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        ticDateLogModel = await repo.getTicDateLog();
      } else {
        if (debugFlag != 200) {
          ticDateLogModel =
              TicDateLogModel.fromJson(jsonDecode(testTicDateLog(code: 700)));
        } else {
          ticDateLogModel =
              TicDateLogModel.fromJson(jsonDecode(testTicDateLog()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getPlayRecord({
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        playRecordModel = await repo.getPlayLog();
      } else {
        if (debugFlag != 200) {
          playRecordModel =
              PlayRecordModel.fromJson(jsonDecode(testPlayRecord(code: 700)));
        } else {
          playRecordModel =
              PlayRecordModel.fromJson(jsonDecode(testPlayRecord()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> getTicUsedLog({
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        ticUsedModel = await repo.getTicUsedLog();
      } else {
        if (debugFlag != 200) {
          ticUsedModel =
              TicUsedModel.fromJson(jsonDecode(testTicUsedLog(code: 700)));
        } else {
          ticUsedModel = TicUsedModel.fromJson(jsonDecode(testTicUsedLog()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<bool> logout({
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForce) {
        await repo.logout();
      } else {
        if (debugFlag != 200) {
          response =
              BasicResponse.fromJson(jsonDecode(testResponse(code: 700)));
        } else {
          response = BasicResponse.fromJson(jsonDecode(testResponse()));
        }
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  final testPadSettings =
      """{"shid": false, "shcolor": "#abb3ff", "shname": "SABA.KEN"}""";

  String get testQuicSettings =>
      """{"nfcAuto": true, "nfcTicket": false, "nfcTwo": "0", "nfcSDVX": "0", "nfcNVSV": "0", "nfcQuic": true, "nfcQlock": 0, "mtpMode": 1}""";

  String testResponse({int? code = 200}) =>
      """{"code": $code,"message": "smth"}""";
  String get testAutoConfirm =>
      """{"nfcAuto":true,"nfcTicket":false,"nfcTwo":"0","nfcSDVX":"0","nfcNVSV":"0"}""";
  String testBidLog({int? code = 200}) =>
      '''{"message":"done","code":$code,"log":[{"_id":{"\$oid":"62bd79dbfe009eb67dc4f853"},"uid":"938","point":500.0,"shop":"37656","time":"2022-06-30 18:24"},{"_id":{"\$oid":"62baf388e4f0f77b8c3738df"},"uid":"938","point":400.0,"shop":"37656","time":"2022-06-28 20:26"},{"_id":{"\$oid":"62a5f9b1c3ee84ed28fe0780"},"uid":"938","point":500.0,"shop":"37656","time":"2022-06-12 22:35"},{"_id":{"\$oid":"62a5e647c3ee84ed28fe075e"},"uid":"938","point":200.0,"shop":"37656","time":"2022-06-12 21:12"},{"_id":{"\$oid":"62a5e584c3ee84ed28fe0758"},"uid":"938","point":200.0,"shop":"37656","time":"2022-06-12 21:09"},{"_id":{"\$oid":"6273bf5ee0223d7557c05626"},"uid":"938","point":500,"shop":"37656","3kcre":true,"time":"2022-05-05 20:13"}]}''';

  String testTicDateLog({int? code = 200}) =>
      '''{"message":"done","code":$code,"log":[[2,"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","2022-07-17 02:13",[],"0","\u5168\u5e97\u53ef\u7528"],[1,"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","2022-07-27 02:53",[],"0","\u5168\u5e97\u53ef\u7528"],[4,"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","2049-10-27 21:13",[]]]}''';
  String testPlayRecord({int? code = 200}) =>
      '''{"message":"done","code":$code,"log":[{"_id":{"\$oid":"62bda312efae537097a37c20"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656595218720},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 21:20"},{"_id":{"\$oid":"62bda0c4efae537097a37c10"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656594628848},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 21:10"},{"_id":{"\$oid":"62bd9d2befae537097a37bf6"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656593707927},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 20:55"},{"_id":{"\$oid":"62bd96c4efae537097a37bc3"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656592068490},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 20:27"},{"_id":{"\$oid":"62bd96c4efae537097a37bc1"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656592068122},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 20:27"},{"_id":{"\$oid":"62bd9419efae537097a37ba8"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656591385892},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 20:16"},{"_id":{"\$oid":"62bd919cefae537097a37b89"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656590748955},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 20:05"},{"_id":{"\$oid":"62bd8e6fefae537097a37b6f"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656589935596},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 19:52"},{"_id":{"\$oid":"62bd8c2cefae537097a37b58"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656589356390},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 19:42"},{"_id":{"\$oid":"62bd89c3efae537097a37b42"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656588739812},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 19:32"},{"_id":{"\$oid":"62bd8659efae537097a37b26"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656587865314},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 19:17"},{"_id":{"\$oid":"62bd8438efae537097a37b14"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656587320198},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-30 19:08"},{"_id":{"\$oid":"62bd81d8efae537097a37b00"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656586712287},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-30 18:58"},{"_id":{"\$oid":"62bd7ea0efae537097a37aea"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656585888848},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-30 18:44"},{"_id":{"\$oid":"62bd7c51efae537097a37ada"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656585297462},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-30 18:34"},{"_id":{"\$oid":"62bd79f7efae537097a37aca"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656584695275},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-30 18:24"},{"_id":{"\$oid":"62bb1e9befae537097a3740b"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656430235372},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-28 23:30"},{"_id":{"\$oid":"62bb1429efae537097a373ec"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656427561551},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-28 22:46"},{"_id":{"\$oid":"62bb1424efae537097a373ea"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656427556872},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-28 22:45"},{"_id":{"\$oid":"62bb1418efae537097a373e8"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656427544498},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-28 22:45"},{"_id":{"\$oid":"62bb140befae537097a373e6"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656427531620},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-28 22:45"},{"_id":{"\$oid":"62bb0f43efae537097a373d3"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":2,"inittime":{"\$date":1656426307095},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-28 22:25"},{"_id":{"\$oid":"62bb0c41efae537097a373cd"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656425537274},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-28 22:12"},{"_id":{"\$oid":"62bb0687efae537097a373ae"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656424071020},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 21:47"},{"_id":{"\$oid":"62bb0674efae537097a373a8"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656424052275},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 21:47"},{"_id":{"\$oid":"62bb03a8efae537097a37391"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656423336699},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 21:35"},{"_id":{"\$oid":"62bb00c5efae537097a37381"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656422597959},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 21:23"},{"_id":{"\$oid":"62bafdc9efae537097a37371"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656421833562},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 21:10"},{"_id":{"\$oid":"62bafab0efae537097a37361"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656421040802},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 20:57"},{"_id":{"\$oid":"62baf762efae537097a3734e"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656420194256},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 20:43"},{"_id":{"\$oid":"62baf448efae537097a37334"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656419400874},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-28 20:30"},{"_id":{"\$oid":"62b5e9a4b2ec8bf8003b7710"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656088996429},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-25 00:43"},{"_id":{"\$oid":"62b5e6ddb2ec8bf8003b7703"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656088285526},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-25 00:31"},{"_id":{"\$oid":"62b5e415b2ec8bf8003b76f3"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656087573152},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-25 00:19"},{"_id":{"\$oid":"62b5e129b2ec8bf8003b76e7"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656086825074},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-25 00:07"},{"_id":{"\$oid":"62b5de1cb2ec8bf8003b76cf"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656086044802},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-24 23:54"},{"_id":{"\$oid":"62b5daecb2ec8bf8003b76b7"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1656085228565},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-24 23:40"},{"_id":{"\$oid":"62b5d777b2ec8bf8003b76a5"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656084343081},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-24 23:25"},{"_id":{"\$oid":"62b5d0cab2ec8bf8003b7676"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656082634496},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-24 22:57"},{"_id":{"\$oid":"62b5c803b2ec8bf8003b7639"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1656080387222},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-24 22:19"},{"_id":{"\$oid":"62a74bfd4fa5d263c1a434e3"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655131133071},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-13 22:38"},{"_id":{"\$oid":"62a74bfc068521b28ed06aa8"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655131132257},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-13 22:38"},{"_id":{"\$oid":"62a74927a5ce600453e46bbf"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655130407079},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-13 22:26"},{"_id":{"\$oid":"62a746c35bd2406a1dd6ee2d"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655129795245},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022-06-13 22:16"},{"_id":{"\$oid":"62a742d9a5ce600453e46bba"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655128793864},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-13 21:59"},{"_id":{"\$oid":"62a74031a5ce600453e46bb7"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655128113550},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-13 21:48"},{"_id":{"\$oid":"62a73d66068521b28ed06a98"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655127398482},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-13 21:36"},{"_id":{"\$oid":"62a739ab4fa5d263c1a434c2"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655126443713},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-13 21:20"},{"_id":{"\$oid":"62a73544a5ce600453e46ba5"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1655125316057},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-13 21:01"},{"_id":{"\$oid":"62a72d1b4fa5d263c1a43498"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655123227754},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-13 20:27"},{"_id":{"\$oid":"62a72a66a5ce600453e46b8f"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655122534908},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-13 20:15"},{"_id":{"\$oid":"62a6066e4fa5d263c1a4337b"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":2,"inittime":{"\$date":1655047790445},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-12 23:29"},{"_id":{"\$oid":"62a60324068521b28ed0695f"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":2,"inittime":{"\$date":1655046948391},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-06-12 23:15"},{"_id":{"\$oid":"62a5f9bf5bd2406a1dd6ecf5"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1655044543520},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-12 22:35"},{"_id":{"\$oid":"62a5f260068521b28ed06949"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1655042656135},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-12 22:04"},{"_id":{"\$oid":"62a5eea14fa5d263c1a4335c"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1655041697216},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-06-12 21:48"},{"_id":{"\$oid":"62a5eb2d4fa5d263c1a43356"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655040813922},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-12 21:33"},{"_id":{"\$oid":"62a5e90a4fa5d263c1a43352"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655040266306},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-12 21:24"},{"_id":{"\$oid":"62a5e699a5ce600453e46a61"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1655039641400},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022-06-12 21:14"},{"_id":{"\$oid":"6273ea02b252e619099e4e44"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1651763714572},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-05-05 23:15"},{"_id":{"\$oid":"6273ea02b252e619099e4e42"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1651763714307},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-05-05 23:15"},{"_id":{"\$oid":"6273e650b252e619099e4e2e"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"inittime":{"\$date":1651762768906},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-05-05 22:59"},{"_id":{"\$oid":"6273dd4ab252e619099e4dfc"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651760458827},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-05-05 22:21"},{"_id":{"\$oid":"6273d9f9b252e619099e4de9"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651759609317},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":25.0,"time":"2022-05-05 22:06"},{"_id":{"\$oid":"6273d6c1b252e619099e4dd7"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651758785586},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 21:53"},{"_id":{"\$oid":"6273d3abb252e619099e4dc9"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651757995677},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 21:39"},{"_id":{"\$oid":"6273d0bab252e619099e4db8"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651757242194},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 21:27"},{"_id":{"\$oid":"6273cd6fb252e619099e4da1"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651756399312},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 21:13"},{"_id":{"\$oid":"6273caa1b252e619099e4d92"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651755681276},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 21:01"},{"_id":{"\$oid":"6273c7fcb252e619099e4d7c"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651755004129},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 20:50"},{"_id":{"\$oid":"6273c5a1b252e619099e4d72"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651754401867},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 20:40"},{"_id":{"\$oid":"6273c2d5b252e619099e4d5f"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651753685614},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 20:28"},{"_id":{"\$oid":"6273bfc9c5ee52e3ecb9d4d3"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] CHUNITHM","cid":3,"inittime":{"\$date":1651752905696},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":27.0,"time":"2022-05-05 20:15"}]}''';
  String testTicUsedLog({int? code = 200}) =>
      '''{"message":"done","code":$code,"log":[{"_id":{"\$oid":"62bb2192efae537097a37415"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022-06-28 23:43"},{"_id":{"\$oid":"62b5ef80b2ec8bf8003b7721"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022-06-25 01:08"},{"_id":{"\$oid":"62b5ecf5b2ec8bf8003b7718"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022-06-25 00:57"},{"_id":{"\$oid":"62a5f52b068521b28ed06950"},"uid":"938","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"price":27.0,"disbool":false,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022-06-12 22:16"},{"_id":{"\$oid":"6273e32fb252e619099e4e1d"},"uid":"938","mid":"[\u897f\u9580] SDVX - Valkyrie Model","cid":2,"price":36.0,"disbool":false,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022-05-05 22:46"}]}''';
}
