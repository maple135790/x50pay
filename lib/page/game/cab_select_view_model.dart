import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/repository.dart';

typedef _InsertResponse = ({
  bool is200,
  ({String msg, String describe}) response
});

class CabSelectViewModel extends BaseViewModel {
  final VoidCallback? onInsertSuccess;
  final Repository repository;

  CabSelectViewModel({this.onInsertSuccess, required this.repository});

  Future<bool> doInsertQRPay({required String url}) async {
    try {
      showLoading();
      await Future.delayed(const Duration(milliseconds: 500));
      late _InsertResponse result;
      BasicResponse rawResponse = BasicResponse.empty();
      log('url: $url', name: 'doInsertQRPay');

      if (kReleaseMode) {
        rawResponse = await repository.doInsertRawUrl(url);
      }
      result = _resolveRawResponse(rawResponse);
      _showInsertResult(result);
      return true;
    } catch (e, stacktrace) {
      _onInsertError(e, stacktrace);
      return false;
    } finally {
      _postDoInsert();
    }
  }

  Future<bool> doInsert(
      {required bool isTicket,
      required bool isUseRewardPoint,
      required String id,
      required int index,
      required num mode}) async {
    try {
      showLoading();
      await Future.delayed(const Duration(milliseconds: 500));
      late _InsertResponse result;
      final sid = await Prefs.getString(PrefsToken.storeId);
      BasicResponse rawResponse = kDebugMode
          ? const BasicResponse(
              code: 200,
              message: "Test Success, no token is inserted",
            )
          : BasicResponse.empty();

      log(
        'index: $index, id: $id/$sid$index, mode: $mode, isTicket: $isTicket',
        name: 'doInsert',
      );

      if (kReleaseMode) {
        rawResponse = await repository.doInsert(
          isTicket,
          '$id/$sid$index',
          mode,
          isUseRewardPoint,
        );
      }
      result = _resolveRawResponse(rawResponse);
      _showInsertResult(result);
      return true;
    } catch (e, stacktrace) {
      _onInsertError(e, stacktrace);
      return false;
    } finally {
      _postDoInsert();
    }
  }

  void _showInsertResult(_InsertResponse result) async {
    dismissLoading();
    result.is200
        ? showSuccess('${result.response.msg}\n${result.response.describe}')
        : showError('${result.response.msg}\n${result.response.describe}');
  }

  void _onInsertError(Object e, StackTrace stacktrace) async {
    dismissLoading();
    log('', error: '$e', name: 'doInsert', stackTrace: stacktrace);
    showError(serviceErrorMessage);
  }

  void _postDoInsert() async {
    await GlobalSingleton.instance.checkUser(force: true);
    await Future.delayed(const Duration(seconds: 2));
  }

  _InsertResponse _resolveRawResponse(BasicResponse response) {
    String msg = '';
    String describe = response.message;
    bool is200 = response.code == 200;

    switch (response.code) {
      case 200:
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
}
