import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/models/gift_box/claimable_gift.dart';
import 'package:x50pay/common/models/gift_box/claimed_gift.dart';
import 'package:x50pay/common/models/gift_box/gift_box.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class GiftPageViewModel extends ChangeNotifier {
  final MainRepository _repository;
  final AppFeedbackMixin _feedbackMixin;
  final Logger _logger;

  GiftPageViewModel({required this._repository, required this._feedbackMixin})
    : _logger = Logger('GiftPageViewModel');

  GiftBox? _giftBox;

  List<ClaimableGift> get claimableGifts {
    if (_giftBox == null) return [];
    return List.unmodifiable(_giftBox!.claimableGifts);
  }

  List<ClaimedGift> get claimedGifts {
    if (_giftBox == null) return [];
    return List.unmodifiable(_giftBox!.claimedGifts);
  }

  /// 禮物系統頁面初始化
  Future<void> init() async {
    try {
      _feedbackMixin.showLoading();
      final res = await _repository.getGiftBox();
      if (res.result.isError) {
        final msg = res.result.asError.errorMsg;
        _logger.warning('getGiftBox error: $msg');
        return;
      }
      _giftBox = res.result.successData;
      notifyListeners();
    } catch (e, stacktrace) {
      _logger.warning('init', e, stacktrace);
    } finally {
      _feedbackMixin.dismissLoading();
    }
  }
}
