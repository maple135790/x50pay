import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/repository.dart';

class HomeViewModel extends BaseViewModel {
  final repo = Repository();
  final isForce = GlobalSingleton.instance.isOnline;
  UserModel? user;
  EntryModel? _entry;
  EntryModel? get entry => _entry;

  set entry(EntryModel? value) {
    _entry = value;
    notifyListeners();
  }

  Future<bool> initHome({int debugFlag = 200}) async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      if (kDebugMode || isForce) {
        await GlobalSingleton.instance.checkUser(force: true);
        user = GlobalSingleton.instance.user;
        entry = await repo.getEntry();
      } else {
        user = UserModel.fromJson(jsonDecode(testUser(code: debugFlag)));
        entry = EntryModel.fromJson(jsonDecode(testEntry(code: debugFlag)));
      }
      GlobalSingleton.instance.user = user;
      await EasyLoading.dismiss();

      return entry != null && user != null;
    } on Exception catch (_) {
      await EasyLoading.dismiss();
      return false;
    }
  }

  String testUser({int code = 200}) =>
      '''{"message":"done","code":$code,"userimg":"https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","email":"maple135790@gmail.com","uid":"938","point":18.0,"name":"\u9bd6\u7f36","ticketint":7,"phoneactive":true,"vip":true,"vipdate":{"\$date":1657660411780},"sid":"","sixn":"523964","tphone":1,"doorpwd":"\u672c\u671f\u9580\u7981\u5bc6\u78bc\u7232 : 1743#"}''';
  String testEntry({int code = 200}) =>
      '''{"message":"done","code":200,"gr2":[],"grade":[0,999999,999999,"0/0",""],"evlist":[{"_id":{"\$oid":"62beafdd94e75934a4498ceb"},"name":"\u96f6\u5922\u9084\u5728\u9d3f","which":[],"describe":"\u65bc\u5168\u9ad4\u7cfb\u4f7f\u7528\u4ed8\u8cbb Point \u904a\u73a9\u4efb\u610f\u6a5f\u7a2e 4 \u9053\u9001\u8a72\u6a5f\u7a2e\u5168\u5e97\u904a\u73a9\u52381\u5f35\uff08\u9694\u65e5\u767c\u653e\uff09[7/1\u8d77]","count":"3","start":{"\$date":1656864000000},"end":{"\$date":1656950399000},"point":false,"value":0,"limit":4,"countday":"1","id":"220704","ticMid":[],"sid":"0","ticdis":"\u5168\u5e97\u53ef\u7528"}],"history":[[{"_id":{"\$oid":"62c011ebefae537097a384f6"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656754667776},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022\u5e7407\u670802\u65e5] [17 : 37"},{"_id":{"\$oid":"62c00e5eefae537097a384da"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656753758570},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022\u5e7407\u670802\u65e5] [17 : 22"},{"_id":{"\$oid":"62c007baefae537097a384a3"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656752058850},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022\u5e7407\u670802\u65e5] [16 : 54"},{"_id":{"\$oid":"62c00447efae537097a38489"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656751175969},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022\u5e7407\u670802\u65e5] [16 : 39"},{"_id":{"\$oid":"62bff4c5efae537097a38421"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] pop'n music","cid":1,"inittime":{"\$date":1656747205466},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":30.0,"time":"2022\u5e7407\u670802\u65e5] [15 : 33"},{"_id":{"\$oid":"62bfe606efae537097a3839c"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656743430207},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022\u5e7407\u670802\u65e5] [14 : 30"},{"_id":{"\$oid":"62bfe5f0efae537097a38397"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656743408641},"status":"payment done","done":true,"disbool":true,"freep":0.0,"price":19.0,"time":"2022\u5e7407\u670802\u65e5] [14 : 30"},{"_id":{"\$oid":"62bda312efae537097a37c20"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656595218720},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [21 : 20"},{"_id":{"\$oid":"62bda0c4efae537097a37c10"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656594628848},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [21 : 10"},{"_id":{"\$oid":"62bd9d2befae537097a37bf6"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656593707927},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [20 : 55"},{"_id":{"\$oid":"62bd96c4efae537097a37bc3"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656592068490},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [20 : 27"},{"_id":{"\$oid":"62bd96c4efae537097a37bc1"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656592068122},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [20 : 27"},{"_id":{"\$oid":"62bd9419efae537097a37ba8"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656591385892},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [20 : 16"},{"_id":{"\$oid":"62bd919cefae537097a37b89"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656590748955},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [20 : 05"},{"_id":{"\$oid":"62bd8e6fefae537097a37b6f"},"uid":"938","sid":"7037656","mid":"[\u897f\u9580] Jubeat","cid":1,"inittime":{"\$date":1656589935596},"status":"payment done","done":true,"disbool":false,"freep":0.0,"price":20.0,"time":"2022\u5e7406\u670830\u65e5] [19 : 52"}],[{"_id":{"\$oid":"62c00159efae537097a38470"},"uid":"938","mid":"[\u897f\u9580] pop'n music","cid":1,"price":30.0,"disbool":false,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022\u5e7407\u670802\u65e5] [16 : 27"},{"_id":{"\$oid":"62bffda2efae537097a3845c"},"uid":"938","mid":"[\u897f\u9580] pop'n music","cid":1,"price":30.0,"disbool":false,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022\u5e7407\u670802\u65e5] [16 : 11"},{"_id":{"\$oid":"62bffb16efae537097a3844c"},"uid":"938","mid":"[\u897f\u9580] pop'n music","cid":1,"price":30.0,"disbool":false,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022\u5e7407\u670802\u65e5] [16 : 00"},{"_id":{"\$oid":"62bff775efae537097a38435"},"uid":"938","mid":"[\u897f\u9580] pop'n music","cid":1,"price":30.0,"disbool":false,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022\u5e7407\u670802\u65e5] [15 : 44"},{"_id":{"\$oid":"62bb2192efae537097a37415"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022\u5e7406\u670828\u65e5] [23 : 43"},{"_id":{"\$oid":"62b5ef80b2ec8bf8003b7721"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022\u5e7406\u670825\u65e5] [01 : 08"},{"_id":{"\$oid":"62b5ecf5b2ec8bf8003b7718"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":3,"price":25.0,"disbool":true,"ticn":"\u6691\u5047\u524d\u54e8\u6d3b\u52d5","sid":"7037656","time":"2022\u5e7406\u670825\u65e5] [00 : 57"},{"_id":{"\$oid":"62a5f52b068521b28ed06950"},"uid":"938","mid":"[\u897f\u9580] DanceDanceRevolution","cid":1,"price":27.0,"disbool":false,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022\u5e7406\u670812\u65e5] [22 : 16"},{"_id":{"\$oid":"6273e32fb252e619099e4e1d"},"uid":"938","mid":"[\u897f\u9580] SDVX - Valkyrie Model","cid":2,"price":36.0,"disbool":false,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022\u5e7405\u670805\u65e5] [22 : 46"},{"_id":{"\$oid":"625a910b68bea569c7909d69"},"uid":"938","mid":"[\u897f\u9580] CHUNITHM","cid":4,"price":25.0,"disbool":true,"ticn":"\u6708\u7968\u7121\u671f\u9650\u904a\u73a9\u5377","sid":"7037656","time":"2022\u5e7404\u670816\u65e5] [17 : 48"}]],"giftlist":{"gift":false}}''';
}
