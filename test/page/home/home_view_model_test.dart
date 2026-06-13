
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

class FakeUserModel extends Fake implements UserModel {}

class FakeEntryModel extends Fake implements EntryModel {}

final mockRepo = MockRepository();

void main() {
  void arrangeGetEntryReturnsData() {
    when(mockRepo.getEntry).thenAnswer((_) async {
      return FakeEntryModel();
    });
  }

  void arrangeGetEntryReturnsNull() {
    when(mockRepo.getEntry).thenAnswer((_) async {
      return null;
    });
  }

  void arrangeGetUserReturnsNull() {
    when(mockRepo.getUser).thenAnswer((_) async {
      return ApiResponse.createFailed(FakeUserModel());
    });
  }

  void arrangeGetUserReturnsData() {
    when(mockRepo.getUser).thenAnswer((_) async {
      return ApiResponse.createSuccess(FakeUserModel());
    });
  }

  group('測試取得Entry', () {
    test('當getUser 和getEntry 皆回傳資料', () async {
      arrangeGetUserReturnsData();
      arrangeGetEntryReturnsData();
      final viewModel = HomeViewModel(
        entryProvider: EntryProvider(repo: mockRepo),
        userProvider: UserProvider(repo: mockRepo),
      );
      final isFetchedData = await viewModel.initHome();
      expect(isFetchedData, true);
    });
    test('當getUser 和getEntry 其中一個沒有回傳資料', () async {
      arrangeGetUserReturnsNull();
      arrangeGetEntryReturnsData();
      final viewModel = HomeViewModel(
        entryProvider: EntryProvider(repo: mockRepo),
        userProvider: UserProvider(repo: mockRepo),
      );
      var isFetchedData = await viewModel.initHome();
      expect(isFetchedData, false);

      arrangeGetUserReturnsData();
      arrangeGetEntryReturnsNull();
      isFetchedData = await viewModel.initHome();
      expect(isFetchedData, false);

      arrangeGetUserReturnsNull();
      arrangeGetEntryReturnsNull();
      isFetchedData = await viewModel.initHome();
      expect(isFetchedData, false);
    });
  });
}
