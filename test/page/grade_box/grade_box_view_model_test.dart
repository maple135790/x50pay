import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/grade_box/grade_box.dart';
import 'package:x50pay/common/models/grade_box/grade_box_item.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/page/grade_box/grade_box_loaded.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

import '../../mocks/mock_app_feedback.dart';

class MockRepository extends Mock implements MainRepository {}

class MockGradeBox extends Mock implements GradeBox {}

class MockGradeBoxItem extends Mock implements GradeBoxItem {
  // 確保每次生成的 mock 都 unique 的
  final int mockId;

  MockGradeBoxItem() : mockId = math.Random().nextInt(10);
}

class FakeGradeBox extends Fake implements GradeBox {
  @override
  final List<GradeBoxItem> card;
  @override
  final List<GradeBoxItem> cd;
  @override
  final List<GradeBoxItem> x50;
  @override
  final List<GradeBoxItem> gifts;

  FakeGradeBox({
    this.card = const [],
    this.cd = const [],
    this.x50 = const [],
    this.gifts = const [],
  });
}

class FakeUser extends Fake implements UserModel {
  @override
  String get region => 'Fake Region';
}

class FakeGradeBoxItem extends Fake implements GradeBoxItem {
  @override
  final String giftId;
  @override
  final String eventId;

  FakeGradeBoxItem({required this.giftId, required this.eventId});
}

class FakeUserProvider extends Fake implements UserProvider {
  @override
  UserModel? user;
}

void main() {
  late GradeBoxViewModel sut;
  final mockRepo = MockRepository();
  final mockFeedback = MockFeedbackService();
  final fakeUserProvider = FakeUserProvider();

  setUp(() {
    sut = GradeBoxViewModel(
      repository: mockRepo,
      feedback: mockFeedback,
      userProvider: fakeUserProvider,
    );
    arrangeSuccessFeedbackReturnsNormal(mockFeedback);
  });

  group("取得GradeBoxModel", () {
    final fakeUser = FakeUser();
    void arrangeUserReturnsNull() {
      fakeUserProvider.user = null;
    }

    void arrangeUserReturnsNormal(UserModel user) {
      fakeUserProvider.user = user;
    }

    void arrangeApiThrowsString() {
      when(() => mockRepo.getGradeBox(any())).thenThrow("");
    }

    void arrangeApiReturnsFailed() {
      when(
        () => mockRepo.getGradeBox(any()),
      ).thenAnswer((_) async => ApiResponse.createFailed(MockGradeBox()));
    }

    void arrangeApiReturnsNormal(GradeBox gradeBox) {
      when(
        () => mockRepo.getGradeBox(any()),
      ).thenAnswer((_) async => ApiResponse.createSuccess(gradeBox));
    }

    test('沒有 user 時直接回傳 false', () async {
      arrangeUserReturnsNull();
      final result = await sut.getGradeBox();
      expect(result, isFalse);
    });
    test('api 錯誤時回傳 false', () async {
      arrangeUserReturnsNormal(fakeUser);
      arrangeApiThrowsString();
      final thorwResult = await sut.getGradeBox();
      expect(thorwResult, isFalse);

      arrangeApiReturnsFailed();
      final failedResult = await sut.getGradeBox();
      expect(failedResult, isFalse);
    });
    test('api 正常時回傳 true', () async {
      final mockGradeBox = MockGradeBox();
      arrangeUserReturnsNormal(fakeUser);
      arrangeApiReturnsNormal(mockGradeBox);
      final result = await sut.getGradeBox();
      expect(result, isTrue);
      expect(sut.gradeBox, equals(mockGradeBox));
    });
  });
  group("送出兌換請求", () {
    final fakeItem = FakeGradeBoxItem(giftId: "giftId", eventId: "eventId");

    void arrangeApiReturnsFailed() {
      when(
        () => mockRepo.changeGrade(any(), any()),
      ).thenAnswer((_) async => ApiResponse.createFailed(''));
    }

    void arrangeApiReturnsSuccess() {
      when(() => mockRepo.changeGrade(any(), any())).thenAnswer((_) async {
        return ApiResponse.createSuccess(GradeBoxViewModel.exchangeSuccess);
      });
    }

    test('api 錯誤時回傳 false', () async {
      arrangeApiReturnsFailed();
      final result = await sut.exchangeItem(fakeItem);
      expect(result, isFalse);
    });
    test('api 正常時回傳 true', () async {
      arrangeApiReturnsSuccess();
      final result = await sut.exchangeItem(fakeItem);
      expect(result, isTrue);
    });
  });

  group("filteredItems", () {
    test('gradeBox 為空時返回空', () {
      sut.gradeBox = null;
      expect(sut.filteredItems, isEmpty);
    });
    test('檢查各項取得', () {
      final fakeCards = List.generate(3, (index) => MockGradeBoxItem());
      final fakeGifts = List.generate(4, (index) => MockGradeBoxItem());
      final fakeCDs = List.generate(5, (index) => MockGradeBoxItem());
      final fakeX50s = List.generate(6, (index) => MockGradeBoxItem());

      sut.gradeBox = FakeGradeBox(
        card: fakeCards,
        cd: fakeCDs,
        gifts: fakeGifts,
        x50: fakeX50s,
      );

      sut.selectedFilter = GradeBoxFilter.card;
      expect(sut.filteredItems, equals(fakeCards));

      sut.selectedFilter = GradeBoxFilter.album;
      expect(sut.filteredItems, equals(fakeCDs));

      sut.selectedFilter = GradeBoxFilter.misc;
      expect(sut.filteredItems, equals(fakeGifts));

      sut.selectedFilter = GradeBoxFilter.storeRelated;
      expect(sut.filteredItems, equals(fakeX50s));

      sut.selectedFilter = GradeBoxFilter.all;
      expect(
        sut.filteredItems,
        orderedEquals([...fakeCards, ...fakeGifts, ...fakeCDs, ...fakeX50s]),
      );
    });
  });
}
