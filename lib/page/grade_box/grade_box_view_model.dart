import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/grade_box/grade_box.dart';
import 'package:x50pay/repository/repository.dart';

class GradeBoxViewModel extends BaseViewModel {
  final repo = Repository();

  Future<GradeBoxModel> getGradeBox() async {
    EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 100));

    late final String rawJson;

    try {
      if (!kDebugMode || isForceFetch) {
        rawJson = await repo.fetchGradeBox();
      } else {
        rawJson = _fakeBoxJson;
      }
      final gradeBox = GradeBoxModel.fromJson(json.decode(rawJson));
      return gradeBox;
    } catch (e) {
      log('', error: e, name: 'getGradeBox');
      return const GradeBoxModel.empty();
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> doChangeGrade(String gid, String grid) async {
    final result = await repo.chgGradev2(gid, grid);
    return result == 'done';
  }

  String get _fakeBoxJson =>
      '''{"card":[{"pic":"grade/gdebox.png","name":"testName","much":"12","limit":"2","gid":"testGid","eid":"testEid","heart":"50"}],"cd":[],"code":200,"gifts":[{"pic":"grade/gdebox.png","name":"testName","much":"12","limit":"2","gid":"testGid","eid":"testEid","heart":"50"},{"pic":"grade/gdebox.png","name":"testName","much":"12","limit":"2","gid":"testGid","eid":"testEid","heart":"50"}],"x50":[]}''';
}
