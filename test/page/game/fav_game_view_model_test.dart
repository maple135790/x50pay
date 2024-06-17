import 'dart:convert';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/page/game/fav_game_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();

void main() {
  const fakeLocale = Locale('zh', 'TW');

  void arrangeGetFavGameListReturnsGameList() {
    when(() => mockRepo.favGameList()).thenAnswer((_) async {
      const rawResponse =
          '''{"message":"done","code":200,"machinelist":[{"lable":"maimaiDX","price":9.0,"discount":9.0,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[1,"\u9762\u76f8\u5927\u9580\u5de6\u5074","\u9762\u76f8\u5927\u9580\u53f3\u5074",false,"twor"],"cabinet_detail":{"0":{"notice":"\u53f3 (\u820a\u6846\u6309\u9375)"},"1":{"notice":"\u5de6 (\u76f4\u64ad/DX\u9375)"},"2":{"notice":"\u5de6\u5f8c (DX\u6846\u6309\u9375)"}},"cabinet":2,"enable":true,"id":"mmdx","shop":"7037656","lora":false,"pad":true,"padlid":"mmdx","padmid":"50Pad01","esp":true},{"lable":"DanceDanceRevolution","price":9,"discount":9,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"ddr","shop":"7037656","lora":false,"esp":true,"padlid":"ddr","padmid":"50Pad05","pad":true},{"lable":"GrooveCoaster","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"4 Max",false,"one"],"cabinet_detail":{"0":{"notice":"DDR \u65c1"}},"cabinet":0.0,"enable":true,"id":"gc","shop":"7037656","lora":true},{"lable":"pop'n music","price":9,"discount":9,"downprice":[25.0,1.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true]],"note":[0,"pop\u2019n music UniLab",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"pop","shop":"7037656","lora":true,"pad":true,"padlid":"pop","padmid":"50Pad05"},{"lable":"Jubeat","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"Jubeat festo",false,"one"],"cabinet_detail":{"0":{"notice":"WACCA \u65c1"}},"cabinet":0,"enable":true,"id":"ju","shop":"7037656","lora":true},{"lable":"SDVX Valkyrie Model","price":9,"discount":8.5,"downprice":[1,34,43,51],"mode":[[0,"Light/Arena/Mega",34.0,true],[1,"Standard \uff08\u62632\u5238\uff09",43.0,true],[2,"Blaster/Premium (\u62632\u5238)",51.0,true]],"note":[1,"\u9760\u5f8c","\u9760\u524d",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"},"2":{"notice":"(\u53f3\u53f0\u5f8c)"},"3":{"notice":"(\u5de6\u53f0\u5f8c)"}},"cabinet":3,"enable":true,"id":"nvsv","shop":"7037656","lora":false,"pad":true,"padlid":"nvsv","padmid":"50Pad04","esp":true},{"lable":"WACCA","price":10.0,"discount":10.0,"downprice":null,"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[0.0,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"Jubeat \u65c1"}},"cabinet":0,"enable":true,"id":"wac","shop":"7037656","lora":false,"esp":true},{"lable":"Beatmania IIDX LM","price":9,"discount":8,"downprice":[1,34,51],"mode":[[0,"Standard",34.0,true],[1,"P-Free ",51.0,true]],"note":[1,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"mai2\u865f\u65c1"}},"cabinet":0,"enable":true,"id":"iidx","shop":"7037656","lora":false,"esp":true}],"payMid":null,"payLid":null,"payCid":null}''';
      return GameList.fromJson(json.decode(rawResponse));
    });
  }

  void arrangeGetStoresReturnsStoreModel() {
    when(() => mockRepo.getStores(any())).thenAnswer((_) async {
      const rawResponse =
          '''{"prefix":"70","storelist":[{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u6b66\u660c\u8857\u4e8c\u6bb5134\u865f1\u6a13","name":"\u897f\u9580\u4e00\u5e97","sid":37656},{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u5eb7\u5b9a\u8def10\u865f1\u6a13","name":"\u897f\u9580\u4e8c\u5e97","sid":37658}]}''';
      final storeModel = StoreModel.fromJson(json.decode(rawResponse));
      return storeModel;
    });
  }

  void arrageGetStoresReturnsEmptyStoreModel() {
    when(() => mockRepo.getStores(any())).thenAnswer((_) async {
      return const StoreModel.empty();
    });
  }

  void arrangeGetFavGameListReturnsEmptyGameList() {
    when(() => mockRepo.favGameList()).thenAnswer((_) async {
      return const GameList.empty();
    });
  }

  final viewModel = FavGameViewModel(
    repository: mockRepo,
    currentLocale: fakeLocale,
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    registerFallbackValue(fakeLocale);
  });

  group(
    '取得TileStyle',
    () {
      final defaultValue =
          GameCabTileStyle.fromInt(GameCabTileStyle.pinnedDefaultValue);
      test('無設定值', () async {
        final tileStyle = await viewModel.getTileStyle();
        expect(tileStyle, equals(defaultValue));
      });
      test('有設定值', () async {
        SharedPreferences.setMockInitialValues({
          PrefsToken.pinnedGameCabTileStyle.value: GameCabTileStyle.large.value,
        });
        final viewModel = FavGameViewModel(
          repository: mockRepo,
          currentLocale: fakeLocale,
        );
        final tileStyle = await viewModel.getTileStyle();
        expect(tileStyle, equals(GameCabTileStyle.large));
      });
    },
  );

  group(
    '取得店家資料',
    () {
      test('當沒有取得店家資料，預期得到空StoreModel', () async {
        arrageGetStoresReturnsEmptyStoreModel();
        final storeModel = await viewModel.getStoreData();
        expect(storeModel, equals(const StoreModel.empty()));
      });
      test('當取得店家資料，預期得到不為空的StoreModel', () async {
        arrangeGetStoresReturnsStoreModel();
        final storeModel = await viewModel.getStoreData();
        expect(storeModel, isNot(const StoreModel.empty()));
      });
    },
  );

  group(
    '取得釘選遊戲',
    () {
      test('當沒有釘選遊戲，預期取得空GameList', () async {
        arrangeGetFavGameListReturnsEmptyGameList();
        final favGame = await viewModel.getFavGame();
        expect(favGame, equals(const GameList.empty()));
      });

      test('當有釘選遊戲，預期取得的GameList 不為空', () async {
        arrangeGetFavGameListReturnsGameList();
        final favGame = await viewModel.getFavGame();
        expect(favGame, isNot(const GameList.empty()));
      });
    },
  );

  group('製作Store 和name 的Map', () {
    test('當有回傳Store，取得不為空的Map', () async {
      arrangeGetStoresReturnsStoreModel();
      final model = await viewModel.getStoreData();
      final map = viewModel.buildStoreNameMap(model);
      expect(map, isNot(const <String, String>{}));
    });
    test('當沒回傳Store，取得為空的Map', () async {
      arrageGetStoresReturnsEmptyStoreModel();
      final model = await viewModel.getStoreData();
      final map = viewModel.buildStoreNameMap(model);
      expect(map, equals(const <String, String>{}));
    });
  });
}
