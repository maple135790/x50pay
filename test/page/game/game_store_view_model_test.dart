import 'dart:convert';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/page/game/game_store_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

class FakeLocale extends Fake implements Locale {}

final mockRepo = MockRepository();

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLocale());
  });

  setUp(() {
    when(() => mockRepo.getStores(any())).thenAnswer((_) async {
      const rawResponse =
          '''{"prefix":"70","storelist":[{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u6b66\u660c\u8857\u4e8c\u6bb5134\u865f1\u6a13","name":"\u897f\u9580\u4e00\u5e97","sid":37656},{"address":"\u81fa\u5317\u5e02\u842c\u83ef\u5340\u5eb7\u5b9a\u8def10\u865f1\u6a13","name":"\u897f\u9580\u4e8c\u5e97","sid":37658}]}''';
      return StoreModel.fromJson(json.decode(rawResponse));
    });
  });

  test('測試取得店家資料', () async {
    final viewModel = GameStoreViewModel(repository: mockRepo);
    final storeModel =
        await viewModel.getStoreData(currentLocale: const Locale('zh', 'TW'));
    expect(storeModel, isNotNull);
  });
}
