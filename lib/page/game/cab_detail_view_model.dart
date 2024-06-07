import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/repository/repository.dart';

class CabDatailViewModel extends BaseViewModel {
  final Repository repository;
  final String machineId;
  CabinetModel? cabinetModel;
  BasicResponse? response;
  int lineupCount = -1;

  CabDatailViewModel({required this.repository, required this.machineId});

  /// 取得遊戲機台資料
  Future<bool> getSelGameCab() async {
    try {
      log('machineId: $machineId', name: 'getSelGame');
      showLoading();
      await Future.delayed(const Duration(milliseconds: 100));

      cabinetModel = await repository.selGame(machineId);
      if (cabinetModel!.pad) {
        lineupCount = await getPadLineup(
          cabinetModel!.padmid,
          cabinetModel!.padlid,
        );
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
