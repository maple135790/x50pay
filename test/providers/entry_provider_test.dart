import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class MockRepo extends Mock implements MainRepository {}

final mockRepo = MockRepo();

void main() {
  void arrangeGetEntryReturnsData() {
    when(mockRepo.getEntry).thenAnswer((_) async {
      return const EntryModel(message: 'done', code: 200, gr2: []);
    });
  }

  void arrangeGetEntryReturnsNull() {
    when(mockRepo.getEntry).thenAnswer((_) async {
      return null;
    });
  }

  void arrangeGetEntryReturnsErrorCode() {
    when(mockRepo.getEntry).thenAnswer((_) async {
      return const EntryModel(message: 'error test', code: 404, gr2: []);
    });
  }

  group('取得EntryModel', () {
    test('當成功取得EntryModel時，應該回傳true，且Entry 不等於Null', () async {
      arrangeGetEntryReturnsData();
      final entryProvider = EntryProvider(repo: mockRepo);
      final result = await entryProvider.checkEntry();
      expect(result, true);
      expect(entryProvider.entry, isNotNull);
    });

    test('當失敗取得EntryModel時，應該回傳false，且Entry 等於Null', () async {
      arrangeGetEntryReturnsNull();
      final entryProvider = EntryProvider(repo: mockRepo);
      var result = await entryProvider.checkEntry();
      expect(result, false);
      expect(entryProvider.entry, isNull);

      arrangeGetEntryReturnsErrorCode();
      result = await entryProvider.checkEntry();
      expect(result, false);
      expect(entryProvider.entry, isNull);
    });
  });
}
