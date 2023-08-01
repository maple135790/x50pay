import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/repository/repository.dart';

class GameViewModel extends BaseViewModel {
  final repo = Repository();
  final isForce = GlobalSingleton.instance.devIsServiceOnline;

  StoreModel? stores;
  String? storeName;
  Gamelist? gamelist;
  CabinetModel? cabinetModel;
  // UserModel? user;

  FutureOr<String?> gamePageRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final router = GoRouter.of(context);
    final hasStore = await hasRecentStore();
    if (!hasStore) {
      final storeData = await getStoreData();
      router.pushNamed(
        AppRoutes.gameStore.routeName,
        extra: storeData,
      );
    }
    final gameList = await getGamelist();
    router.pushNamed(
      AppRoutes.gameCabs.routeName,
      pathParameters: {'storeName': storeName!},
      extra: gameList,
    );
  }

  Future<StoreModel?> getStoreData({
    int debugFlag = 200,
  }) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      if (!kDebugMode || isForce) {
        // user ??= await repo.getUser();
        stores = await repo.getStores();
      } else {
        // user = UserModel.fromJson(jsonDecode(testUser(code: debugFlag)));
        stores = StoreModel.fromJson(jsonDecode(testStorelist));
      }
      // GlobalSingleton.instance.user = user;
      await EasyLoading.dismiss();
      return stores;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<bool> hasRecentStore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('store_id') != null ||
        prefs.getString('store_name') != null;
  }

  Future<Gamelist?> getGamelist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return null;

      if (!kDebugMode || isForce) {
        gamelist = await repo.getGameList(storeId: sid);
        storeName = prefs.getString('store_name');
      } else {
        storeName = prefs.getString('store_name');
        if (sid == '7037656') {
          gamelist = Gamelist.fromJson(jsonDecode(testGamelistWULIN1));
        }
        if (sid == '7037657') {
          gamelist = Gamelist.fromJson(jsonDecode(testGamelistSHILIN));
        }
        if (sid == '7037658') {
          gamelist = Gamelist.fromJson(jsonDecode(testGamelistWULIN2));
        }
      }
      return gamelist;
    } on Exception catch (_) {
      return null;
    }
  }

  String testUser({int code = 200}) =>
      '''{"message":"done","code":$code,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","email":"maple135790@gmail.com","uid":"938","point":18.0,"name":"\u9bd6\u7f36","ticketint":7,"phoneactive":true,"vip":true,"vipdate":{"\$date":1657660411780},"sid":"","sixn":"523964","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#"}''';

  String testStorelist =
      '''{"prefix":"70","storelist":[{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u6b66\u660c\u8857\u4e8c\u6bb5134\u865f1\u6a13","name":"\u897f\u9580\u4e00\u5e97","sid":37656},{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u5eb7\u5b9a\u8def10\u865f1\u6a13","name":"\u897f\u9580\u4e8c\u5e97","sid":37658}]}''';
  String testGamelistWULIN1 =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u897f\u9580\u4e00\u5e97] maimaiDX","price":9.0,"discount":9.0,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50.0,true]],"note":[1,"\u9762\u76f8\u5927\u9580\u5de6\u5074","\u9762\u76f8\u5927\u9580\u53f3\u5074",false,"twor"],"cabinet_detail":{"0":{"notice":"\u53f3 (\u820a\u6846\u6309\u9375)"},"1":{"notice":"\u5de6 (\u76f4\u64ad/DX\u9375)"},"2":{"notice":"\u5de6\u5f8c (DX\u6846\u6309\u9375)"}},"cabinet":2,"enable":true,"id":"mmdx","shop":"7037656","lora":false,"pad":true,"padlid":"mmdx","padmid":"50Pad01","esp":true,"vipb":true},{"lable":"[\u897f\u9580\u4e00\u5e97] DanceDanceRevolution","price":9,"discount":9,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50.0,true]],"note":[0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"ddr","shop":"7037656","lora":false,"esp":true,"padlid":"ddr","padmid":"50Pad05","pad":true,"vipb":true},{"lable":"[\u897f\u9580\u4e00\u5e97] GrooveCoaster","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"4 Max",false,"one"],"cabinet_detail":{"0":{"notice":"DDR \u65c1"}},"cabinet":0.0,"enable":true,"id":"gc","shop":"7037656","lora":true,"vipb":true},{"lable":"[\u897f\u9580\u4e00\u5e97] pop'n music","price":9,"discount":9,"downprice":[25.0,1.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true]],"note":[0,"pop\u2019n music UniLab",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"pop","shop":"7037656","lora":true,"pad":true,"padlid":"pop","padmid":"50Pad05","vipb":true},{"lable":"[\u897f\u9580\u4e00\u5e97] Jubeat","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"Jubeat festo",false,"one"],"cabinet_detail":{"0":{"notice":"WACCA \u65c1"}},"cabinet":0,"enable":true,"id":"ju","shop":"7037656","lora":true,"vipb":true},{"lable":"[\u897f\u9580\u4e00\u5e97] SDVX Valkyrie Model","price":9,"discount":8.5,"downprice":[1,34,43,51],"mode":[[0,"Light/Arena/Mega",34.0,true],[1,"Standard ",43.0,true],[2,"Blaster/Premium (\u8a08\u5169\u9053)",51.0,true]],"note":[1,"\u9760\u5f8c","\u9760\u524d",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"},"2":{"notice":"(\u53f3\u53f0\u5f8c)"},"3":{"notice":"(\u5de6\u53f0\u5f8c)"}},"cabinet":3,"enable":true,"id":"nvsv","shop":"7037656","lora":false,"pad":true,"padlid":"nvsv","padmid":"50Pad04","esp":true,"vipb":true},{"lable":"[\u897f\u9580\u4e00\u5e97] WACCA","price":10.0,"discount":10.0,"downprice":null,"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[0.0,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"Jubeat \u65c1"}},"cabinet":0,"enable":true,"id":"wac","shop":"7037656","lora":false,"esp":true},{"lable":"[\u897f\u9580\u4e00\u5e97] Beatmania IIDX","price":9,"discount":8,"downprice":[],"mode":[[0,"Standard",24.0,true],[1,"Premium Free",40.0,true]],"note":[1,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"\u820a\u6846\u9ad4"}},"cabinet":0,"enable":true,"id":"iidx","shop":"7037656","lora":false,"esp":true,"vipb":true}],"payMid":null,"payLid":null,"payCid":null}''';
  String testGamelistWULIN2 =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","price":9,"discount":9,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50.0,true]],"note":[0,"1F/\u9032\u9580\u53f3\u5074","1F/\u9032\u9580\u5de6\u524d",false,"one"],"cabinet_detail":{"0":{"notice":"\u53f3 (\u76f4\u64ad/DX\u9375)"},"1":{"notice":"\u5de6 (DX\u6309\u9375)"}},"cabinet":1,"enable":true,"id":"2mmdx","shop":"7037658","lora":false,"pad":true,"padlid":"twommdx","padmid":"50Pad02","esp":true,"vipb":true},{"lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","price":9,"discount":9,"downprice":[25,1],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true]],"note":[3,"A\u7d44/\u80cc\u5c0d\u6a13\u68af","B\u7d44/\u9762\u5c0d\u6a13\u68af",false,"four"],"cabinet_detail":{"0":{"notice":"\u5de6\u5074(A\u7d44)"},"1":{"notice":"\u5de6\u4e2d(A\u7d44)"},"2":{"notice":"\u53f3\u4e2d(A\u7d44)"},"3":{"notice":"\u53f3\u5074(A\u7d44)"},"4":{"notice":"\u5de6\u5074(B\u7d44)"},"5":{"notice":"\u53f3\u5074(B\u7d44)"}},"cabinet":5,"enable":true,"id":"2chu","shop":"7037658","lora":false,"pad":true,"padlid":"twochu","padmid":"50Pad03","esp":true,"vipb":true},{"lable":"[\u897f\u9580\u4e8c\u5e97] \u592a\u9f13\u306e\u9054\u4eba","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50.0,true]],"note":[0.0,"\u5f69\u8679\u7248/\u56db\u66f2/\u53ef\u5238\u53f0","\u5f69\u8679\u7248/\u56db\u66f2/\u7121\u5238\u53f0",false,"one"],"cabinet_detail":{"0":{"notice":"\u5f8c\u5074"},"1":{"notice":"\u524d\u5074","block-ticket":true}},"cabinet":1,"enable":true,"id":"2tko","shop":"7037658","lora":false,"pad":true,"padlid":"twotko","padmid":"50Pad02","esp":true,"vipb":true},{"lable":"[\u897f\u9580\u4e8c\u5e97] Nostalgia","price":9.0,"discount":9.0,"downprice":"","mode":[[0,"\u55ae\u4eba",27.0,false]],"note":[0.0,"B1F",false,"one"],"cabinet_detail":{"0":{"notice":"\u5730\u4e0b\u5ba4"}},"cabinet":0,"enable":true,"id":"2nos","shop":"7037658","lora":true},{"lable":"[\u897f\u9580\u4e8c\u5e97] Project Diva Arcade","price":10,"discount":10,"downprice":"","mode":[[0,"3\u66f2",20.0,false]],"note":[0,"B1F",false,"one"],"cabinet_detail":{"0":{"notice":"Nos \u65c1"}},"cabinet":0,"enable":true,"id":"2diva","shop":"7037658","lora":false,"esp":true}],"payMid":null,"payLid":null,"payCid":null}''';
  String testGamelistSHILIN =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u58eb\u6797] maimai DX ","price":9.0,"discount":9.0,"downprice":"","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false],[1.0,"\u96d9\u4eba\u904a\u73a9",54.0,false]],"note":[1.0,"\u4e00\u56de\u5236\u81fa",true,"two"],"cabinet_detail":{"0":{"notice":"\u53f3\u81fa"},"1":{"notice":"\u5de6\u81fa"}},"cabinet":1.0,"enable":true,"id":"x40maidx","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] \u592a\u9f13\u306e\u9054\u4eba","price":10.0,"discount":9.0,"downprice":"","mode":[[0,"\u55ae\u4eba\u904a\u73a9",30.0,false]],"note":[0.0,"\u5f69\u8679\u7248 \u4e09\u66f2\u8a2d\u5b9a",false,"one"],"cabinet_detail":{"0":{"notice":"\u4e00\u6a13"}},"cabinet":0,"enable":true,"id":"x40tko","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] Dance Dance Revolution","price":10.0,"discount":9.0,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",30.0,false]],"note":[0.0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"\u4e2d\u4e8c\u5f8c\u65b9"}},"cabinet":0.0,"enable":true,"id":"x40ddr","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] SOUND VOLTEX","price":10.0,"discount":9.0,"downprice":"","mode":[[0,"Light/Standard",30.0,false],[1,"Blaster/Paradise",50.0,false]],"note":[0.0,"\u820a\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u53f0"},"1":{"notice":"\u53f3\u53f0"}},"cabinet":1,"enable":true,"id":"x40sdvx","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] CHUNITHM","price":9.0,"discount":9.0,"downprice":"","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false]],"note":[2.0,"\u4e00\u56de\u9650",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"}},"cabinet":1.0,"enable":true,"id":"x40chu","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] WACCA","price":10.0,"discount":10.0,"downprice":"","mode":[[0,"\u4e00\u9053",20.0,false]],"note":[1.0,"\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u53f0"},"1":{"notice":"\u53f3\u53f0"}},"cabinet":1,"enable":true,"id":"x40wac","shop":"7037657","lora":false,"vipb":false}],"payMid":null,"payLid":null,"payCid":null}''';
}
