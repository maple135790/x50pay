import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/repository/repository.dart';

typedef InsertResponse = ({
  bool is200,
  ({String msg, String describe}) response
});

class CabSelectViewModel extends BaseViewModel {
  final VoidCallback? onInsertSuccess;

  CabSelectViewModel({this.onInsertSuccess});
  final repo = Repository();

  Future<bool> doInsertQRPay({
    required String url,
    int debugFlag = 200,
  }) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 500));
      late InsertResponse result;
      late final BasicResponse rawResponse;
      log('url: $url', name: 'doInsertQRPay');

      if (!kDebugMode || isForceFetch) {
        rawResponse = await repo.doInsertRawUrl(url);
      } else {
        rawResponse =
            BasicResponse.fromJson(jsonDecode(testResponse(code: debugFlag)));
      }
      result = _resolveRawResponse(rawResponse);
      _showInsertResult(result);
      return true;
    } catch (e) {
      _onInsertError(e);
      return false;
    } finally {
      _postDoInsert();
    }
  }

  Future<bool> doInsert({
    required bool isTicket,
    required bool isUseRewardPoint,
    required String id,
    required int index,
    required num mode,
    int debugFlag = 200,
  }) async {
    try {
      await EasyLoading.show();
      await Future.delayed(const Duration(milliseconds: 500));
      late InsertResponse result;
      late final BasicResponse rawResponse;
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');
      log(
        'index: $index, id: $id/$sid$index, mode: $mode, isTicket: $isTicket',
        name: 'doInsert',
      );

      if (!kDebugMode || isForceFetch) {
        rawResponse = await repo.doInsert(
            isTicket, '$id/$sid$index', mode, isUseRewardPoint);
      } else {
        String insertUrl = isTicket ? 'tic' : 'pay';
        String url = '/$insertUrl/$id/${mode.toInt()}';
        if (!isTicket) {
          url += '/${isUseRewardPoint ? 1 : 0}';
        }
        log('url: $url', name: 'doInsert');
        rawResponse =
            BasicResponse.fromJson(jsonDecode(testResponse(code: debugFlag)));
      }
      result = _resolveRawResponse(rawResponse);
      _showInsertResult(result);
      return true;
    } catch (e) {
      _onInsertError(e);
      return false;
    } finally {
      _postDoInsert();
    }
  }

  void _showInsertResult(InsertResponse result) async {
    await EasyLoading.dismiss();
    result.is200
        ? await EasyLoading.showSuccess(
            '${result.response.msg}\n${result.response.describe}')
        : await EasyLoading.showError(
            '${result.response.msg}\n${result.response.describe}');
  }

  void _onInsertError(Object e) async {
    await EasyLoading.dismiss();
    log('', error: '$e', name: 'doInsert');
    await EasyLoading.showError(S.current.serviceError);
  }

  void _postDoInsert() async {
    await GlobalSingleton.instance.checkUser(force: true);
    await Future.delayed(const Duration(seconds: 2));
  }

  InsertResponse _resolveRawResponse(BasicResponse response) {
    String msg = '';
    String describe = '';
    bool is200 = false;

    switch (response.code) {
      case 200:
        is200 = true;
        msg = '投幣成功，感謝您的惠顧！';
        describe = '請等候約三秒鐘，若機台仍無反應請盡速與X50粉絲專頁聯絡';
        onInsertSuccess?.call();
        break;
      case 601:
        msg = '機台鎖定中';
        describe = '目前機台正在遊玩中   請稍候再投幣';
        break;
      case 602:
        msg = '投幣失敗';
        describe = '請確認您的網路環境，再次重試，如多次無法請回報粉專';
        break;
      case 603:
        msg = '餘額不足';
        describe = '您的餘額不足，無法遊玩   請加值';
        break;
      case 604:
        msg = '未知錯誤';
        describe = '反正就是錯誤';
        break;
      case 609:
        msg = '請驗證電話';
        describe = '您的帳號並沒有電話驗證   請先驗證電話方可用遊玩券';
        break;
      case 698:
        msg = '遊玩券使用失敗';
        describe = '您的遊玩券此機種不適用 請進入會員中心 -> 獲券紀錄 檢閱';
        break;
      case 699:
        msg = '遊玩券使用失敗';
        describe = '此機不開放使用遊玩券';
        break;
      case 6099:
        msg = '請先填寫實聯驗證';
        describe = '尚未實聯';
        break;
    }

    return (is200: is200, response: (msg: msg, describe: describe));
  }

  String testResponse({int code = 200}) =>
      '''{"code":$code,"message":"smth"}''';
}
