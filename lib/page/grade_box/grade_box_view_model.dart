import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/models/grade_box/grade_box.dart';
import 'package:x50pay/common/models/grade_box/grade_box_item.dart';
import 'package:x50pay/page/grade_box/grade_box_loaded.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class GradeBoxViewModel extends ChangeNotifier {
  final MainRepository _repository;
  final UserProvider _userProvider;
  final AppFeedbackMixin _feedback;
  final Logger _logger;

  GradeBoxViewModel({
    required this._repository,
    required this._feedback,
    required this._userProvider,
  }) : _logger = Logger("GradeBoxViewModel");

  @visibleForTesting
  GradeBox? gradeBox;

  GradeBoxFilter _selectedFilter = GradeBoxFilter.initial;
  GradeBoxFilter get selectedFilter => _selectedFilter;
  set selectedFilter(GradeBoxFilter value) {
    if (value == _selectedFilter) return;
    _selectedFilter = value;
    notifyListeners();
  }

  @visibleForTesting
  static const exchangeSuccess = 'done';

  List<GradeBoxItem> get filteredItems {
    final data = gradeBox;
    if (data == null) return [];

    final items = switch (_selectedFilter) {
      .all => [...data.card, ...data.gifts, ...data.cd, ...data.x50],
      .card => [...data.card],
      .misc => [...data.gifts],
      .album => [...data.cd],
      .storeRelated => [...data.x50],
    };

    return List.unmodifiable(items);
  }

  /// 取得養成商場內，點數兌換商品資料
  Future<bool> getGradeBox() async {
    _feedback.showLoading();
    bool isSuccess = false;
    final userRegion = _userProvider.user?.region;
    if (userRegion == null) return false;

    try {
      final res = await _repository.getGradeBox(userRegion);
      if (res.result.isSuccess) {
        gradeBox = res.result.successData;
        isSuccess = true;
      }
    } catch (e, s) {
      _logger.warning('getGradeBox', e, s);
    }
    _feedback.dismissLoading();
    return isSuccess;
  }

  /// 兌換養成商場內商品
  Future<bool> exchangeItem(GradeBoxItem item) async {
    final result = await _repository.changeGrade(
      item.giftId.replaceFirst("chG-", ''),
      item.eventId,
    );
    if (result.result.isError) return false;
    return result.result.successData == exchangeSuccess;
  }
}
