import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';

enum NVSVPayment {
  light('Light', '0'),
  standard('Standard', '1'),
  blaster('Blaster', '2');

  final String name;
  final String value;

  /// 女武神預設扣款模式
  const NVSVPayment(this.name, this.value);
}

enum SDVXPayment {
  standard('Standard', '0'),
  blaster('Blaster', '1');

  final String name;
  final String value;
  const SDVXPayment(this.name, this.value);
}

enum DPPayment {
  single('單人', "0"),
  double('雙人', "1");

  final String name;
  final String value;

  /// 雙人遊玩機種預設扣款模式
  const DPPayment(this.name, this.value);
}

enum DefaultCabPayment {
  ask('每次都詢問我', 0),
  x50pay('X50Pay', 1),
  jko('街口支付', 2);

  final String name;
  final int value;

  /// 機台付款碼預設
  const DefaultCabPayment(this.name, this.value);
}

class SettingsViewModel extends BaseViewModel {
  final SettingRepository settingRepo;

  SettingsViewModel({required this.settingRepo});

  BasicResponse? response;

  Future<void> init() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 650));
    dismissLoading();
  }

  /// 設定 QuicPay 偏好
  Future<bool> quicConfirm(
      {required bool autoQuic, required String autoQlock}) async {
    log('autoQuic $autoQuic', name: 'quicConfirm');
    log('autoQlock $autoQlock', name: 'quicConfirm');

    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));
    late http.Response httpResponse;

    try {
      if (!kDebugMode || isForceFetch) {
        httpResponse =
            await settingRepo.quicConfirm(atq: autoQuic, atql: autoQlock);
      } else {
        httpResponse = http.Response(testResponse(), 200);
      }
      await EasyLoading.dismiss();

      return httpResponse.statusCode == 200;
    } on Exception catch (e) {
      log('', name: 'quicConfirm', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  /// 設定排隊平板偏好
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
      if (!kDebugMode || isForceFetch) {
        httpResponse = await settingRepo.setPadSettings(
          shname: nickname,
          shid: isNicknameShown,
          shcolor: showColor,
        );
      } else {
        httpResponse = http.Response(testResponse(), 200);
      }
      await EasyLoading.dismiss();

      return httpResponse.statusCode == 200;
    } on Exception catch (e) {
      log('', name: 'setPadSettings error', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  /// 回傳快速付款偏好設定
  Future<bool> confirmQuickPay({
    required bool autoPay,
    required bool autoQuicPay,
    required bool autoTicket,
    required String autoTwo,
    required String autoNVSV,
    required int mtp,
    required String autoSDVX,
    required bool autoRewardPoint,
  }) async {
    log('autoQuicPay $autoQuicPay', name: 'confirmQuickPay');
    log('autoPay $autoPay', name: 'confirmQuickPay');
    log('autoTicket $autoTicket', name: 'confirmQuickPay');
    log('autoSDVX $autoSDVX', name: 'confirmQuickPay');
    log('autoNVSV $autoNVSV', name: 'confirmQuickPay');
    log('mtp $mtp', name: 'confirmQuickPay');
    log('autoTwo $autoTwo', name: 'confirmQuickPay');

    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    late http.Response httpResponse;

    try {
      httpResponse = await settingRepo.autoConfirm(
          atc: autoTicket,
          atn: autoNVSV,
          atp: autoPay,
          atq: autoQuicPay,
          ats: autoSDVX,
          att: autoTwo,
          agv: autoRewardPoint,
          mtp: mtp);

      return httpResponse.statusCode == 200;
    } catch (e, stacktrace) {
      log('', name: 'confirmQuickPay', error: e, stackTrace: stacktrace);
      return false;
    } finally {
      dismissLoading();
    }
  }

  /// 取得快速付款偏好設定
  Future<PaymentSettingsModel> getPaymentSettings({
    bool enableDelay = true,
  }) async {
    showLoading();
    if (enableDelay) await Future.delayed(const Duration(milliseconds: 200));
    late final PaymentSettingsModel paymentSettingModel;
    try {
      paymentSettingModel = await settingRepo.getQuickPaySettings();
      return paymentSettingModel;
    } catch (e, stacktrace) {
      log('', name: 'getQuicSettings', error: e, stackTrace: stacktrace);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  /// 取得排隊平板設定
  Future<PadSettingsModel> getPadSettings() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    late final PadSettingsModel padSettingsModel;
    try {
      padSettingsModel = await settingRepo.getPadSettings();

      return padSettingsModel;
    } catch (e) {
      log('', name: 'getPadSettings', error: e);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  /// 變更密碼API
  ///
  /// 需要傳入舊密碼[oldPwd] 和 新密碼[pwd]
  Future<bool> changePassword({
    required String oldPwd,
    required String pwd,
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForceFetch) {
        response = await settingRepo.changePassword(oldPwd: oldPwd, pwd: pwd);
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
    } on Exception catch (e) {
      log('', name: 'changePassword', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  /// 變更電子郵件
  ///
  /// 用於綁定新電子郵件，需要傳入新電子郵件 [email]
  Future<bool> changeEmail({
    required String email,
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForceFetch) {
        response = await settingRepo.changeEmail(remail: email);
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
    } on Exception catch (e) {
      log('', name: 'changeEmail', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  /// 變更手機號碼API
  ///
  /// 用於取消綁定手機號碼
  Future<bool> detachPhone() async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForceFetch) {
        response = await settingRepo.changePhone();
      } else {
        response = BasicResponse.fromJson(jsonDecode(testResponse()));
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (e) {
      log('', name: 'detachPhone', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  /// 變更手機號碼
  ///
  /// 用於綁定新手機號碼，需要傳入新手機號碼 [phone]
  Future<bool> doChangePhone({required String phone}) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForceFetch) {
        response = await settingRepo.doChangePhone(phone: phone);
      } else {
        response = BasicResponse.fromJson(jsonDecode(testResponse()));
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (e) {
      log('', name: 'doChangePhone', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  /// 變更手機號碼
  ///
  /// 用於驗證新手機號碼，需要傳入簡訊驗證碼 [sms]
  Future<bool> smsActivate({required String smsCode}) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForceFetch) {
        response = await settingRepo.smsActivate(sms: smsCode);
      } else {
        response = BasicResponse.fromJson(jsonDecode(testResponse()));
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (e) {
      log('', name: 'smsActivate', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  /// 取得儲值紀錄
  Future<BidLogModel> getBidLog() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    late final BidLogModel bidModel;

    try {
      bidModel = await settingRepo.getBidLog();

      return bidModel;
    } catch (e, stacktrace) {
      log('', name: 'getBidLog', error: e, stackTrace: stacktrace);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  /// 取得獲券紀錄
  Future<TicDateLogModel> getTicketLog() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    late final TicDateLogModel ticDateLogModel;
    try {
      ticDateLogModel = await settingRepo.getTicDateLog();

      return ticDateLogModel;
    } catch (e, stacktrace) {
      log('', name: 'getTicketLog', error: e, stackTrace: stacktrace);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  /// 取得P點付費明細
  Future<PlayRecordModel> getPlayRecord() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    late final PlayRecordModel playRecordModel;
    try {
      playRecordModel = await settingRepo.getPlayLog();
      return playRecordModel;
    } catch (e, stacktrace) {
      log('', name: 'getPlayRecord', error: e, stackTrace: stacktrace);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  /// 取得回饋點數明細
  Future<FreePointModel> getFreePointRecord() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    late final FreePointModel freePModel;
    try {
      freePModel = await settingRepo.getFreePLog();
      return freePModel;
    } catch (e, stacktrace) {
      log('', name: 'getPlayRecord', error: e, stackTrace: stacktrace);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  /// 取得扣券明細
  Future<TicUsedModel> getTicUsedLog() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 200));
    late final TicUsedModel ticUsedModel;
    try {
      ticUsedModel = await settingRepo.getTicUsedLog();
      return ticUsedModel;
    } catch (e, stacktrace) {
      log('', name: 'getPlayRecord', error: e, stackTrace: stacktrace);
      rethrow;
    } finally {
      dismissLoading();
    }
  }

  Future<bool> logout({
    int debugFlag = 200,
  }) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      if (!kDebugMode || isForceFetch) {
        await Repository().logout();
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
    } on Exception catch (e) {
      log('', name: 'logout', error: e);
      await EasyLoading.dismiss();
      return false;
    }
  }

  String testResponse({int code = 200}) =>
      """{"code": $code,"message": "smth"}""";
}
