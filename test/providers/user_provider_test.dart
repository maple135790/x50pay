import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepo extends Mock implements Repository {}

final mockRepo = MockRepo();

void main() {
  void arrangeGetUserReturnsData() {
    when(mockRepo.getUser).thenAnswer((_) async {
      const rawMe =
          r'''{"message":"done","code":200,"userimg":"https://www.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250","email":"test@test.com","uid":"X000","givebool":0,"point":100,"name":"test","ticketint":9,"phoneactive":true,"vip":false,"vipdate":{"$date":"1990-05-05T00:00:00Z"},"sid":"","sixn":"826070","tphone":1,"fpoint":25}''';
      return UserModel.fromJson(json.decode(rawMe));
    });
  }

  void arrangeGetUserReturnsNull() {
    when(mockRepo.getUser).thenAnswer((_) async {
      return null;
    });
  }

  void arrangeGetUserReturnsErrorCode() {
    when(mockRepo.getUser).thenAnswer((_) async {
      return const UserModel(
        message: 'error test',
        code: 404,
      );
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
