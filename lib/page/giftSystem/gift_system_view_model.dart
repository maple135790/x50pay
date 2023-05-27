import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/repository/repository.dart';

class GiftSystemViewModel extends BaseViewModel {
  final repo = Repository();

  bool get isForce => GlobalSingleton.instance.isOnline;
  GiftBoxModel? giftBoxModel;
  LotteListModel? lotteListModel;

  Future<bool> giftSystemInit() async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 100));
      if (await _getGiftBox()) {
        if (await _getLotteList()) {
          return true;
        }
      }
      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> _getLotteList() async {
    try {
      if (!kDebugMode || isForce) {
        lotteListModel = await repo.getLotteList();
      } else {
        lotteListModel = LotteListModel.fromJson(jsonDecode(testLotteList));
      }
      return true;
    } catch (e) {
      log('', name: 'err _getLotteList', error: e);
      return false;
    }
  }

  Future<bool> _getGiftBox() async {
    try {
      if (!kDebugMode || isForce) {
        giftBoxModel = await repo.getGiftBox();
      } else {
        giftBoxModel = GiftBoxModel.fromJson(jsonDecode(testGiftBox));
      }
      return true;
    } catch (e) {
      log('', name: 'err _getGiftBox', error: e);
      return false;
    }
  }

  String get testGiftBox =>
      r'''{"alchange":[{"auto":true,"chid":"60791ab743597f9ad83dd3c5","gid":"210401","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"60791ab743597f9ad83dd3c6","gid":"210403","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"60791ab743597f9ad83dd3c7","gid":"210405","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"607949775feec4f6f845fadf","gid":"210407","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"607c244b5feec4f6f845ff48","gid":"210410","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"6082b86d1596015674c73cf3","gid":"210413","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"6082eed443597f9ad83dde44","gid":"210415","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"60898d721596015674c74372","gid":"210417","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"60921a22c5f9281541a9c4db","gid":"210420","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"609a45076c61b0b0985ab170","gid":"g210425","name":"\u592a\u9f13\u8679\u7248\u4e09\u793e\u5361\u62bd\u9078\u6b0a","pic":"https://pay.x50.fun/static/gamesimg/tko.png"},{"auto":true,"chid":"6162f575ab0f848443f93827","gid":"210901","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"6162f575ab0f848443f93828","gid":"210903","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"6162f575ab0f848443f93829","gid":"210904","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"61630510ab0f848443f9384d","gid":"g210905","name":"Lv5\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"616d9784723b41f25104fc4a","gid":"210906","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"616fc8286be42d3d2d7ed01c","gid":"210907","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"616fc8286be42d3d2d7ed01d","gid":"210908","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"617a8e0df102ee893cf68b4d","gid":"210909","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"617a8e0df102ee893cf68b4e","gid":"g210910","name":"Lv10\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"617a8e0df102ee893cf68b4f","gid":"210911","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"617a8e0df102ee893cf68b50","gid":"210912","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"617a8e0df102ee893cf68b51","gid":"210913","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"617aa5185482b2d5502d6956","gid":"210914","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"617d8f1e5482b2d5502d6e59","gid":"g210915","name":"Lv15\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"617ecc975482b2d5502d702c","gid":"210917","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"6182a73d5482b2d5502d7465","gid":"210919","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"6182a73d5482b2d5502d7466","gid":"g210920_1","name":"Lv20\u9650\u5b9a\u5361\u62bd\u9078-1","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"6182a73d5482b2d5502d7467","gid":"g210920_2","name":"Lv20\u9650\u5b9a\u5361\u62bd\u9078-2","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"6186392bf102ee893cf69bc7","gid":"210921","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"618fcb6df102ee893cf6ab7c","gid":"210924","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"618fcb6df102ee893cf6ab7d","gid":"g210925_1","name":"Lv25\u9650\u5b9a\u5361\u62bd\u9078-1","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"618fcb6df102ee893cf6ab7e","gid":"g210925_2","name":"Lv25\u9650\u5b9a\u5361\u62bd\u9078-2","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"61989efd5482b2d5502d9358","gid":"210926","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"6198eca9f102ee893cf6b6c6","gid":"210928","name":"\u904a\u73a9\u5377\u4e09\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"619f9ac7455efbb93e477104","gid":"g210930_1","name":"Lv30\u9650\u5b9a\u5361\u62bd\u9078-1","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"619f9ac7455efbb93e477105","gid":"g210930_2","name":"Lv30\u9650\u5b9a\u5361\u62bd\u9078-2","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"61a1d868e951f8f6e387d90d","gid":"210932","name":"\u904a\u73a9\u5377\u4e09\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"61ab51ebe951f8f6e387e656","gid":"g210935_1","name":"Lv35\u9650\u5b9a\u5361\u62bd\u9078-1","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"61ab51ebe951f8f6e387e657","gid":"g210935_2","name":"Lv35\u9650\u5b9a\u5361\u62bd\u9078-2","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"61adfb32759b11f737f12da9","gid":"210937","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"61bee493b7c1b697ed072f2d","gid":"210939","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"61d94b93dcdf3ed2a141e52c","gid":"g210940_1","name":"Lv40\u9650\u5b9a\u5361\u62bd\u9078-1","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"61d94b93dcdf3ed2a141e52d","gid":"g210940_2","name":"Lv40\u9650\u5b9a\u5361\u62bd\u9078-2","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"61e231659cfa29c7a7e0d631","gid":"210942","name":"\u904a\u73a9\u5377\u5169\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"62103ebf3006adfa2fa0915d","gid":"220205","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"62103ebf3006adfa2fa0915e","gid":"g220205","name":"Lv5\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"62110d4a99680c772fc2f357","gid":"220210","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"62110d4a99680c772fc2f358","gid":"220215","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"62110d4a99680c772fc2f359","gid":"220220","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"62110d4a99680c772fc2f35a","gid":"220222","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"62110d4a99680c772fc2f35b","gid":"g220210","name":"Lv10\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"62110d4a99680c772fc2f35c","gid":"g220215","name":"Lv15\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"62110d4a99680c772fc2f35d","gid":"g220220","name":"Lv20\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"621b28d7eb0ccb9a030b8283","gid":"220225","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"621b28d7eb0ccb9a030b8284","gid":"g220225","name":"Lv25\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"621c87543ce80c212767ef03","gid":"220227","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"621c87543ce80c212767ef04","gid":"220228","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"621c87543ce80c212767ef05","gid":"220230","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"621c87543ce80c212767ef06","gid":"g220230","name":"Lv30\u9650\u5b9a\u5361\u62bd\u9078","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"622460bde9d92aa2acb5f3a7","gid":"220232","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"622460bde9d92aa2acb5f3a8","gid":"220234","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"622460bde9d92aa2acb5f3a9","gid":"220235","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"622460bde9d92aa2acb5f3aa","gid":"220237","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":false,"chid":"622460bde9d92aa2acb5f3ab","gid":"g2202351","name":"Lv35\u9650\u5b9a\u5361\u62bd\u9078-1","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":false,"chid":"622460bde9d92aa2acb5f3ac","gid":"g2202352","name":"Lv35\u9650\u5b9a\u5361\u62bd\u9078-2","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"auto":true,"chid":"625a7c1768bea569c7909c8c","gid":"220239","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"},{"auto":true,"chid":"625a7c1768bea569c7909c8d","gid":"220240","name":"\u904a\u73a9\u5377\u4e59\u5f35","pic":"https://pay.x50.fun/static/ticket.png"}],"canchange":[{"chid":"625a7c1768bea569c7909c8e","gid":"g2202401","name":"Lv40\u9650\u5b9a\u5361\u62bd\u9078-1","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"},{"chid":"625a7c1768bea569c7909c8f","gid":"g2202402","name":"Lv40\u9650\u5b9a\u5361\u62bd\u9078-2","pic":"https://pay.x50.fun/static/gamesimg/mmdx.png"}],"code":200}''';
  String get testLotteList => r'''{"list":["SDVX VVelcome \u9650\u5b9a\u5361","8/30",42,true,0]}''';
}
