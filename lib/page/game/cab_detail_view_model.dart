import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/repository/repository.dart';

class CabDatailViewModel extends BaseViewModel {
  final repo = Repository();
  final isForce = GlobalSingleton.instance.isOnline;
  CabinetModel? cabinetModel;
  BasicResponse? response;
  int lineupCount = -1;

  Future<bool> getSelGame(String machineId, {int debugFlag = 200}) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return false;

      if (!kDebugMode || isForce) {
        cabinetModel = await repo.selGame(machineId);
      } else {
        cabinetModel = CabinetModel.fromJson(jsonDecode(testSelGame(machineId)));
      }
      if (cabinetModel!.pad) await getPadLineup(cabinetModel!);
      await EasyLoading.dismiss();
      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  Future<int> getPadLineup(CabinetModel model) async {
    if (!kDebugMode || isForce) {
      lineupCount = await repo.getPadLineup(model.padmid, model.padlid);
    } else {
      lineupCount = 0;
    }
    return lineupCount;
  }

  Future<bool> doInsert(
      {required bool isTicket,
      required String id,
      required int machineNum,
      required num mode,
      int debugFlag = 200}) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');
      if (!kDebugMode || isForce) {
        response = await repo.doInsert(isTicket, '$id/$sid$machineNum', mode);
      } else {
        response = BasicResponse.fromJson(jsonDecode(testResponse(code: debugFlag)));
      }
      await EasyLoading.dismiss();

      return true;
    } on Exception catch (_) {
      await EasyLoading.dismiss();

      return false;
    }
  }

  String testResponse({int code = 200}) => '''{"code":$code,"message":"smth"}''';
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
}
