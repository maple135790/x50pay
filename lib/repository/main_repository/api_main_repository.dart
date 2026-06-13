import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:x50pay/common/client/request_handler.dart';
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/repository/base_repository.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

/// 存放 Api 呼叫的地方
///
/// Api 呼叫細節請參考 [client.request]
/// [MainRepository] 只顯示使用呼叫，不顯示細節。
class ApiMainRepository extends BaseRepository implements MainRepository {
  const ApiMainRepository(super.client);

  Uri _endpoint(String path) {
    return Uri.parse('https://pay.x50.fun/api/v1$path');
  }

  Map<String, dynamic> _decodeRes(http.Response res) {
    return json.decode(res.body);
  }

  /// 登入API
  ///
  /// 需要傳入 [email] 和 [password]。
  @override
  Future<BasicResponse?> login({
    required String email,
    required String password,
  }) async {
    final res = await client.request(
      _endpoint('/login'),
      rawBody: {'email': email, 'pwd': password},
      withSession: false,
      method: HttpMethod.post,
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 取得使用者資料API
  @override
  Future<ApiResponse<UserModel>> getUser() async {
    final res = await client.request(
      _endpoint('/user/me'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return ApiResponse.fromJson(res, fromJson: UserModel.fromJson);
  }

  /// 取得首頁資料API
  @override
  Future<EntryModel?> getEntry() async {
    final res = await client.request(
      _endpoint('/user/entry'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return EntryModel.fromJson(_decodeRes(res));
  }

  /// 登出API
  @override
  Future<void> logout() {
    return client.request(_endpoint('/fuckout'), method: HttpMethod.get);
  }

  /// 取得店家資料API
  @override
  Future<StoreModel> getStores(Locale currentLocale) async {
    final res = await client.request(
      _endpoint('/store/list/${currentLocale.tagName.toLowerCase()}'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return StoreModel.fromJson(_decodeRes(res));
  }

  /// 取得該店家的遊戲列表API
  ///
  /// 需要傳入店家編號 [storeId]
  @override
  Future<GameList> getGameList({required String storeId}) async {
    final res = await client.request(
      _endpoint('/gamelist'),
      method: HttpMethod.post,
      rawBody: {'sid': storeId},
    );
    return GameList.fromJson(_decodeRes(res));
  }

  /// 取得遊戲機台資料API
  @override
  Future<CabinetModel> selGame(String machineId) async {
    final res = await client.request(
      _endpoint('/cablist/$machineId'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return CabinetModel.fromJson(_decodeRes(res));
  }

  /// 投幣API
  ///
  /// 需要傳入是否用券[isTicket]、機台編號[id]、投幣模式[mode]
  @override
  Future<BasicResponse> doInsert(
    bool isTicket,
    String id,
    num mode,
    bool isUseRewardPoint,
  ) async {
    final insertUrl = isTicket ? 'tic' : 'pay';
    String url = '/$insertUrl/$id/${mode.toInt()}';
    if (!isTicket) {
      url += '/${isUseRewardPoint ? 1 : 0}';
    }

    final res = await client.request(
      _endpoint(url),
      method: HttpMethod.post,
      rawBody: {},
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 投幣API
  ///
  /// 需要傳入原始URL [url]，使用於 QRCode 掃描後 (QRPay) 的投幣
  @override
  Future<BasicResponse> doInsertRawUrl(String url) async {
    final res = await client.request(
      Uri.parse(url),
      method: HttpMethod.post,
      rawBody: {},
    );
    return BasicResponse.fromJson(_decodeRes(res));
  }

  /// 取得排隊人數API
  ///
  /// 需要傳入 [padmid] 和 [padlid]
  @override
  Future<int> getPadLineup(String padmid, String padlid) async {
    final res = await client.request(
      _endpoint('/pad/getCount/$padmid/$padlid'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return int.tryParse(res.body) ?? -1;
  }

  /// 確認平板排隊API
  ///
  /// 需要傳入 [padmid] 和 [padlid]
  @override
  Future<void> confirmPadCheck(String padmid, String padlid) async {
    await client.request(
      _endpoint('/pad/onCheck/$padmid/$padlid'),
      method: HttpMethod.post,
      rawBody: {},
    );
  }

  /// QRCode 解析API
  ///
  /// 用於解析店內平板排隊 QRCode、儲值 QRCode
  ///
  /// 需要傳入QRCode解析後的String [rawText]
  ///
  /// 回傳解析結果 [String]
  @override
  Future<String> qrDecryt(String rawText) async {
    final res = await client.request(
      _endpoint('/qrDecryt/'),
      method: HttpMethod.post,
      contentType: ContentType.xForm,
      rawBody: {'code': rawText},
    );
    return res.body;
  }

  /// 開門按鈕API
  ///
  /// 需要傳入與店家距離 [distance]、店門名稱 [doorName]
  @override
  Future<String> remoteOpenDoor(
    double distance, {
    required String doorName,
  }) async {
    final res = await client.request(
      Uri.parse('https://pay.x50.fun/api/$doorName/open/$distance'),
      method: HttpMethod.post,
      contentType: ContentType.xForm,
      rawBody: {},
    );
    return res.body;
  }

  /// 取得禮物箱API
  ///
  /// 用於禮物系統頁面，回傳 [GiftBoxModel]
  @override
  Future<GiftBoxModel> getGiftBox() async {
    final res = await client.request(
      _endpoint('/gift/box'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return GiftBoxModel.fromJson(_decodeRes(res));
  }

  /// 取得養成抽獎箱API
  ///
  /// 用於禮物系統頁面，回傳 [LotteListModel]
  @override
  Future<LotteListModel> getLotteList() async {
    final res = await client.request(
      _endpoint('/lotte/list'),
      method: HttpMethod.post,
      rawBody: {},
    );
    return LotteListModel.fromJson(_decodeRes(res));
  }

  /// 兌換禮物API
  ///
  /// 用於禮物系統頁面，需要傳入禮物編號 [gid]
  @override
  Future<void> giftExchange(String gid) {
    return client.request(
      _endpoint('/confirmGFID'),
      method: HttpMethod.post,
      rawBody: {'contentgid': gid},
    );
  }

  /// 取得更衣室的所有衣服API
  @override
  Future<http.Response> getAvatar() {
    return client.request(_endpoint('/list/avater'), method: HttpMethod.get);
  }

  /// 設定角色衣服API
  @override
  Future<http.Response> setAvatar(String id) {
    return client.request(
      _endpoint('/cgAva/$id'),
      rawBody: {},
      method: HttpMethod.post,
      contentType: ContentType.json,
    );
  }

  /// 月票人際帝方案的購買API
  ///
  /// 需要傳入參加人[applicants]
  @override
  Future<http.Response> buyVipMany(List<String>? applicants) {
    final body = <String, String>{};
    if (applicants != null) {
      int count = 0;
      for (var applicant in applicants) {
        count++;
        body.addAll({'id$count': applicant});
      }
    }

    return client.request(
      _endpoint('/vip/buymany'),
      rawBody: body,
      method: HttpMethod.post,
      contentType: ContentType.json,
    );
  }

  /// 月票月養成方案的購買API
  @override
  Future<http.Response> buyVipGradeOne() {
    return client.request(
      _endpoint('/vip/buygrdone'),
      rawBody: {},
      method: HttpMethod.post,
      contentType: ContentType.json,
    );
  }

  /// 月票邊緣人方案的購買API
  @override
  Future<http.Response> buyVipOne() {
    return client.request(
      _endpoint('/vip/buyone'),
      rawBody: {},
      method: HttpMethod.post,
      contentType: ContentType.json,
    );
  }

  /// 取得最新活動web document API
  ///
  /// 需要傳入活動編號 [cid]。
  ///
  /// 因目前還沒有最新活動的相關API，故使用此方式取得最新活動頁面的HTML。
  @override
  Future<String> getCampaignDocument(String cid) async {
    final response = await client.request(
      Uri.parse('https://pay.x50.fun/coupon/$cid'),
      method: HttpMethod.get,
    );
    return response.body;
  }

  /// 新增最新活動印章列API
  ///
  /// 需要傳入活動編號 [cid]。
  @override
  Future<void> addCampaignStampRow(String cid) {
    return client.request(
      Uri.parse('https://pay.x50.fun/li/ev/$cid'),
      method: HttpMethod.get,
    );
  }

  /// 取得贊助商web document API
  ///
  /// 因目前還沒有贊助商的相關API，故使用此方式取得贊助商頁面的HTML。
  @override
  Future<String> getSponserDocument() async {
    final response = await client.request(
      Uri.parse('https://pay.x50.fun/static/templates-v4/sponser.html?v1.1'),
      method: HttpMethod.get,
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }

  /// 取得養成商場內，點數兌換商品資料API
  @override
  Future<String> fetchGradeBox() async {
    final response = await client.request(
      _endpoint('/grade/box'),
      method: HttpMethod.post,
      rawBody: {},
      contentType: ContentType.json,
    );
    return response.body;
  }

  /// 兌換養成商場內商品API
  ///
  /// 需要傳入 [gid] 及 [grid]
  @override
  Future<String> chgGradev2(String gid, String grid) async {
    final response = await client.request(
      _endpoint('/grade/change'),
      rawBody: {'gid': gid, 'grid': grid},
      method: HttpMethod.post,

      contentType: ContentType.json,
    );
    return response.body;
  }

  @override
  Future<http.Response> getDocument(String fullUrl) async {
    final response = await client.request(
      Uri.parse(fullUrl),
      method: HttpMethod.get,
    );
    return response;
  }

  @override
  Future<String> getQRPayDocument(String url) async {
    final response = await client.request(
      Uri.parse(url),
      method: HttpMethod.get,
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }

  @override
  Future<String> getDocumentWithDomainPrefix(
    String url,
    String refererUrl, {
    required String descLabel,
  }) async {
    final response = await client.request(
      Uri.parse("https://pay.x50.fun$url"),
      method: HttpMethod.get,
      customHeaders: {'Referer': refererUrl},
    );
    return const Utf8Decoder().convert(response.bodyBytes);
  }

  @override
  Future<String> redeemQuestCampaignItem(
    String campaignId,
    String itemId,
  ) async {
    final response = await client.request(
      Uri.parse("https://pay.x50.fun/coupon/changecheck/$campaignId/$itemId"),
      method: HttpMethod.get,
    );
    return response.body;
  }

  @override
  Future<GameList> favGameList() async {
    final res = await client.request(
      _endpoint('/favgamelist'),
      rawBody: {},
      method: HttpMethod.post,
      contentType: ContentType.json,
    );
    return GameList.fromJson(_decodeRes(res));
  }

  @override
  Future<void> setFavGames(List<String> favGames) {
    return client.request(
      _endpoint('/settingFavConfirm'),
      rawBody: {"favlist": favGames},
      method: HttpMethod.post,
      contentType: ContentType.json,
    );
  }
}
