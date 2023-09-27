import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/repository/repository.dart';

class CabDatailViewModel extends BaseViewModel {
  final Repository repository;
  CabinetModel? cabinetModel;
  BasicResponse? response;
  int lineupCount = -1;

  CabDatailViewModel({required this.repository});

  /// 取得遊戲機台資料
  Future<bool> getSelGameCab(String machineId) async {
    try {
      log('machineId: $machineId', name: 'getSelGame');
      showLoading();
      await Future.delayed(const Duration(milliseconds: 100));
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return false;

      // if (!kDebugMode || isForceFetch) {
      //   cabinetModel = await repository.selGame(machineId);
      // } else {
      //   cabinetModel =
      //       CabinetModel.fromJson(jsonDecode(testSelGame(machineId)));
      // }
      cabinetModel = await repository.selGame(machineId);
      if (cabinetModel!.pad) {
        lineupCount =
            await getPadLineup(cabinetModel!.padmid, cabinetModel!.padlid);
      }
      return true;
    } catch (e) {
      log('', error: '$e', name: 'getSelGameCab');
      return false;
    } finally {
      dismissLoading();
    }
  }

  /// 確定平板排隊
  Future<void> confirmPadCheck(String padmid, String padlid) async {
    if (!kDebugMode || isForceFetch) {
      await repository.confirmPadCheck(padmid, padlid);
    }
    return;
  }

  /// 取得排隊人數
  Future<int> getPadLineup(String padmid, String padlid) async {
    int count = -1;
    if (!kDebugMode || isForceFetch) {
      count = await repository.getPadLineup(padmid, padlid);
    } else {
      count = 0;
    }
    return count;
  }

