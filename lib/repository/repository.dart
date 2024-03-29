import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:x50pay/common/api.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/extensions/locale_ext.dart';

/// 存放 Api 呼叫的地方
///
/// Api 呼叫細節請參考 [Api.makeRequest]
/// [Repository] 只顯示使用呼叫，不顯示細節。
class Repository extends Api {
  /// 登入API
  ///
  /// 需要傳入 [email] 和 [password]。
  Future<BasicResponse?> login({
    required String email,
    required String password,
  }) async {
    BasicResponse? res;
    await Api.makeRequest(
      dest: '/login',
      body: {'email': email, 'pwd': password},
      method: HttpMethod.post,
      onSuccess: (json) {
        res = BasicResponse.fromJson(json);
      },
    );
    return res;
  }

  /// 取得使用者資料API
  Future<UserModel?> getUser() async {
    UserModel? user;

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

  /// 取得首頁資料API
  Future<EntryModel?> getEntry() async {
    late EntryModel? entry;

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

  /// 登出API
  Future<void> logout() async {
    await Api.makeRequest(
      dest: '/fuckout',
      method: HttpMethod.get,
      withSession: true,
      body: {},
    );
    return;
  }

  /// 取得店家資料API
  Future<StoreModel> getStores(Locale currentLocale) async {
    late StoreModel store;

    await Api.makeRequest(
      dest: '/store/list/${currentLocale.tagName.toLowerCase()}',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        store = StoreModel.fromJson(json);
      },
    );
    return store;
  }

  /// 取得該店家的遊戲列表API
  ///
  /// 需要傳入店家編號 [storeId]
  Future<GameList> getGameList({
    required String storeId,
  }) async {
    late GameList gameList;

    await Api.makeRequest(
      dest: '/gamelist',
      method: HttpMethod.post,
      withSession: true,
      body: {'sid': storeId},
      onSuccess: (json) {
        gameList = GameList.fromJson(json);
      },
    );
    return gameList;
  }

  /// 取得遊戲機台資料API
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

  /// 投幣API
  ///
  /// 需要傳入是否用券[isTicket]、機台編號[id]、投幣模式[mode]
  Future<BasicResponse> doInsert(
    bool isTicket,
    String id,
    num mode,
    bool isUseRewardPoint,
  ) async {
    late BasicResponse response;
    String insertUrl = isTicket ? 'tic' : 'pay';
    String url = '/$insertUrl/$id/${mode.toInt()}';
    if (!isTicket) {
      url += '/${isUseRewardPoint ? 1 : 0}';
    }

    await Api.makeRequest(
      dest: url,
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        response = BasicResponse.fromJson(json);
      },
    );
    return response;
  }

