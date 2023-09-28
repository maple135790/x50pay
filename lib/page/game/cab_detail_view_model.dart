import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
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

      final sid = await Prefs.getString(PrefsToken.storeId);

      if (sid == null) return false;

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
}