  String testSelGame(String mid) {
    switch (mid) {
      case '2tko':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"\u5f69\u8679\u7248/\u56db\u66f2/\u53ef\u5238\u53f0","\u5f69\u8679\u7248/\u56db\u66f2/\u7121\u5238\u53f0",false,"one"],"cabinet":[{"num":1,"id":"2tko","lable":"[\u897f\u9580\u4e8c\u5e97] \u592a\u9f13\u306e\u9054\u4eba","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u5f8c\u5074","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":true},{"num":2,"id":"2tko","lable":"[\u897f\u9580\u4e8c\u5e97] \u592a\u9f13\u306e\u9054\u4eba","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u524d\u5074","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"632906fa1eb45d31f0a11861","pad":true,"padmid":"50Pad02","padlid":"twotko"}''';
      case '2mmdx':
        return '''{"message":"done","code":200,"re":[["05-27 13:00 ~ 16:00","maiDX-\u2606\u897f\u9580\u4e8c\u5e97\u2605"]],"note":[0,"1F/\u9032\u9580\u53f3\u5074","1F/\u9032\u9580\u5de6\u524d",false,"one"],"cabinet":[{"num":1,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3 (DX\u6846\u6309\u9375)","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true},{"num":2,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6 (DX\u6846\u6309\u9375)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true}],"caboid":"632904081eb45d31f0a1185c","pad":true,"padmid":"50Pad02","padlid":"twommdx"}''';
      case '2dm':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"B1F",false,"one"],"cabinet":[{"num":1,"id":"2dm","lable":"[\u897f\u9580\u4e8c\u5e97] DrumMania","mode":[[0,"Light",27.0],[1,"Standard",36.0]],"card":false,"bool":false,"vipbool":false,"notice":"\u767d\u6846\u9ad4","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"6329082f1eb45d31f0a11863","pad":true,"padmid":"50Pad03","padlid":"twodm"}''';
      case '2nos':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"B1F",false,"one"],"cabinet":[{"num":1,"id":"2nos","lable":"[\u897f\u9580\u4e8c\u5e97] Nostalgia","mode":[[0,"\u55ae\u4eba",27.0]],"card":false,"bool":false,"vipbool":false,"notice":"DM\u80cc\u5f8c","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"632908c21eb45d31f0a11864","pad":false,"padmid":"","padlid":""}''';
      case '2chu':
        return '''{"message":"done","code":200,"re":[],"note":[3,"A\u7d44/\u80cc\u5c0d\u6a13\u68af","B\u7d44/\u9762\u5c0d\u6a13\u68af",false,"four"],"cabinet":[{"num":1,"id":"2chu","lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u5074(A\u7d44)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true},{"num":2,"id":"2chu","lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u4e2d(A\u7d44)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true},{"num":3,"id":"2chu","lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3\u4e2d(A\u7d44)","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":4,"id":"2chu","lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3\u5074(A\u7d44)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true},{"num":5,"id":"2chu","lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u5074(B\u7d44)","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":6,"id":"2chu","lable":"[\u897f\u9580\u4e8c\u5e97] CHUNITHM","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3\u5074(B\u7d44)","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"632905b31eb45d31f0a1185d","pad":true,"padmid":"50Pad03","padlid":"twochu"}''';
      case 'chu':
        return '''{"message":"done","code":200,"note":[3.0,"A\u7d44\u4e00\u56de",false,"four"],"cabinet":[{"num":1,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u6700\u5de6","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":2,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u4e2d\u5de6","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":3,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u4e2d\u53f3","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false},{"num":4,"id":"chu","lable":"[\u897f\u9580] CHUNITHM","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",25.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u6700\u53f3","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fc107116405953fe0a6fbcc","spic":"/static/live/chulive.png","surl":"'https://www.youtube.com/watch?v=UGgAfqRPmvU'","pad":true,"padmid":"50Pad04","padlid":"chu"}''';
      case 'mmdx':
        return '''{"message":"done","code":200,"re":[["08-12 09:00 ~ 13:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-12 13:00 ~ 18:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-12 14:00 ~ 18:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-13 12:00 ~ 19:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-14 11:00 ~ 16:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-14 13:00 ~ 19:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-15 11:30 ~ 17:30","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-15 12:30 ~ 16:30","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-15 13:00 ~ 19:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-16 13:00 ~ 18:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-16 17:00 ~ 22:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-17 13:00 ~ 20:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"],["08-18 16:00 ~ 19:00","maiDX-\u2605\u897f\u9580\u4e00\u5e97\u2606"]],"note":[1,"\u9762\u76f8\u5927\u9580\u5de6\u5074","\u9762\u76f8\u5927\u9580\u53f3\u5074",false,"twor"],"cabinet":[{"num":1,"id":"mmdx","lable":"[\u897f\u9580\u4e00\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3 (\u820a\u6846\u6309\u9375)","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true},{"num":2,"id":"mmdx","lable":"[\u897f\u9580\u4e00\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6 (\u76f4\u64ad/DX\u9375)","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true},{"num":3,"id":"mmdx","lable":"[\u897f\u9580\u4e00\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u5f8c (DX\u6846\u6309\u9375)","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true}],"caboid":"5fcdce800004a524c8fadff9","spic":["/static/live/mailive.png"],"surl":["'https://www.youtube.com/watch?v=T7nEKhcMiuw'"],"pad":true,"padmid":"50Pad01","padlid":"mmdx"}''';
      case 'sdvx':
        return '''{"message":"done","code":200,"note":[1.0,"\u820a\u6846\u9ad4\u4e00\u56de\u5236",false,"two"],"cabinet":[{"num":1,"id":"sdvx","lable":"[\u897f\u9580] SOUND VOLTEX","mode":[[0,"Light",20.0],[1,"Standard",24.0],[2,"Premium Time",32.0],[3,"Blaster (\u666e\u6642\u8a08\u5169\u9053)",40.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6\u81fa","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true},{"num":2,"id":"sdvx","lable":"[\u897f\u9580] SOUND VOLTEX","mode":[[0,"Light",20.0],[1,"Standard",24.0],[2,"Premium Time",32.0],[3,"Blaster (\u666e\u6642\u8a08\u5169\u9053)",40.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3\u81fa","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf0f0004a524c8fadffa","pad":false,"padmid":"","padlid":""}''';
      case 'wac':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"\u4e00\u56de\u5236",false,"one"],"cabinet":[{"num":1,"id":"wac","lable":"[\u897f\u9580\u4e00\u5e97] WACCA","mode":[[0,"\u55ae\u4eba\u904a\u73a9",20.0]],"card":false,"bool":false,"vipbool":false,"notice":"Ju\u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"63372070864e680b10814f92","pad":false,"padmid":"","padlid":""}''';
      case 'tko':
        return '''{"message":"done","code":200,"note":[0.0,"\u5f69\u8679\u7248 \u56db\u66f2\u8a2d\u5b9a",false,"one"],"cabinet":[{"num":1,"id":"tko","lable":"[\u897f\u9580] \u592a\u9f13\u306e\u9054\u4eba","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9 (\u8a08\u5169\u9053)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u6c99\u767c\u65c1","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":false}],"caboid":"5fcdcf3e0004a524c8fadffc","pad":true,"padmid":"50Pad02","padlid":"tko"}''';
      case 'ddr':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"A20 Plus",false,"one"],"cabinet":[{"num":1,"id":"ddr","lable":"[\u897f\u9580\u4e00\u5e97] DanceDanceRevolution","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25.0],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50.0]],"card":false,"bool":true,"vipbool":true,"notice":"GC \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf4d0004a524c8fadffd","pad":false,"padmid":"","padlid":""}''';
      case 'gc':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"4 Max",false,"one"],"cabinet":[{"num":1,"id":"gc","lable":"[\u897f\u9580\u4e00\u5e97] GrooveCoaster","mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0]],"card":false,"bool":true,"vipbool":true,"notice":"DDR \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf630004a524c8fadffe","pad":false,"padmid":"","padlid":""}''';
      case 'pop':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"pop\u2019n music \u89e3\u660e\u30ea\u30c9\u30eb\u30ba",false,"one"],"cabinet":[{"num":1,"id":"pop","lable":"[\u897f\u9580\u4e00\u5e97] pop'n music","mode":[[0.0,"\u55ae\u4eba\u904a\u73a9",27.0]],"card":false,"bool":false,"vipbool":false,"notice":"Jubeat \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf6e0004a524c8fadfff","pad":false,"padmid":"","padlid":""}''';
      case 'ju':
        return '''{"message":"done","code":200,"re":[],"note":[0.0,"Jubeat festo",false,"one"],"cabinet":[{"num":1,"id":"ju","lable":"[\u897f\u9580\u4e00\u5e97] Jubeat","mode":[[0,"\u55ae\u4eba\u904a\u73a9",19.0]],"card":false,"bool":true,"vipbool":true,"notice":"pop'n \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"5fcdcf800004a524c8fae000","pad":false,"padmid":"","padlid":""}''';
      case 'nvsv':
        return '''{"message":"done","code":200,"re":[],"note":[1,"\u9760\u5f8c","\u9760\u524d",false,"two"],"cabinet":[{"num":1,"id":"nvsv","lable":"[\u897f\u9580\u4e00\u5e97] SDVX Valkyrie Model","mode":[[0,"Light/Arena/Mega",34],[1,"Standard (\u8a08\u5169\u9053)",43],[2,"Blaster/Premium (\u8a08\u5169\u9053)",51]],"card":false,"bool":true,"vipbool":true,"notice":"(\u5de6\u53f0)","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":true},{"num":2,"id":"nvsv","lable":"[\u897f\u9580\u4e00\u5e97] SDVX Valkyrie Model","mode":[[0,"Light/Arena/Mega",34],[1,"Standard (\u8a08\u5169\u9053)",43],[2,"Blaster/Premium (\u8a08\u5169\u9053)",51]],"card":false,"bool":true,"vipbool":true,"notice":"(\u53f3\u53f0)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true},{"num":3,"id":"nvsv","lable":"[\u897f\u9580\u4e00\u5e97] SDVX Valkyrie Model","mode":[[0,"Light/Arena/Mega",34],[1,"Standard (\u8a08\u5169\u9053)",43],[2,"Blaster/Premium (\u8a08\u5169\u9053)",51]],"card":false,"bool":true,"vipbool":true,"notice":"(\u53f3\u53f0\u5f8c)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":false},{"num":4,"id":"nvsv","lable":"[\u897f\u9580\u4e00\u5e97] SDVX Valkyrie Model","mode":[[0,"Light/Arena/Mega",34],[1,"Standard (\u8a08\u5169\u9053)",43],[2,"Blaster/Premium (\u8a08\u5169\u9053)",51]],"card":false,"bool":true,"vipbool":true,"notice":"(\u5de6\u53f0\u5f8c)","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"60543eb21145222624eeb860","spic":["/static/live/sdvxlive.png"],"surl":["'https://www.youtube.com/watch?v=2EreKn7UKgg'"],"pad":true,"padmid":"50Pad04","padlid":"nvsv"}''';
      case 'iidx':
        return '''{"message":"done","code":200,"re":[],"note":[1,"\u4e00\u56de\u5236",false,"one"],"cabinet":[{"num":1,"id":"iidx","lable":"[\u897f\u9580\u4e00\u5e97] Beatmania IIDX","mode":[[0,"Standard",24.0],[1,"Premium Free",40.0]],"card":false,"bool":true,"vipbool":true,"notice":"\u820a\u6846\u9ad4","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"635c31b9a1ea2037ec289594","pad":false,"padmid":"","padlid":""}''';
      case '2diva':
        return '''{"message":"done","code":200,"re":[],"note":[0,"B1F",false,"one"],"cabinet":[{"num":1,"id":"2diva","lable":"[\u897f\u9580\u4e8c\u5e97] Project Diva Arcade","mode":[[0,"3\u66f2",20]],"card":false,"bool":false,"vipbool":false,"notice":"Nos \u65c1","busy":"<i style='margin-left:3px; color:white;' class='user circle icon'></i>\u7a7a\u9592","nbusy":"\u7a7a\u9592","pcl":false}],"caboid":"64bd3214c985961c58ab207c","pad":false,"padmid":"","padlid":""}''';
      default:
        log("", name: 'err testSelGame', error: 'no $mid testdata');
        return '';
    }
  }
}
