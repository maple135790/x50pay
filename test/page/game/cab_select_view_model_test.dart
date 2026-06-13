import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/repository/main_repository/repository.dart';
import 'package:x50pay/service/game_insert_service.dart';

class MockRepository extends Mock implements Repository {}

class TestFeedbackService with AppFeedbackMixin {
  @override
  BuildContext get context => throw UnimplementedError();

  @override
  void dismissLoading() {}

  @override
  void showError(String text) {}

  @override
  void showLoading() {}

  @override
  void showServiceError() {}

  @override
  void showSuccess(String text) {}
}

final mockRepo = MockRepository();

void main() {
  final viewModel = GameInsertService(
    repository: mockRepo,
    onAfterInserted: () {},
  );

  setUpAll(() {
    GameInsertService.registerRootFeedbackService(TestFeedbackService());
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({"store_id": "7037656"});
    GlobalSingleton.instance.recentPlayedCabinetData = null;

    when(() => mockRepo.doInsert(any(), any(), any(), any())).thenAnswer((
      _,
    ) async {
      const rawResponse = '''{"code":200,"message":"smth"}''';
      return BasicResponse.fromJson(json.decode(rawResponse));
    });
    when(() => mockRepo.doInsertRawUrl(any())).thenAnswer((_) async {
      const rawResponse = '''{"code":200,"message":"smth"}''';
      return BasicResponse.fromJson(json.decode(rawResponse));
    });
  });

  test('一般投幣成功時會呼叫單次 onInsertSuccess', () async {
    var isInsertSuccessCalled = false;

    final result = await viewModel.doInsert(
      isTicket: false,
      isUseRewardPoint: false,
      id: 'id',
      index: 0,
      mode: 0,
      onInsertSuccess: () {
        isInsertSuccessCalled = true;
      },
    );

    expect(result, true);
    expect(isInsertSuccessCalled, true);
  });

  test('QRPay 投幣成功時不會寫入最近遊玩機台', () async {
    const recentCabinet = Cabinet.empty();
    GlobalSingleton.instance.recentPlayedCabinetData = (
      cabinet: recentCabinet,
      caboid: 'recent-caboid',
      cabNum: 7,
    );

    final result = await viewModel.doInsertQRPay(url: 'url');

    expect(result, true);
    expect(GlobalSingleton.instance.recentPlayedCabinetData, (
      cabinet: recentCabinet,
      caboid: 'recent-caboid',
      cabNum: 7,
    ));
  });
}
