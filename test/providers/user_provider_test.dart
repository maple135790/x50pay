import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepo extends Mock implements Repository {}

class FakeUserModel extends Fake implements UserModel {}

final mockRepo = MockRepo();

void main() {
  void arrangeGetUserReturnsData() {
    when(mockRepo.getUser).thenAnswer((_) async {
      return ApiResponse.createSuccess(FakeUserModel());
    });
  }

  void arrangeGetUserReturnsNull() {
    when(mockRepo.getUser).thenAnswer((_) async {
      return ApiResponse.createFailed(FakeUserModel());
    });
  }

  void arrangeGetUserReturnsErrorCode() {
    when(mockRepo.getUser).thenAnswer((_) async {
      return ApiResponse.createFailed(FakeUserModel());
    });
  }

  group('取得userModel', () {
    test('當成功取得userModel時，應該回傳true，且User 不等於Null', () async {
      arrangeGetUserReturnsData();
      final userProvider = UserProvider(repo: mockRepo);
      final result = await userProvider.checkUser();
      expect(result, true);
      expect(userProvider.user, isNotNull);
    });

    test('當失敗取得userModel時，應該回傳false，且User 等於Null', () async {
      arrangeGetUserReturnsNull();
      final userProvider = UserProvider(repo: mockRepo);
      var result = await userProvider.checkUser();
      expect(result, false);
      expect(userProvider.user, isNull);

      arrangeGetUserReturnsErrorCode();
      result = await userProvider.checkUser();
      expect(result, false);
      expect(userProvider.user, isNull);
    });
  });
  test('當清除User資料時，User 資料為null', () async {
    arrangeGetUserReturnsData();
    final userProvider = UserProvider(repo: mockRepo);
    final isGotUser = await userProvider.checkUser();
    expect(isGotUser, true);
    expect(userProvider.user, isNotNull);

    userProvider.clearUser();
    expect(userProvider.user, isNull);
  });
}
