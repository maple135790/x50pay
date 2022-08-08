import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/api.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
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
      body: {'sid': storeId},
      onSuccess: (json) {
        gameList = Gamelist.fromJson(json);
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

  Future<BasicResponse> doInsert(bool isTicket, String id, num mode) async {
    late BasicResponse response;
    String insertUrl = isTicket ? 'tic' : 'pay';

    await Api.makeRequest(
      dest: '/$insertUrl/$id/${mode.toInt()}',
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
    int lineupCount = -87;

    await Api.makeRequest(
      dest: '/pad/getCount/$padmid/$padlid',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccessString: (text) {
        lineupCount = int.parse(text);
      },
    );
    return lineupCount;
  }

  Future<String> qrDecryt(String rawText) async {
    String result = '';
    await Api.makeRequest(
      dest: '/qrDecryt/',
      method: HttpMethod.post,
      contentType: ContentType.xForm,
      withSession: true,
      body: {'code': rawText},
      onSuccessString: (text) {
        result = text;
      },
    );
    return result;
  }

  Future<String> remoteOpenDoor(double distance) async {
    String result = '';
    await Api.makeRequest(
      customDest: 'https://pay.x50.fun/api/door/open/$distance',
      dest: '',
      method: HttpMethod.post,
      contentType: ContentType.xForm,
      withSession: true,
      body: {},
      onSuccessString: (text) {
        result = text;
      },
    );
    return result;
  }

  Future<BasicResponse> chgGradev2({required String gid, required String grid}) async {
    late BasicResponse basicResponse;

    await Api.makeRequest(
      dest: '/change/Gradev2',
      method: HttpMethod.post,
      withSession: true,
      body: {'grid': grid, 'gid': gid},
      onSuccess: (json) {
        basicResponse = BasicResponse.fromJson(json);
      },
    );
    return basicResponse;
  }

  Future<GiftBoxModel> getGiftBox() async {
    late GiftBoxModel giftBoxModel;

    await Api.makeRequest(
      dest: '/giftBox',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        giftBoxModel = GiftBoxModel.fromJson(json);
      },
    );
    return giftBoxModel;
  }

  Future<LotteListModel> getLotteList() async {
    late LotteListModel lotteListModel;

    await Api.makeRequest(
      dest: '/lotte/list',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        lotteListModel = LotteListModel.fromJson(json);
      },
    );
    return lotteListModel;
  }

  Future<String> lotteSave() async {
    late String res;

    await Api.makeRequest(
      dest: '/lotte/save',
      method: HttpMethod.post,
      onSuccessString: (str) {
        res = str;
      },
      withSession: true,
      body: {},
    );
    return res;
  }

  Future<void> giftExchange(String gid) async {
    await Api.makeRequest(
      dest: '/confirmGFID',
      method: HttpMethod.post,
      withSession: true,
      body: {'contentgid': gid},
    );
    return;
  }
}
