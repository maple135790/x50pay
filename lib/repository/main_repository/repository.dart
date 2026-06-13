import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/user/user.dart';

/// 存放主要 API 呼叫的介面。
///
/// API 呼叫細節請參考各實作類別。
abstract interface class Repository {
  /// 登入API
  ///
  /// 需要傳入 [email] 和 [password]。
  Future<BasicResponse?> login({
    required String email,
    required String password,
  });

  /// 取得使用者資料API
  Future<ApiResponse<UserModel>> getUser();

  /// 取得首頁資料API
  Future<EntryModel?> getEntry();

  /// 登出API
  Future<void> logout();

  /// 取得店家資料API
  Future<StoreModel> getStores(Locale currentLocale);

  /// 取得該店家的遊戲列表API
  ///
  /// 需要傳入店家編號 [storeId]
  Future<GameList> getGameList({required String storeId});

  /// 取得遊戲機台資料API
  Future<CabinetModel> selGame(String machineId);

  /// 投幣API
  ///
  /// 需要傳入是否用券[isTicket]、機台編號[id]、投幣模式[mode]
  Future<BasicResponse> doInsert(
    bool isTicket,
    String id,
    num mode,
    bool isUseRewardPoint,
  );

  /// 投幣API
  ///
  /// 需要傳入原始URL [url]，使用於 QRCode 掃描後 (QRPay) 的投幣
  Future<BasicResponse> doInsertRawUrl(String url);

  /// 取得排隊人數API
  ///
  /// 需要傳入 [padmid] 和 [padlid]
  Future<int> getPadLineup(String padmid, String padlid);

  /// 確認平板排隊API
  ///
  /// 需要傳入 [padmid] 和 [padlid]
  Future<void> confirmPadCheck(String padmid, String padlid);

  /// QRCode 解析API
  ///
  /// 用於解析店內平板排隊 QRCode、儲值 QRCode
  ///
  /// 需要傳入QRCode解析後的String [rawText]
  ///
  /// 回傳解析結果 [String]
  Future<String> qrDecryt(String rawText);

  /// 開門按鈕API
  ///
  /// 需要傳入與店家距離 [distance]、店門名稱 [doorName]
  Future<String> remoteOpenDoor(
    double distance, {
    required String doorName,
  });

  /// 取得禮物箱API
  ///
  /// 用於禮物系統頁面，回傳 [GiftBoxModel]
  Future<GiftBoxModel> getGiftBox();

  /// 取得養成抽獎箱API
  ///
  /// 用於禮物系統頁面，回傳 [LotteListModel]
  Future<LotteListModel> getLotteList();

  /// 兌換禮物API
  ///
  /// 用於禮物系統頁面，需要傳入禮物編號 [gid]
  Future<void> giftExchange(String gid);

  /// 取得更衣室的所有衣服API
  Future<http.Response> getAvatar();

  /// 設定角色衣服API
  Future<http.Response> setAvatar(String id);

  /// 月票人際帝方案的購買API
  ///
  /// 需要傳入參加人[applicants]
  Future<http.Response> buyVipMany(List<String>? applicants);

  /// 月票月養成方案的購買API
  Future<http.Response> buyVipGradeOne();

  /// 月票邊緣人方案的購買API
  Future<http.Response> buyVipOne();

  /// 取得最新活動web document API
  ///
  /// 需要傳入活動編號 [cid]。
  ///
  /// 因目前還沒有最新活動的相關API，故使用此方式取得最新活動頁面的HTML。
  Future<String> getCampaignDocument(String cid);

  /// 新增最新活動印章列API
  ///
  /// 需要傳入活動編號 [cid]。
  Future<void> addCampaignStampRow(String cid);

  /// 取得贊助商web document API
  ///
  /// 因目前還沒有贊助商的相關API，故使用此方式取得贊助商頁面的HTML。
  Future<String> getSponserDocument();

  /// 取得養成商場內，點數兌換商品資料API
  Future<String> fetchGradeBox();

  /// 兌換養成商場內商品API
  ///
  /// 需要傳入 [gid] 及 [grid]
  Future<String> chgGradev2(String gid, String grid);

  Future<http.Response> getDocument(String fullUrl);

  Future<String> getQRPayDocument(String url);

  Future<String> getDocumentWithDomainPrefix(
    String url,
    String refererUrl, {
    required String descLabel,
  });

  Future<String> redeemQuestCampaignItem(String campaignId, String itemId);

  Future<GameList> favGameList();

  Future<void> setFavGames(List<String> favGames);
}
