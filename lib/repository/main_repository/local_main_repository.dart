import 'dart:ui';

import 'package:flutter/services.dart';
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
import 'package:x50pay/repository/main_repository/main_repository.dart';

class LocalMainRepository implements MainRepository {
  @override
  Future<void> addCampaignStampRow(String cid) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> buyVipGradeOne() {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> buyVipMany(List<String>? applicants) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> buyVipOne() {
    throw UnimplementedError();
  }

  @override
  Future<String> chgGradev2(String gid, String grid) {
    throw UnimplementedError();
  }

  @override
  Future<void> confirmPadCheck(String padmid, String padlid) {
    throw UnimplementedError();
  }

  @override
  Future<BasicResponse> doInsert(
    bool isTicket,
    String id,
    num mode,
    bool isUseRewardPoint,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<BasicResponse> doInsertRawUrl(String url) {
    throw UnimplementedError();
  }

  @override
  Future<GameList> favGameList() {
    throw UnimplementedError();
  }

  @override
  Future<String> fetchGradeBox() {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> getAvatar() {
    throw UnimplementedError();
  }

  @override
  Future<String> getCampaignDocument(String cid) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> getDocument(String fullUrl) async {
    final body = await rootBundle.loadString('assets/tests/scan_pay.html');
    return http.Response(body, 200);
  }

  @override
  Future<String> getDocumentWithDomainPrefix(
    String url,
    String refererUrl, {
    required String descLabel,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<EntryModel?> getEntry() async {
    return const EntryModel.empty();
  }

  @override
  Future<GameList> getGameList({required String storeId}) {
    throw UnimplementedError();
  }

  @override
  Future<GiftBoxModel> getGiftBox() {
    throw UnimplementedError();
  }

  @override
  Future<LotteListModel> getLotteList() {
    throw UnimplementedError();
  }

  @override
  Future<int> getPadLineup(String padmid, String padlid) async {
    return 0;
  }

  @override
  Future<String> getQRPayDocument(String url) {
    return rootBundle.loadString('assets/tests/scan_pay_x50pay.html');
  }

  @override
  Future<String> getSponserDocument() {
    throw UnimplementedError();
  }

  @override
  Future<StoreModel> getStores(Locale currentLocale) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse<UserModel>> getUser() async {
    return ApiResponse.createSuccess(const UserModel.empty());
  }

  @override
  Future<void> giftExchange(String gid) {
    throw UnimplementedError();
  }

  @override
  Future<BasicResponse?> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<String> qrDecryt(String rawText) {
    throw UnimplementedError();
  }

  @override
  Future<String> redeemQuestCampaignItem(String campaignId, String itemId) {
    throw UnimplementedError();
  }

  @override
  Future<String> remoteOpenDoor(double distance, {required String doorName}) {
    throw UnimplementedError();
  }

  @override
  Future<CabinetModel> selGame(String machineId) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> setAvatar(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> setFavGames(List<String> favGames) {
    throw UnimplementedError();
  }
}
