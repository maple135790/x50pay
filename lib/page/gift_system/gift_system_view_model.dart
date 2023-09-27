import 'dart:developer';

import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/repository/repository.dart';

class GiftSystemViewModel extends BaseViewModel {
  final Repository repository;

  GiftSystemViewModel({required this.repository});

  GiftBoxModel? get giftBox => _giftBox;
  GiftBoxModel? _giftBox;
  set giftBox(GiftBoxModel? value) {
    _giftBox = value;
    notifyListeners();
  }

  LotteListModel? get lotteList => _lotteList;
  LotteListModel? _lotteList;
  set lotteList(LotteListModel? value) {
    _lotteList = value;
    notifyListeners();
  }

  /// 禮物系統頁面初始化
  Future<void> giftSystemInit() async {
    try {
      showLoading();
      await Future.delayed(const Duration(milliseconds: 100));
      giftBox = await _getGiftBox();
      lotteList = await _getLotteList();
    } catch (e, stacktrace) {
      log('', name: 'err giftSystemInit', error: e, stackTrace: stacktrace);
    } finally {
      dismissLoading();
    }
  }

  /// 取得養成抽獎箱
  Future<LotteListModel?> _getLotteList() async {
    try {
      lotteList = await repository.getLotteList();
      return lotteList;
    } catch (e) {
      log('', name: 'err _getLotteList', error: e);
    }
    return null;
  }

  /// 取得禮物箱資料
  ///
  /// 禮物箱包含可兌換及已兌換的禮物列表
  Future<GiftBoxModel?> _getGiftBox() async {
    try {
      giftBox = await repository.getGiftBox();
      return giftBox;
    } catch (e) {
      log('', name: 'err _getGiftBox', error: e);
    }
    return null;
  }
}
