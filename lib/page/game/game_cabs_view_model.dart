import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/repository/repository.dart';

class GameCabsViewModel extends BaseViewModel {
  final repo = Repository();
  late String storeName;

  Future<String?> getStoreName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('store_name');
  }

  Future<GameList?> getGamelist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return null;

      late final GameList gamelist;
      await EasyLoading.show();

      storeName = await getStoreName() ?? '';
      if (!kDebugMode || isForceFetch) {
        gamelist = await repo.getGameList(storeId: sid);
      } else {
        if (sid == '7037656') {
          gamelist = GameList.fromJson(jsonDecode(testGamelistWULIN1));
        }
        // if (sid == '7037657') {
        //   gamelist = GameList.fromJson(jsonDecode(testGamelistSHILIN));
        // }
        if (sid == '7037658') {
          gamelist = GameList.fromJson(jsonDecode(testGamelistWULIN2));
        }
      }
      return gamelist;
    } catch (e) {
      log('', error: '$e', name: 'getGamelist');
      return null;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  String testGamelistWULIN1 =
      '''{"message":"done","code":200,"machinelist":[{"lable":"maimaiDX","price":9.0,"discount":9.0,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[1,"\u9762\u76f8\u5927\u9580\u5de6\u5074","\u9762\u76f8\u5927\u9580\u53f3\u5074",false,"twor"],"cabinet_detail":{"0":{"notice":"\u53f3 (\u820a\u6846\u6309\u9375)"},"1":{"notice":"\u5de6 (\u76f4\u64ad/DX\u9375)"},"2":{"notice":"\u5de6\u5f8c (DX\u6846\u6309\u9375)"}},"cabinet":2,"enable":true,"id":"mmdx","shop":"7037656","lora":false,"pad":true,"padlid":"mmdx","padmid":"50Pad01","esp":true},{"lable":"DanceDanceRevolution","price":9,"discount":9,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"ddr","shop":"7037656","lora":false,"esp":true,"padlid":"ddr","padmid":"50Pad05","pad":true},{"lable":"GrooveCoaster","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"4 Max",false,"one"],"cabinet_detail":{"0":{"notice":"DDR \u65c1"}},"cabinet":0.0,"enable":true,"id":"gc","shop":"7037656","lora":true},{"lable":"pop'n music","price":9,"discount":9,"downprice":[25.0,1.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true]],"note":[0,"pop\u2019n music UniLab",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0,"enable":true,"id":"pop","shop":"7037656","lora":true,"pad":true,"padlid":"pop","padmid":"50Pad05"},{"lable":"Jubeat","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"Jubeat festo",false,"one"],"cabinet_detail":{"0":{"notice":"WACCA \u65c1"}},"cabinet":0,"enable":true,"id":"ju","shop":"7037656","lora":true},{"lable":"SDVX Valkyrie Model","price":9,"discount":8.5,"downprice":[1,34,43,51],"mode":[[0,"Light/Arena/Mega",34.0,true],[1,"Standard \uff08\u62632\u5238\uff09",43.0,true],[2,"Blaster/Premium (\u62632\u5238)",51.0,true]],"note":[1,"\u9760\u5f8c","\u9760\u524d",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"},"2":{"notice":"(\u53f3\u53f0\u5f8c)"},"3":{"notice":"(\u5de6\u53f0\u5f8c)"}},"cabinet":3,"enable":true,"id":"nvsv","shop":"7037656","lora":false,"pad":true,"padlid":"nvsv","padmid":"50Pad04","esp":true},{"lable":"WACCA","price":10.0,"discount":10.0,"downprice":null,"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[0.0,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"Jubeat \u65c1"}},"cabinet":0,"enable":true,"id":"wac","shop":"7037656","lora":false,"esp":true},{"lable":"Beatmania IIDX LM","price":9,"discount":8,"downprice":[1,34,51],"mode":[[0,"Standard",34.0,true],[1,"P-Free ",51.0,true]],"note":[1,"\u4e00\u56de\u5236",false,"one"],"cabinet_detail":{"0":{"notice":"mai2\u865f\u65c1"}},"cabinet":0,"enable":true,"id":"iidx","shop":"7037656","lora":false,"esp":true}],"payMid":null,"payLid":null,"payCid":null}''';
  String testGamelistWULIN2 =
      '''{"message":"done","code":200,"machinelist":[{"lable":"maimaiDX","price":9,"discount":9,"downprice":[25,1,2],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[0,"1F/\u9032\u9580\u53f3\u5074","1F/\u9032\u9580\u5de6\u524d",false,"one"],"cabinet_detail":{"0":{"notice":"\u53f3 (\u76f4\u64ad/DX\u9375)"},"1":{"notice":"\u5de6 (DX\u6309\u9375)"}},"cabinet":1,"enable":true,"id":"2mmdx","shop":"7037658","lora":false,"pad":true,"padlid":"twommdx","padmid":"50Pad02","esp":true},{"lable":"CHUNITHM","price":9,"discount":9,"downprice":[25,1],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true]],"note":[3,"A\u7d44/\u80cc\u5c0d\u6a13\u68af","B\u7d44/\u9762\u5c0d\u6a13\u68af",false,"four"],"cabinet_detail":{"0":{"notice":"\u5de6\u5074(A\u7d44)"},"1":{"notice":"\u5de6\u4e2d(A\u7d44)"},"2":{"notice":"\u53f3\u4e2d(A\u7d44)"},"3":{"notice":"\u53f3\u5074(A\u7d44)"},"4":{"notice":"\u5de6\u5074(B\u7d44)"},"5":{"notice":"\u53f3\u5074(B\u7d44)"}},"cabinet":5,"enable":true,"id":"2chu","shop":"7037658","lora":false,"pad":true,"padlid":"twochu","padmid":"50Pad03","esp":true},{"lable":"\u592a\u9f13\u306e\u9054\u4eba","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9(\u62632\u5238)",50.0,true]],"note":[0.0,"\u5f69\u8679\u7248/\u56db\u66f2/\u53ef\u5238\u53f0","\u5f69\u8679\u7248/\u56db\u66f2/\u7121\u5238\u53f0",false,"one"],"cabinet_detail":{"0":{"notice":"\u5f8c\u5074"},"1":{"notice":"\u524d\u5074","block-ticket":true}},"cabinet":1,"enable":true,"id":"2tko","shop":"7037658","lora":false,"pad":true,"padlid":"twotko","padmid":"50Pad02","esp":true},{"lable":"Nostalgia","price":9.0,"discount":9.0,"downprice":"","mode":[[0,"\u55ae\u4eba",27.0,false]],"note":[0.0,"B1F",false,"one"],"cabinet_detail":{"0":{"notice":"\u5730\u4e0b\u5ba4"}},"cabinet":0,"enable":true,"id":"2nos","shop":"7037658","lora":true},{"lable":"Project Diva Arcade","price":10,"discount":10,"downprice":"","mode":[[0,"3\u66f2",20.0,false]],"note":[0,"B1F",false,"one"],"cabinet_detail":{"0":{"notice":"Nos \u65c1"}},"cabinet":0,"enable":true,"id":"2diva","shop":"7037658","lora":false,"esp":true}],"payMid":null,"payLid":null,"payCid":null}''';
}
