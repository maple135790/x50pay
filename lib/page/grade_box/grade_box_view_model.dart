import 'dart:convert';
import 'dart:developer';

import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/grade_box/grade_box.dart';
import 'package:x50pay/repository/repository.dart';

class GradeBoxViewModel extends BaseViewModel {
  final Repository repository;

  GradeBoxViewModel({required this.repository});

  /// 取得養成商場內，點數兌換商品資料
  Future<GradeBoxModel> getGradeBox() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 100));

    late final String rawJson;

    try {
      rawJson = await repository.fetchGradeBox();
      final gradeBox = GradeBoxModel.fromJson(json.decode(rawJson));
      return gradeBox;
    } catch (e) {
      log('', error: e, name: 'getGradeBox');
      return const GradeBoxModel.empty();
    } finally {
      dismissLoading();
    }
  }

  /// 兌換養成商場內商品
  Future<bool> doChangeGrade(String gid, String grid) async {
    final result = await repository.chgGradev2(gid, grid);
    return result == 'done';
  }
}
