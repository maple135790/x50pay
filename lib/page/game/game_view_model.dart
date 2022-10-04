import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/repository/repository.dart';

class GameViewModel extends BaseViewModel {
  final repo = Repository();
  final isForce = GlobalSingleton.instance.isOnline;

  StoreModel? stores;
  String? storeName;
  Gamelist? gamelist;
  CabinetModel? cabinetModel;
  // UserModel? user;

  Future<bool> initStore({
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
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> hasRecentStore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('store_id') != null || prefs.getString('store_name') != null;
  }

  Future<bool> getGamelist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return false;

      if (!kDebugMode || isForce) {
        gamelist = await repo.getGameList(storeId: sid);
        storeName = prefs.getString('store_name');
      } else {
        storeName = prefs.getString('store_name');
        if (sid == '7037656') gamelist = Gamelist.fromJson(jsonDecode(testGamelistWULIN1));
        if (sid == '7037657') gamelist = Gamelist.fromJson(jsonDecode(testGamelistSHILIN));
        if (sid == '7037658') gamelist = Gamelist.fromJson(jsonDecode(testGamelistWULIN2));
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> getSelGame(String machineId, {int debugFlag = 200}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return false;

      if (!kDebugMode || isForce) {
        cabinetModel = await repo.selGame(machineId);
      } else {
        cabinetModel = CabinetModel.fromJson(jsonDecode(testSelGame(machineId)));
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  String testUser({int code = 200}) =>
      '''{"message":"done","code":$code,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","email":"maple135790@gmail.com","uid":"938","point":18.0,"name":"\u9bd6\u7f36","ticketint":7,"phoneactive":true,"vip":true,"vipdate":{"\$date":1657660411780},"sid":"","sixn":"523964","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#"}''';
  String testSelGame(String mid) {
    switch (mid) {
      case 'chu':
        return '''{"message":"done","code":200,"note":[3.0,"A\u7d44\u4e00\u56de",false,"four"],"cabinet":[{"num":1,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u6700\u5de6","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":2,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u4e2d\u5de6","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":3,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u4e2d\u53f3","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":4,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u6700\u53f3","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fc107116405953fe0a6fbcc","spic":"/static/live/chulive.png","surl":"'https://www.youtube.com/watch?v=UGgAfqRPmvU'","pad":true,"padmid":"50Pad04","padlid":"chu"}''';
      case 'mmdx':
        return '''{"message":"done","code":200,"note":[1.0,"\u4e00\u56de\u5236\u81fa","\u4e00\u56de\u5236\u81fa",false,"twor"],"cabinet":[{"num":1,"id":"mmdx","lable":"[\u897f\u9580] maimai DX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3\u81fa","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":2,"id":"mmdx","lable":"[\u897f\u9580] maimai DX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u81fa","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true},{"num":3,"id":"mmdx","lable":"[\u897f\u9580] maimai DX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u5f8c","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true}],"caboid":"5fcdce800004a524c8fadff9","spic":"/static/live/mailive.png","surl":"'https://www.youtube.com/watch?v=eKvQi3tbuDk'","pad":true,"padmid":"50Pad01","padlid":"mmdx"}''';
      case 'sdvx':
        return '''{"message":"done","code":200,"note":[1.0,"\u820a\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet":[{"num":1,"id":"sdvx","lable":"[\u897f\u9580] SOUND VOLTEX","mode":[[0,"Light",20.0],[1,"Standard",24.0],[2,"Premium Time",32.0],[3,"Blaster (\u666e\u6642\u8a08\u5169\u9053)",40.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u81fa","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true},{"num":2,"id":"sdvx","lable":"[\u897f\u9580] SOUND VOLTEX","mode":[[0,"Light",20.0],[1,"Standard",24.0],[2,"Premium Time",32.0],[3,"Blaster (\u666e\u6642\u8a08\u5169\u9053)",40.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3\u81fa","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf0f0004a524c8fadffa","pad":false,"padmid":"","padlid":""}''';
      case 'wac':
        return '''{"message":"done","code":200,"note":[1.0,"\u4e00\u56de\u5236",false,"two"],"cabinet":[{"num":1,"id":"wac","lable":"[\u897f\u9580] WACCA","mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0]],"card":false,"bool":false,"vipbool":false,"notice":"\u5de6\u81fa","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":2,"id":"wac","lable":"[\u897f\u9580] WACCA","mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0]],"card":false,"bool":false,"vipbool":false,"notice":"\u53f3\u81fa","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf270004a524c8fadffb","pad":true,"padmid":"50Pad02","padlid":"wac"}''';
      case 'tko':
        return '''{"message":"done","code":200,"note":[0.0,"\u5f69\u8679\u7248 \u56db\u66f2\u8a2d\u5b9a",false,"one"],"cabinet":[{"num":1,"id":"tko","lable":"[\u897f\u9580] \u592a\u9f13\u306e\u9054\u4eba","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u6c99\u767c\u65c1","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":false}],"caboid":"5fcdcf3e0004a524c8fadffc","pad":true,"padmid":"50Pad02","padlid":"tko"}''';
      case 'ddr':
        return '''{"message":"done","code":200,"note":[0.0,"A20 Plus",false,"one"],"cabinet":[{"num":1,"id":"ddr","lable":"[\u897f\u9580] DanceDanceRevolution","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"GC \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf4d0004a524c8fadffd","pad":false,"padmid":"","padlid":""}''';
      case 'gc':
        return '''{"message":"done","code":200,"note":[0.0,"4 Max",false,"one"],"cabinet":[{"num":1,"id":"gc","lable":"[\u897f\u9580] GROOVE COASTER","mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0]],"card":false,"bool":false,"vipbool":false,"notice":"DDR \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf630004a524c8fadffe","pad":false,"padmid":"","padlid":""}''';
      case 'pop':
        return '''{"message":"done","code":200,"note":[0.0,"pop\u2019n music \u89e3\u660e\u30ea\u30c9\u30eb\u30ba",false,"one"],"cabinet":[{"num":1,"id":"pop","lable":"[\u897f\u9580] pop'n music","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",30.0]],"card":false,"bool":false,"vipbool":false,"notice":"Jubeat \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf6e0004a524c8fadfff","pad":false,"padmid":"","padlid":""}''';
      case 'ju':
        return '''{"message":"done","code":200,"note":[0.0,"Jubeat festo",false,"one"],"cabinet":[{"num":1,"id":"ju","lable":"[\u897f\u9580] Jubeat","mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0]],"card":false,"bool":true,"vipbool":true,"notice":"pop'n \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf800004a524c8fae000","pad":false,"padmid":"","padlid":""}''';
      case 'nvsv':
        return '''{"message":"done","code":200,"note":[1.0,"\u65b0\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet":[{"num":1,"id":"nvsv","lable":"[\u897f\u9580] SDVX - Valkyrie Model","mode":[[0,"Light/Arena/Mega",36.0],[1,"Standard (\u8a08\u5169\u9053)",45.0],[2,"Blaster/Premium (\u8a08\u5169\u9053)",54.0]],"card":false,"bool":false,"vipbool":false,"notice":"(\u5de6\u53f0)","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":2,"id":"nvsv","lable":"[\u897f\u9580] SDVX - Valkyrie Model","mode":[[0,"Light/Arena/Mega",36.0],[1,"Standard (\u8a08\u5169\u9053)",45.0],[2,"Blaster/Premium (\u8a08\u5169\u9053)",54.0]],"card":false,"bool":false,"vipbool":false,"notice":"(\u53f3\u53f0)","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"60543eb21145222624eeb860","spic":"/static/live/sdvxlive.png","surl":"'https://www.youtube.com/watch?v=GBsA8m-VkjI'","pad":true,"padmid":"50Pad04","padlid":"nvsv"}''';
      default:
        return '';
    }
  }

  String testStorelist =
      '''{"prefix":"70","storelist":[{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u6b66\u660c\u8857\u4e8c\u6bb5134\u865f1\u6a13","name":"\u897f\u9580\u4e00\u5e97","sid":37656},{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u5eb7\u5b9a\u8def10\u865f1\u6a13","name":"\u897f\u9580\u4e8c\u5e97","sid":37658},{"address":"\u81fa\u5317\u5e02\u58eb\u6797\u5340\u5927\u5357\u8def48\u865f2\u6a13","name":"\u58eb\u6797\u5e97","sid":37657}]}''';
  String testGamelistWULIN1 =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u897f\u9580\u4e00\u5e97] CHUNITHM","price":9.0,"discount":9.0,"downprice":[25.0,1.0],"mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false]],"note":[3.0,"A\u7d44\u4e00\u56de",false,"four"],"cabinet_detail":{"0":{"notice":"\u6700\u5de6"},"1":{"notice":"\u4e2d\u5de6"},"2":{"notice":"\u4e2d\u53f3"},"3":{"notice":"\u6700\u53f3"}},"cabinet":3.0,"enable":true,"id":"chu","shop":"7037656","lora":true,"pad":true,"padlid":"chu","padmid":"50Pad04","qcounter":[0.0,0.0,0.0,0.0],"quic":true},{"lable":"[\u897f\u9580\u4e00\u5e97] maimai DX","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",27.0,false],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",54.0,false]],"note":[1.0,"\u4e00\u56de\u5236\u81fa","\u4e00\u56de\u5236\u81fa",false,"twor"],"cabinet_detail":{"0":{"notice":"\u53f3\u81fa"},"1":{"notice":"\u5de6\u81fa"},"2":{"notice":"\u5de6\u5f8c"}},"cabinet":2,"enable":true,"id":"mmdx","shop":"7037656","lora":true,"pad":true,"padlid":"mmdx","padmid":"50Pad01"},{"lable":"[\u897f\u9580\u4e00\u5e97] SOUND VOLTEX","price":9.0,"discount":8.0,"downprice":"","mode":[[0,"Light",18.0,false],[1,"Standard",27.0,false],[2,"Premium Time",36.0,false],[3,"Blaster (\u666e\u6642\u8a08\u5169\u9053)",45.0,false]],"note":[1.0,"\u820a\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u81fa","price":[10.0,9.0,9.0,9.0],"discount":[10.0,8.0,8.0,8.0]},"1":{"notice":"\u53f3\u81fa","price":[10.0,9.0,9.0,9.0],"discount":[10.0,8.0,8.0,8.0]}},"cabinet":1,"enable":true,"id":"sdvx","shop":"7037656","lora":true},{"lable":"[\u897f\u9580\u4e00\u5e97] DanceDanceRevolution","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",27.0,false],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",54.0,false]],"note":[0.0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"GC \u65c1"}},"cabinet":0.0,"enable":true,"id":"ddr","shop":"7037656","lora":true},{"lable":"[\u897f\u9580\u4e00\u5e97] GROOVE COASTER","price":10.0,"discount":10.0,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[0.0,"4 Max",false,"one"],"cabinet_detail":{"0":{"notice":"DDR \u65c1"}},"cabinet":0.0,"enable":true,"id":"gc","shop":"7037656","lora":true},{"lable":"[\u897f\u9580\u4e00\u5e97] pop'n music","price":9.0,"discount":9.0,"downprice":[],"mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false]],"note":[0.0,"pop\u2019n music \u89e3\u660e\u30ea\u30c9\u30eb\u30ba",false,"one"],"cabinet_detail":{"0":{"notice":"Jubeat \u65c1"}},"cabinet":0.0,"enable":true,"id":"pop","shop":"7037656","lora":true},{"lable":"[\u897f\u9580\u4e00\u5e97] Jubeat","price":10.0,"discount":9.5,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[0.0,"Jubeat festo",false,"one"],"cabinet_detail":{"0":{"notice":"pop'n \u65c1"}},"cabinet":0,"enable":true,"id":"ju","shop":"7037656","lora":true},{"lable":"[\u897f\u9580\u4e00\u5e97] SDVX - Valkyrie Model","price":9.0,"discount":8.5,"downprice":[1.0,34.0,43.0,51.0],"mode":[[0,"Light/Arena/Mega",36.0,false],[1,"Standard (\u8a08\u5169\u9053)",45.0,false],[2,"Blaster/Premium (\u8a08\u5169\u9053)",54.0,false]],"note":[1.0,"\u65b0\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"}},"cabinet":1,"enable":true,"id":"nvsv","shop":"7037656","lora":false,"pad":true,"padlid":"nvsv","padmid":"50Pad04"},{"lable":"[\u897f\u9580\u4e00\u5e97] WACCA","price":10.0,"discount":10.0,"downprice":null,"mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0,false]],"note":[1.0,"\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u81fa"},"1":{"notice":"\u53f3\u81fa"}},"cabinet":1,"enable":true,"id":"wac","shop":"7037656","lora":false}],"payMid":null,"payLid":null,"payCid":null}''';
  String testGamelistWULIN2 =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u897f\u9580\u4e8c\u5e97] maimai DX","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",27.0,false],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",54.0,false]],"note":[0.0,"1F/\u4e00\u56de\u5236\u81fa",false,"one"],"cabinet_detail":{"0":{"notice":"\u53f3\u5074\u81fa"}},"cabinet":0,"enable":true,"id":"2mmdx","shop":"7037658","lora":true,"pad":true,"padlid":"twommdx","padmid":"50Pad02"},{"lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","price":9.0,"discount":9.0,"downprice":[25.0,1.0],"mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false]],"note":[0.0,"B1/A\u7d44",false,"one"],"cabinet_detail":{"0":{"notice":"\u53f3\u6aaf"}},"cabinet":0.0,"enable":true,"id":"2chu","shop":"7037658","lora":true},{"lable":"[\u897f\u9580\u4e8c\u5e97] \u592a\u9f13\u306e\u9054\u4eba","price":9.0,"discount":9.0,"downprice":[25.0,1.0,2.0],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",27.0,false],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",54.0,false]],"note":[0.0,"\u5f69\u8679\u7248/\u56db\u66f2/\u53ef\u5238\u53f0","\u5f69\u8679\u7248/\u56db\u66f2/\u7121\u5238\u53f0",false,"one"],"cabinet_detail":{"0":{"notice":"\u5f8c\u5074"},"1":{"notice":"\u524d\u5074","block-ticket":true}},"cabinet":1,"enable":true,"id":"2tko","shop":"7037658","lora":true,"pad":true,"padlid":"twotko","padmid":"50Pad02"},{"lable":"[\u897f\u9580\u4e8c\u5e97] DrumMania","price":9.0,"discount":9.0,"downprice":"","mode":[[0,"Light",27.0,false],[1,"Standard",36.0,false]],"note":[0.0,"B1F",false,"one"],"cabinet_detail":{"0":{"notice":"\u767d\u6846\u9ad4"}},"cabinet":0,"enable":true,"id":"2dm","shop":"7037658","lora":true},{"lable":"[\u897f\u9580\u4e8c\u5e97] Nostalgia","price":9.0,"discount":9.0,"downprice":"","mode":[[0,"\u55ae\u4eba",27.0,false]],"note":[0.0,"B1F",false,"one"],"cabinet_detail":{"0":{"notice":"DM\u80cc\u5f8c"}},"cabinet":0,"enable":true,"id":"2nos","shop":"7037658","lora":true},{"lable":"[\u897f\u9580\u4e8c\u5e97] BomberGirl","price":9.0,"discount":9.0,"downprice":"","mode":[[0,"\u55ae\u4eba",27.0,false]],"note":[0.0,"B1F",false,"one"],"cabinet_detail":{"0":{"notice":"\u4e2d\u4e8c\u65c1"}},"cabinet":0,"enable":true,"id":"2bom","shop":"7037658","lora":true}],"payMid":null,"payLid":null,"payCid":null}''';
  String testGamelistSHILIN =
      '''{"message":"done","code":200,"machinelist":[{"lable":"[\u58eb\u6797] maimai DX ","price":9.0,"discount":9.0,"downprice":"","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false],[1.0,"\u96d9\u4eba\u904a\u73a9",54.0,false]],"note":[1.0,"\u4e00\u56de\u5236\u81fa",true,"two"],"cabinet_detail":{"0":{"notice":"\u53f3\u81fa"},"1":{"notice":"\u5de6\u81fa"}},"cabinet":1.0,"enable":true,"id":"x40maidx","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] \u592a\u9f13\u306e\u9054\u4eba","price":10.0,"discount":9.0,"downprice":"","mode":[[0,"\u55ae\u4eba\u904a\u73a9",30.0,false]],"note":[0.0,"\u5f69\u8679\u7248 \u4e09\u66f2\u8a2d\u5b9a",false,"one"],"cabinet_detail":{"0":{"notice":"\u4e00\u6a13"}},"cabinet":0,"enable":true,"id":"x40tko","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] Dance Dance Revolution","price":10.0,"discount":9.0,"downprice":[],"mode":[[0,"\u55ae\u4eba\u904a\u73a9",30.0,false]],"note":[0.0,"A20 Plus",false,"one"],"cabinet_detail":{"0":{"notice":"\u4e2d\u4e8c\u5f8c\u65b9"}},"cabinet":0.0,"enable":true,"id":"x40ddr","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] SOUND VOLTEX","price":10.0,"discount":9.0,"downprice":"","mode":[[0,"Light/Standard",30.0,false],[1,"Blaster/Paradise",50.0,false]],"note":[0.0,"\u820a\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u53f0"},"1":{"notice":"\u53f3\u53f0"}},"cabinet":1,"enable":true,"id":"x40sdvx","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] CHUNITHM","price":9.0,"discount":9.0,"downprice":"","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0,false]],"note":[2.0,"\u4e00\u56de\u9650",false,"two"],"cabinet_detail":{"0":{"notice":"(\u5de6\u53f0)"},"1":{"notice":"(\u53f3\u53f0)"}},"cabinet":1.0,"enable":true,"id":"x40chu","shop":"7037657","lora":false,"vipb":false},{"lable":"[\u58eb\u6797] WACCA","price":10.0,"discount":10.0,"downprice":"","mode":[[0,"\u4e00\u9053",20.0,false]],"note":[1.0,"\u4e00\u56de\u5236",false,"two"],"cabinet_detail":{"0":{"notice":"\u5de6\u53f0"},"1":{"notice":"\u53f3\u53f0"}},"cabinet":1,"enable":true,"id":"x40wac","shop":"7037657","lora":false,"vipb":false}],"payMid":null,"payLid":null,"payCid":null}''';
}
