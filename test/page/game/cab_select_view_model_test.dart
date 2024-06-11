import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/page/game/cab_select_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();

void main() {
  final viewModel = CabSelectViewModel(
    repository: mockRepo,
    onAfterInserted: () {},
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({"store_id": "7037656"});

    when(() => mockRepo.doInsert(
          any(),
          any(),
          any(),
          any(),
        )).thenAnswer((_) async {
      const rawResponse = '''{"code":200,"message":"smth"}''';
      return BasicResponse.fromJson(json.decode(rawResponse));
    });
    when(() => mockRepo.doInsertRawUrl(any())).thenAnswer((_) async {
      const rawResponse = '''{"code":200,"message":"smth"}''';
      return BasicResponse.fromJson(json.decode(rawResponse));
    });
  });
  test('測試投幣', () async {
    final result = await viewModel.doInsert(
      isTicket: false,
      isUseRewardPoint: false,
      id: 'id',
      index: 0,
      mode: 0,
    );
    expect(result, true);
  });
  test('測試QRPay', () async {
    final result = await viewModel.doInsertQRPay(url: 'url');
    expect(result, true);
  });
}
