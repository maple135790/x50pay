import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/api.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/common/models/user/user.dart';

class Repository extends Api {
  Future<BasicResponse?> login({required String email, required String password}) async {
    BasicResponse? res;
    await Api.makeRequest(
      dest: '/login',
      body: {'email': email, 'pwd': password},
      method: HttpMethod.post,
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
      responseHeader: (header) async {
        final pref = await SharedPreferences.getInstance();
        final session = header['set-cookie']?.split(';')[0].split('=').last;
        await pref.setString('session', session ?? 'null');
      },
    );
    return res;
  }

  Future<UserModel?> getUser() async {
    late UserModel? user;

    await Api.makeRequest(
      dest: '/me',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        user = UserModel.fromJson(json);
      },
    );
    return user;
  }

  Future<EntryModel> getEntry() async {
    late EntryModel entry;

    await Api.makeRequest(
      dest: '/entry',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        entry = EntryModel.fromJson(json);
      },
    );
    return entry;
  }

  Future<void> logout() async {
    await Api.makeRequest(
      dest: '/fuckout',
      method: HttpMethod.get,
      withSession: true,
      body: {},
    );
    return;
  }

  Future<StoreModel> getStores() async {
    late StoreModel store;

    await Api.makeRequest(
      dest: '/store/list',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        store = StoreModel.fromJson(json);
      },
    );
    return store;
  }

  Future<Gamelist> getGameList({required String storeId}) async {
    late Gamelist gameList;

    await Api.makeRequest(
      dest: '/gamelist',
      method: HttpMethod.post,
      withSession: true,
      body: {'sid': '70$storeId'},
      onSuccess: (json) {
        gameList = Gamelist.fromJson(json);
        if (kDebugMode) {
          print('json\n $json');
          print('gamelist got!');
          print(gameList.toJson().toString());
        }
      },
    );
    return gameList;
  }

  Future<PadSettingsModel> getPadSettings() async {
    late PadSettingsModel padSettingsModel;

    await Api.makeRequest(
      dest: '/pad/getSettings',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        padSettingsModel = PadSettingsModel.fromJson(json);
      },
    );
    return padSettingsModel;
  }

  Future<PadSettingsModel> setPadSettings(
      {required String shid, required String shcolor, required String shname}) async {
    late PadSettingsModel padSettingsModel;

    await Api.makeRequest(
      dest: '/settingPadConfirm',
      method: HttpMethod.post,
      withSession: true,
      body: {'shid': shid, 'shcolor': shcolor, 'shname': shname},
      onSuccess: (json) {
        padSettingsModel = PadSettingsModel.fromJson(json);
      },
    );
    return padSettingsModel;
  }

  Future<QuicSettingsModel> getQuicSettings() async {
    late QuicSettingsModel quicSettingsModel;

    await Api.makeRequest(
      dest: '/nfc/getSettings',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        quicSettingsModel = QuicSettingsModel.fromJson(json);
      },
    );
    return quicSettingsModel;
  }

  Future<void> quicConfirm({required String atq, required String atq1}) async {
    await Api.makeRequest(
      dest: '/settingPadConfirm',
      method: HttpMethod.post,
      withSession: true,
      body: {'atq': atq, 'atq1': atq1},
    );
  }

  Future<BasicResponse> changePassword({required String oldPwd, required String pwd}) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/chgpwd',
      method: HttpMethod.post,
      withSession: true,
      body: {'old_pwd': oldPwd, 'pwd': pwd},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  Future<BasicResponse> changeEmail({required String remail}) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/chgemail',
      method: HttpMethod.post,
      withSession: true,
      body: {'remail': remail},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  Future<BasicResponse> changePhone() async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/chgphone',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  Future<BasicResponse> doChangePhone({required String phone}) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/activePhone',
      method: HttpMethod.post,
      withSession: true,
      body: {'chg_phone': phone},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  Future<BasicResponse> smsActivate({required String sms}) async {
    late BasicResponse res;

    await Api.makeRequest(
      dest: '/setting/activeSms',
      method: HttpMethod.post,
      withSession: true,
      body: {'sms': sms},
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  Future<TicDateLogModel> getTicDateLog() async {
    late TicDateLogModel ticDateLogModel;

    await Api.makeRequest(
      dest: '/log/ticDate',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        ticDateLogModel = TicDateLogModel.fromJson(json);
      },
    );
    return ticDateLogModel;
  }

  Future<BidLogModel> getBidLog() async {
    late BidLogModel bidLogModel;

    await Api.makeRequest(
      dest: '/log/Bid',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        bidLogModel = BidLogModel.fromJson(json);
      },
    );
    return bidLogModel;
  }

  Future<PlayRecordModel> getPlayLog() async {
    late PlayRecordModel playRecordModel;

    await Api.makeRequest(
      dest: '/log/Play',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        playRecordModel = PlayRecordModel.fromJson(json);
      },
    );
    return playRecordModel;
  }

  Future<TicUsedModel> getTicUsedLog() async {
    late TicUsedModel ticUsedModel;

    await Api.makeRequest(
      dest: '/log/ticUsed',
      method: HttpMethod.get,
      withSession: true,
      body: {},
      onSuccess: (json) {
        ticUsedModel = TicUsedModel.fromJson(json);
      },
    );
    return ticUsedModel;
  }

  Future<CabinetModel> selGame(String machineId) async {
    late CabinetModel cabinetModel;

    await Api.makeRequest(
      dest: '/cablist/$machineId',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        cabinetModel = CabinetModel.fromJson(json);
      },
    );
    return cabinetModel;
  }

  Future<BasicResponse> doInsert(bool isTicket, String machineId, num mode) async {
    late BasicResponse response;
    String insertUrl = isTicket ? 'tic/' : 'pay/';

    await Api.makeRequest(
      dest: '/$insertUrl+$machineId/${mode.toInt()}',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        response = BasicResponse.fromJson(json);
      },
    );
    return response;
  }

  Future<int> getPadLineup(String padmid, String padlid) async {
    late int lineupCount;

    await Api.makeRequest(
      dest: '/pad/getCount/+$padmid/$padlid',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccessString: (text) {
        lineupCount = int.parse(text);
      },
    );
    return lineupCount;
  }
}
