import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/page/game/game_cabs_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

class MockGameCabViewModel extends Mock implements GameCabsViewModel {}

class MockStore extends Mock implements Store {}

final mockRepo = MockRepository();

void main() {
  const storeId = "7037656";
  const fakeLocale = Locale('zh', 'TW');
  const fakeStoreResponse =
      '''{"prefix":"70","storelist":[{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u6b66\u660c\u8857\u4e8c\u6bb5134\u865f1\u6a13","name":"\u897f\u9580\u4e00\u5e97","sid":37656},{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u5eb7\u5b9a\u8def10\u865f1\u6a13","name":"\u897f\u9580\u4e8c\u5e97","sid":37658}]}''';
  final fakeStoreModel = StoreModel.fromJson(json.decode(fakeStoreResponse));

  void arrangeGetGameListReturnsGameList() {
    when(() => mockRepo.getGameList(storeId: any(named: 'storeId')))
        .thenAnswer((_) async {
      const rawResponse =
          '''{"message":"done","code":200,"machinelist":[{"lable":"maimaiDX","price":9.0,"discount":9.0,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[1,"\u9762\u76f8\u5927\u9580\u5de6\u5074","\u9762\u76f8\u5927\u9580\u53f3\u5074",false,"twor"],"cabinet_detail":{"0":{"notice":"\u53f3 (\u820a\u6846\u6309\u9375)"},"1":{"notice":"\u5de6 (\u76f4\u64ad/DX\u9375)"},"2":{"notice":"\u5de6\u5f8c (DX\u6846\u6309\u9375)"}},"cabinet":2,"enable":true,"id":"mmdx","shop":"7037656","lora":false,"pad":true,"padlid":"mmdx","padmid":"50Pad01","esp":true},{"lable":"DanceDanceRevolution","price":9,"discount":9,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"ddr","shop":"7037656","lora":false,"esp":true,"padlid":"ddr","padmid":"50Pad05","pad":true},{"lable":"GrooveCoaster","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"4 Max",false,"one"],"cabinet_detail":{"0":{"notice":"DDR \u65c1"}},"cabinet":0.0,"enable":true,"id":"gc","shop":"7037656","lora":true},{"lable":"pop'n music","price":9,"discount":9,"downprice":[25.0,1.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true]],"note":[0,"pop\u2019n music UniLab",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"pop","shop":"7037656","lora":true,"pad":true,"padlid":"pop","padmid":"50Pad05"},{"lable":"Jubeat","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"Jubeat festo",false,"one"],"cabinet_detail":{"0":{"notice":"WACCA \u65c1"}},"cabinet":0,"enable":true,"id":"ju","shop":"7037656","lora":true},{"lable":"SDVX Valkyrie Model","price":9,"discount":8.5,"downprice":[1,34,43,51],"mode":[[0,"Light/Arena/Mega",34.0,true],[1,"Standard \uff08\u62632\u5238\uff09",43.0,true],[2,"Blaster/Premium (\u62632\u5238)",51.0,true]],"note":[1,"\u9760\u5f8c","\u9760\u524d",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"},"2":{"notice":"(\u53f3\u53f0\u5f8c)"},"3":{"notice":"(\u5de6\u53f0\u5f8c)"}},"cabinet":3,"enable":true,"id":"nvsv","shop":"7037656","lora":false,"pad":true,"padlid":"nvsv","padmid":"50Pad04","esp":true},{"lable":"WACCA","price":10.0,"discount":10.0,"downprice":null,"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[0.0,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"Jubeat \u65c1"}},"cabinet":0,"enable":true,"id":"wac","shop":"7037656","lora":false,"esp":true},{"lable":"Beatmania IIDX LM","price":9,"discount":8,"downprice":[1,34,51],"mode":[[0,"Standard",34.0,true],[1,"P-Free ",51.0,true]],"note":[1,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"mai2\u865f\u65c1"}},"cabinet":0,"enable":true,"id":"iidx","shop":"7037656","lora":false,"esp":true}],"payMid":null,"payLid":null,"payCid":null}''';
      return GameList.fromJson(json.decode(rawResponse));
    });
  }

  void arrangeGetGameListReturnsEmptyGameList() {
    when(() => mockRepo.getGameList(storeId: any(named: 'storeId')))
        .thenAnswer((_) async {
      return const GameList.empty();
    });
  }

  void arrangeGetGameListThrowsExcpetion() {
    when(() => mockRepo.getGameList(storeId: any(named: 'storeId')))
        .thenThrow(Exception);
  }

  void arrangeGetStoresReturnsStoreModel() {
    when(() => mockRepo.getStores(any())).thenAnswer((_) async {
      return fakeStoreModel;
    });
  }

  void arrangeGetStoresReturnsEmptyStore() {
    when(() => mockRepo.getStores(any())).thenAnswer((_) async {
      return const StoreModel.empty();
    });
  }

  void arrangeGetStoresThrowsException() {
    when(() => mockRepo.getStores(any())).thenThrow(Exception);
  }

  void arrangeNotRememberGameTab() {
    SharedPreferences.setMockInitialValues({"remember_game_tab": false});
  }

  void arrangeRememberGameTabAndTabToFavGame() {
    SharedPreferences.setMockInitialValues({
      "remember_game_tab": true,
      "store_id": storeId,
      "last_game_tab_index": 0,
    });
  }

  void arrangeRememberGameTabAndTabToStoreGame() {
    SharedPreferences.setMockInitialValues({
      "remember_game_tab": true,
      "store_id": storeId,
      "last_game_tab_index": 1,
    });
  }

  setUpAll(() {
    registerFallbackValue(fakeLocale);
  });

  test('當記憶策略未設定', () async {
    arrangeNotRememberGameTab();

    arrangeGetGameListReturnsGameList();
    arrangeGetStoresReturnsStoreModel();

    final viewModel = GameCabsViewModel(
      repository: mockRepo,
      currentLocale: fakeLocale,
    );
    await viewModel.init();
    final gameList = viewModel.gameList;
    expect(viewModel.segmentedControlIndex, GameCabsViewModel.favGameIndex);
    expect(gameList, const GameList.empty());
  });
  group('當已設定記憶策略', () {
    setUpAll(() {
      arrangeGetGameListReturnsGameList();
      arrangeGetStoresReturnsStoreModel();
    });

    test('之前的頁面是釘選機台，回傳空GameList', () async {
      arrangeRememberGameTabAndTabToFavGame();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      );
      await viewModel.init();
      final storeName = viewModel.selectedStore?.name;
      expect(storeName, isNull);
      final gameList = viewModel.gameList;
      expect(gameList, const GameList.empty());
      final tabIndex = viewModel.segmentedControlIndex;
      expect(tabIndex, isZero);
    });
    test('之前的頁面是店家，回傳GameList', () async {
      arrangeRememberGameTabAndTabToStoreGame();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      );
      await viewModel.init();
      final storeName = viewModel.selectedStore?.name;
      expect(storeName, isNotNull);
      final gameList = viewModel.gameList;
      expect(gameList, isNot(const GameList.empty()));
      final tabIndex = viewModel.segmentedControlIndex;
      expect(tabIndex, isNonZero);
    });
  });

  group("取得店家資料", () {
    test("當取得店家資料成功，回傳StoreModel", () async {
      arrangeGetStoresReturnsStoreModel();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      );
      final storeModel = await viewModel.getStoreData();
      expect(storeModel, isNotNull);
    });
    test("當取得店家資料失敗，回傳StoreModel.empty()", () async {
      arrangeGetStoresThrowsException();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      );
      var storeModel = await viewModel.getStoreData();
      expect(storeModel, const StoreModel.empty());

      arrangeGetStoresReturnsEmptyStore();
      storeModel = await viewModel.getStoreData();
      expect(storeModel, const StoreModel.empty());
    });
  });

  group("取得遊戲列表", () {
    test("當取得遊戲列表成功，回傳GameList", () async {
      arrangeGetGameListReturnsGameList();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      );
      await viewModel.getGamelist(storeId);
      final gameList = viewModel.gameList;
      expect(gameList, isNot(const GameList.empty()));
    });
    test("當取得遊戲列表失敗，回傳空GameList", () async {
      arrangeGetGameListThrowsExcpetion();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      );
      await viewModel.getGamelist(storeId);
      var gameList = viewModel.gameList;
      expect(gameList, const GameList.empty());

      arrangeGetGameListReturnsEmptyGameList();
      await viewModel.getGamelist(storeId);
      gameList = viewModel.gameList;
      expect(gameList, const GameList.empty());
    });
  });

  group('切換Tab', () {
    setUp(() {
      arrangeGetGameListReturnsGameList();
      arrangeGetStoresReturnsStoreModel();
      arrangeRememberGameTabAndTabToStoreGame();
      SharedPreferences.setMockInitialValues({});
    });

    test('當切換至店家時，存入店家資料至Prefs', () async {
      final mockStore = MockStore();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      );
      await viewModel.onStoreSelected(mockStore, storeId);
      final prefsValue = await Prefs.getString(PrefsToken.storeId);
      expect(prefsValue, storeId);
    });

    test('當切換tab時，點選為店家，取得店家資料', () async {
      const expectTabIndex = 1;
      arrangeRememberGameTabAndTabToStoreGame();
      final viewModel = GameCabsViewModel(
        repository: mockRepo,
        currentLocale: fakeLocale,
      )
        ..setStoreDetails(fakeStoreModel)
        ..onTabIndexChanged(1);
      final store = viewModel.selectedStore;
      expect(store, isNot(const StoreModel.empty()));
      final actualTabIndex = await Prefs.getInt(PrefsToken.lastGameTabIndex);
      expect(actualTabIndex, expectTabIndex);
    });
  });
}
