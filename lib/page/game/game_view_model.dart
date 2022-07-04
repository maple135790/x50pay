import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

class GameViewModel extends BaseViewModel {
  final repo = Repository();
  StoreModel? stores;
  String? storeName;
  Gamelist? gamelist;
  UserModel? user;

  Future<bool> initStore({int debugFlag = 200, bool force = false}) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      stores ??= StoreModel.fromJson(jsonDecode(testStorelist));
      if (!kDebugMode || force) {
        user ??= await repo.getUser();
      } else {
        user = UserModel.fromJson(jsonDecode(testUser(code: debugFlag)));
      }
      GlobalSingleton.instance.user = user;
      await EasyLoading.dismiss();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> hasRecentStore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('store_id') != null || prefs.getString('store_name') != null;
  }

  Future<bool> getGamelist({bool force = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return false;

      if (!kDebugMode || force) {
        print('sidsidsidsid   $sid');
        gamelist = await repo.getGameList(storeId: sid);
        storeName = prefs.getString('store_name');
      } else {
        storeName = prefs.getString('store_name');
        if (sid == '37656') gamelist = Gamelist.fromJson(jsonDecode(testGamelistWULIN));
        if (sid == '37657') gamelist = Gamelist.fromJson(jsonDecode(testGamelistSHILIN));
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  String testUser({int code = 200}) =>
      '''{"message":"done","code":$code,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","email":"maple135790@gmail.com","uid":"938","point":18.0,"name":"\u9bd6\u7f36","ticketint":7,"phoneactive":true,"vip":true,"vipdate":{"\$date":1657660411780},"sid":"","sixn":"523964","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#"}''';

  String testStorelist =
      '''{"prefix":"70","storelist":[{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u6b66\u660c\u8857\u4e8c\u6bb5134\u865f1\u6a13","name":"\u897f\u9580\u5e97","sid":37656},{"address":"\u81fa\u5317\u5e02\u58eb\u6797\u5340\u5927\u5357\u8def48\u865f2\u6a13","name":"\u58eb\u6797\u5e97","sid":37657}]}''';
  String testGamelistWULIN =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u897f\u9580] CHUNITHM","price":9.0,"discount":9.0,"downprice":[25.0,1.0],"mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0,true]],"note":[3.0,"A\u7d44\u4e00\u56de",false,"four"],"cabinet_detail":{"0":{"notice":"\u6700\u5de6"},"1":{"notice":"\u4e2d\u5de6"},"2":{"notice":"\u4e2d\u53f3"},"3":{"notice":"\u6700\u53f3"}},"cabinet":3.0,"enable":true,"id":"chu","shop":"7037656","lora":true,"pad":true,"padlid":"chu","padmid":"50Pad04","qcounter":[0.0,0.0,0.0,0.0],"quic":true,"vipb":true},{"lable":"[\u897f\u9580] maimai DX","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0,true]],"note":[1.0,"\u4e00\u56de\u5236\u81fa","\u4e00\u56de\u5236\u81fa",false,"twor"],"cabinet_detail":{"0":{"notice":"\u53f3\u81fa"},"1":{"notice":"\u5de6\u81fa"},"2":{"notice":"\u5de6\u5f8c"}},"cabinet":2,"enable":true,"id":"mmdx","shop":"7037656","lora":true,"pad":true,"padlid":"mmdx","padmid":"50Pad01","vipb":true},{"lable":"[\u897f\u9580] SOUND VOLTEX","price":9.0,"discount":8.0,"downprice":"","mode":[[0,"Light",16.0,true],[1,"Standard",24.0,true],[2,"Premium Time",32.0,true],[3,"Blaster (\u666e\u6642\u8a08\u5169\u9053)",40.0,true]],"note":[1.0,"\u820a\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u81fa","price":[10.0,9.0,9.0,9.0],"discount":[10.0,8.0,8.0,8.0]},"1":{"notice":"\u53f3\u81fa","price":[10.0,9.0,9.0,9.0],"discount":[10.0,8.0,8.0,8.0]}},"cabinet":1,"enable":true,"id":"sdvx","shop":"7037656","lora":true,"vipb":true},{"lable":"[\u897f\u9580] WACCA","price":10.0,"discount":10.0,"downprice":null,"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[1.0,"\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u81fa"},"1":{"notice":"\u53f3\u81fa"}},"cabinet":1,"enable":true,"id":"wac","shop":"7037656","lora":false,"pad":true,"padlid":"wac","padmid":"50Pad02","vipb":false},{"lable":"[\u897f\u9580] \u592a\u9f13\u306e\u9054\u4eba","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0,true]],"note":[0.0,"\u5f69\u8679\u7248 \u56db\u66f2\u8a2d\u5b9a",false,"one"],"cabinet_detail":{"0":{"notice":"\u6c99\u767c\u65c1"}},"cabinet":0,"enable":true,"id":"tko","shop":"7037656","lora":true,"pad":true,"padlid":"tko","padmid":"50Pad02","vipb":true},{"lable":"[\u897f\u9580] DanceDanceRevolution","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0,true],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0,true]],"note":[0.0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0.0,"enable":true,"id":"ddr","shop":"7037656","lora":true,"vipb":true},{"lable":"[\u897f\u9580] GROOVE COASTER","price":10.0,"discount":10.0,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[0.0,"4 Max",false,"one"],"cabinet_detail":{"0":{"notice":"DDR \u65c1"}},"cabinet":0.0,"enable":true,"id":"gc","shop":"7037656","lora":true,"vipb":false},{"lable":"[\u897f\u9580] pop'n music","price":10.0,"discount":9.0,"downprice":[],"mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",30.0,false]],"note":[0.0,"pop\u2019n music \u89e3\u660e\u30ea\u30c9\u30eb\u30ba",false,"one"],"cabinet_detail":{"0":{"notice":"Jubeat \u65c1"}},"cabinet":0.0,"enable":true,"id":"pop","shop":"7037656","lora":true,"vipb":false},{"lable":"[\u897f\u9580] Jubeat","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0,true]],"note":[0.0,"Jubeat festo",false,"one"],"cabinet_detail":{"0":{"notice":"pop'n \u65c1"}},"cabinet":0,"enable":true,"id":"ju","shop":"7037656","lora":true,"vipb":true},{"lable":"[\u897f\u9580] SDVX - Valkyrie Model","price":9.0,"discount":8.0,"downprice":"","mode":[[0,"Light/Arena/Mega",36.0,false],[1,"Standard (\u8a08\u5169\u9053)",45.0,false],[2,"Blaster/Premium (\u8a08\u5169\u9053)",54.0,false]],"note":[1.0,"\u65b0\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"}},"cabinet":1,"enable":true,"id":"nvsv","shop":"7037656","lora":false,"pad":true,"padlid":"nvsv","padmid":"50Pad04","vipb":false}],"payMid":null,"payLid":null,"payCid":null}''';
  String testGamelistSHILIN =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u58eb\u6797] maimai DX ","price":9.0,"discount":9.0,"downprice":"","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false],[1.0,"\u96d9\u4eba\u904a\u73a9",54.0,false]],"note":[1.0,"\u4e00\u56de\u5236\u81fa",true,"two"],"cabinet_detail":{"0":{"notice":"\u53f3\u81fa"},"1":{"notice":"\u5de6\u81fa"}},"cabinet":1.0,"enable":true,"id":"x40maidx","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] \u592a\u9f13\u306e\u9054\u4eba","price":10.0,"discount":9.0,"downprice":"","mode":[[0,"\u55ae\u4eba\u904a\u73a9",30.0,false]],"note":[0.0,"\u5f69\u8679\u7248 \u4e09\u66f2\u8a2d\u5b9a",false,"one"],"cabinet_detail":{"0":{"notice":"\u4e00\u6a13"}},"cabinet":0,"enable":true,"id":"x40tko","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] Dance Dance Revolution","price":10.0,"discount":9.0,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",30.0,false]],"note":[0.0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"\u4e2d\u4e8c\u5f8c\u65b9"}},"cabinet":0.0,"enable":true,"id":"x40ddr","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] SOUND VOLTEX","price":10.0,"discount":9.0,"downprice":"","mode":[[0,"Light/Standard",30.0,false],[1,"Blaster/Paradise",50.0,false]],"note":[0.0,"\u820a\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u53f0"},"1":{"notice":"\u53f3\u53f0"}},"cabinet":1,"enable":true,"id":"x40sdvx","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] CHUNITHM","price":9.0,"discount":9.0,"downprice":"","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false]],"note":[2.0,"\u4e00\u56de\u9650",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"}},"cabinet":1.0,"enable":true,"id":"x40chu","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] WACCA","price":10.0,"discount":10.0,"downprice":"","mode":[[0,"\u4e00\u9053",20.0,false]],"note":[1.0,"\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u53f0"},"1":{"notice":"\u53f3\u53f0"}},"cabinet":1,"enable":true,"id":"x40wac","shop":"7037657","lora":false,"vipb":false}],"payMid":null,"payLid":null,"payCid":null}''';
}
