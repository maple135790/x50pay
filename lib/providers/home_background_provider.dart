import 'package:flutter/material.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/models/grade_background/grade_background.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/repository/base_repository.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class HomeBackgroundProvider extends ChangeNotifier {
  static late AppFeedbackMixin _feedbackService;

  final MainRepository _repo;

  BackgroundPath? _settingPath;

  HomeBackgroundProvider(this._repo);

  Uri get backgroundUri => _path.fullUrl;

  BackgroundPath get _path => _settingPath ?? BackgroundPath.fallback();

  Future<bool> changeBackground(GradeBackground data) async {
    final res = await _repo.setBackground(data.id);
    if (res.result.isError) {
      _feedbackService.showServiceError();
      return false;
    }
    if (res.result.successData != true) {
      return false;
    }
    _settingPath = BackgroundPath.fromModel(data);
    return true;
  }

  Future<List<GradeBackground>> getBackgoundList() async {
    final res = await _repo.getGradeBgList();
    if (res.result.isError) return [];
    return res.result.successData;
  }

  void syncFromUser(UserModel user) {
    _settingPath = BackgroundPath.fromUser(user);
    notifyListeners();
  }

  static void registerRootFeedbackService(
    AppFeedbackMixin rootUserFeedbackService,
  ) {
    _feedbackService = rootUserFeedbackService;
  }
}

extension type BackgroundPath._(String value) {
  BackgroundPath.fallback() : value = _toPath("mariv2");
  BackgroundPath.fromModel(GradeBackground model) : value = _toPath(model.id);
  BackgroundPath.fromUser(UserModel user) : value = _toPath(user.backgroundId);

  static String _toPath(String id) {
    return "/static/content/bg/$id.png";
  }

  Uri get fullUrl => Uri.https(Repository.webDomain, value);
}
