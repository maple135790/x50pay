import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class MockRepository extends Mock implements MainRepository {}

class FakeUserModel extends Fake implements UserModel {}

class MockEntryModel extends Mock implements EntryModel {}

final mockRepo = MockRepository();

abstract class OnSyncUser {
  void call(UserModel user);
}

class MockOnSyncUser extends Mock implements OnSyncUser {}

void main() {
  final mockOnSyncUser = MockOnSyncUser();
  void arrangeGetEntryReturnsData() {
    when(mockRepo.getEntry).thenAnswer((_) async {
      return ApiResponse.createSuccess(MockEntryModel());
    });
  }

  void arrangeGetEntryReturnsFailed() {
    when(mockRepo.getEntry).thenAnswer((_) async {
      return ApiResponse.createFailed(MockEntryModel());
    });
  }

  void arrangeGetUserReturnsFailed() {
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
        userProvider: UserProvider(
          repo: mockRepo,
          onSyncUser: mockOnSyncUser.call,
        ),
      );
      final isFetchedData = await viewModel.initHome();
      expect(isFetchedData, true);
    });
    test('當getUser 和getEntry 其中一個沒有回傳資料', () async {
      arrangeGetUserReturnsFailed();
      arrangeGetEntryReturnsData();
      final viewModel = HomeViewModel(
        entryProvider: EntryProvider(repo: mockRepo),
        userProvider: UserProvider(
          repo: mockRepo,
          onSyncUser: mockOnSyncUser.call,
        ),
      );
      var isFetchedData = await viewModel.initHome();
      expect(isFetchedData, false);

      arrangeGetUserReturnsData();
      arrangeGetEntryReturnsFailed();
      isFetchedData = await viewModel.initHome();
      expect(isFetchedData, false);

      arrangeGetUserReturnsFailed();
      arrangeGetEntryReturnsFailed();
      isFetchedData = await viewModel.initHome();
      expect(isFetchedData, false);
    });
  });
}
