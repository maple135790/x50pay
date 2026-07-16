import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';
import 'package:x50pay/service/game_insert_service.dart';

import '../../mocks/mock_app_feedback.dart';

class MockRepository extends Mock implements MainRepository {}

final mockRepo = MockRepository();

void main() {
  final mockFeedback = MockFeedbackService();
  final viewModel = GameInsertService(
    repository: mockRepo,
    onAfterInserted: () {},
  );

  setUp(() {
    GameInsertService.registerRootFeedbackService(mockFeedback);
    SharedPreferences.setMockInitialValues({"store_id": "7037656"});
    viewModel.clearRecentPlayedData();

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

  test('一般投幣成功時會記錄最近遊玩機台', () async {
    const cabinet = Cabinet.empty();
    arrangeSuccessFeedbackReturnsNormal(mockFeedback);

    final result = await viewModel.doInsert(
      isTicket: false,
      isUseRewardPoint: false,
      oid: 'id',
      index: 0,
      mode: 0,
      cabinet: cabinet,
    );

    expect(result, true);
    expect(viewModel.recentPlayedData, (
      cabinet: cabinet,
      cabOid: 'id',
      cabNum: 0,
    ));
  });

  test('QRPay 投幣成功時不會覆蓋最近遊玩機台', () async {
    const recentCabinet = Cabinet.empty();
    arrangeSuccessFeedbackReturnsNormal(mockFeedback);
    await viewModel.doInsert(
      isTicket: false,
      isUseRewardPoint: false,
      oid: 'recent-caboid',
      index: 7,
      mode: 0,
      cabinet: recentCabinet,
    );

    final result = await viewModel.doInsertQRPay(url: 'url');

    expect(result, true);
    expect(viewModel.recentPlayedData, (
      cabinet: recentCabinet,
      cabOid: 'recent-caboid',
      cabNum: 7,
    ));
  });
}