  /// 投幣API
  ///
  /// 需要傳入原始URL [url]，使用於 QRCode 掃描後 (QRPay) 的投幣
  Future<BasicResponse> doInsertRawUrl(String url) async {
    late BasicResponse response;

    await Api.makeRequest(
      dest: '',
      customDest: url,
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        response = BasicResponse.fromJson(json);
      },
    );
    return response;
  }

  /// 取得排隊人數API
  ///
  /// 需要傳入 [padmid] 和 [padlid]
  Future<int> getPadLineup(String padmid, String padlid) async {
    int lineupCount = -1;

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

  /// 確認平板排隊API
  ///
  /// 需要傳入 [padmid] 和 [padlid]
  Future<void> confirmPadCheck(String padmid, String padlid) async {
    await Api.makeRequest(
      dest: '/pad/onCheck/$padmid/$padlid',
      method: HttpMethod.post,
      withSession: true,
      body: {},
    );
  }

  /// QRCode 解析API
  ///
  /// 用於解析店內平板排隊 QRCode、儲值 QRCode
  ///
  /// 需要傳入QRCode解析後的String [rawText]
  ///
  /// 回傳解析結果 [String]
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

  /// 開門按鈕API
  ///
  /// 需要傳入與店家距離 [distance]、店門名稱 [doorName]
  Future<String> remoteOpenDoor(double distance,
      {required String doorName}) async {
    String result = '';
    await Api.makeRequest(
      customDest: 'https://pay.x50.fun/api/$doorName/open/$distance',
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

  // Future<BasicResponse> chgGradev2(
  //     {required String gid, required String grid}) async {
  //   late BasicResponse basicResponse;

  //   await Api.makeRequest(
  //     dest: '/change/Gradev2',
  //     method: HttpMethod.post,
  //     withSession: true,
  //     body: {'grid': grid, 'gid': gid},
  //     onSuccess: (json) {
  //       basicResponse = BasicResponse.fromJson(json);
  //     },
  //   );
  //   return basicResponse;
  // }

  /// 取得禮物箱API
  ///
  /// 用於禮物系統頁面，回傳 [GiftBoxModel]
  Future<GiftBoxModel> getGiftBox() async {
    late GiftBoxModel giftBoxModel;

    await Api.makeRequest(
      dest: '/gift/box',
      method: HttpMethod.post,
      withSession: true,
      body: {},
      onSuccess: (json) {
        giftBoxModel = GiftBoxModel.fromJson(json);
      },
    );
    return giftBoxModel;
  }

  /// 取得養成抽獎箱API
  ///
  /// 用於禮物系統頁面，回傳 [LotteListModel]
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

  /// 選擇養成抽獎API
  ///
  /// 用於禮物系統頁面的養成抽獎箱
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

  /// 兌換禮物API
  ///
  /// 用於禮物系統頁面，需要傳入禮物編號 [gid]
  Future<void> giftExchange(String gid) async {
    await Api.makeRequest(
      dest: '/confirmGFID',
      method: HttpMethod.post,
      withSession: true,
      body: {'contentgid': gid},
    );
    return;
  }

  /// 取得更衣室的所有衣服API
  Future<http.Response> getAvatar() async {
    final response = await Api.makeRequest(
      dest: '/list/avater',
      body: {},
      method: HttpMethod.get,
      withSession: true,
    );
    return response;
  }

  /// 設定角色衣服API
  Future<http.Response> setAvatar(String id) async {
    final response = await Api.makeRequest(
      dest: '/cgAva/$id',
      body: {},
      method: HttpMethod.post,
      withSession: true,
      contentType: ContentType.json,
    );
    return response;
  }

  /// 月票人際帝方案的購買API
  ///
  /// 需要傳入參加人[applicants]
  Future<http.Response> buyVipMany(List<String>? applicants) async {
    Map<String, String> body = {};

    if (applicants != null) {
      int count = 0;
      for (var applicant in applicants) {
        count++;
        body.addAll({'id$count': applicant});
      }
    }

    final response = await Api.makeRequest(
      dest: '/vip/buymany',
      body: body,
      method: HttpMethod.post,
      withSession: true,
      contentType: ContentType.json,
    );
    return response;
  }

  /// 月票月養成方案的購買API
  Future<http.Response> buyVipGradeOne() async {
    final response = await Api.makeRequest(
      dest: '/vip/buygrdone',
      body: {},
      method: HttpMethod.post,
      withSession: true,
      contentType: ContentType.json,
    );

    return response;
  }

  /// 月票邊緣人方案的購買API
  Future<http.Response> buyVipOne() async {
    final response = await Api.makeRequest(
      dest: '/vip/buyone',
      body: {},
      method: HttpMethod.post,
      withSession: true,
      contentType: ContentType.json,
    );

    return response;
  }

  /// 取得最新活動web document API
  ///
  /// 需要傳入活動編號 [cid]。
  ///
  /// 因目前還沒有最新活動的相關API，故使用此方式取得最新活動頁面的HTML。
  Future<String> getCampaignDocument(String cid) async {
    final response = await Api.makeRequest(
      dest: '',
      customDest: 'https://pay.x50.fun/coupon/$cid',
      method: HttpMethod.get,
      withSession: true,
      body: {},
    );
    return response.body;
  }

  /// 新增最新活動印章列API
  ///
  /// 需要傳入活動編號 [cid]。
  Future<void> addCampaignStampRow(String cid) async {
    await Api.makeRequest(
      dest: '',
      customDest: 'https://pay.x50.fun/li/ev/$cid',
      method: HttpMethod.get,
      withSession: true,
      body: {},
    );
    return;
  }

  /// 取得贊助商web document API
  ///
  /// 因目前還沒有贊助商的相關API，故使用此方式取得贊助商頁面的HTML。
  Future<String> getSponserDocument() async {
    final response = await Api.makeRequest(
      dest: '',
      customDest: 'https://pay.x50.fun/static/templates-v4/sponser.html?v1.1',
      method: HttpMethod.get,
      body: {},
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }

  /// 取得養成商場內，點數兌換商品資料API
  Future<String> fetchGradeBox() async {
    final response = await Api.makeRequest(
      dest: '/grade/box',
      method: HttpMethod.post,
      body: {},
      withSession: true,
      contentType: ContentType.json,
    );
    return response.body;
  }

  /// 兌換養成商場內商品API
  ///
  /// 需要傳入 [gid] 及 [grid]
  Future<String> chgGradev2(String gid, String grid) async {
    final response = await Api.makeRequest(
        dest: '/grade/change',
        body: {
          'gid': gid,
          'grid': grid,
        },
        method: HttpMethod.post,
        withSession: true,
        contentType: ContentType.json);
    return response.body;
  }

  Future<http.Response> getDocument(String fullUrl) async {
    final response = await Api.makeRequestNoFR(
      method: HttpMethod.get,
      customDest: fullUrl,
    );
    return response;
  }

  Future<String> getQRPayDocument(String url) async {
    final response = await Api.makeRequest(
      dest: '',
      customDest: url,
      method: HttpMethod.get,
      withSession: true,
      body: {},
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }

  Future<String> getDocumentWithDomainPrefix(
    String url,
    String refererUrl, {
    required String descLabel,
  }) async {
    final response = await Api.makeRequest(
      dest: '',
      customDest: "https://pay.x50.fun$url",
      method: HttpMethod.get,
      withSession: true,
      customHeaders: {
        'Referer': refererUrl,
      },
      body: {},
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }

  Future<String> redeemQuestCampaignItem(
    String campaignId,
    String itemId,
  ) async {
    final response = await Api.makeRequest(
      dest: "https://pay.x50.fun/coupon/changecheck/$campaignId/$itemId",
      method: HttpMethod.get,
      withSession: true,
      body: {},
    );
    return response.body;
  }
}
