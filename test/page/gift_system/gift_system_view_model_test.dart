import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/gift_box/claimable_gift.dart';
import 'package:x50pay/common/models/gift_box/claimed_gift.dart';
import 'package:x50pay/common/models/gift_box/gift_box.dart';
import 'package:x50pay/page/gift_system/gift_page_view_model.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

import '../../mocks/mock_app_feedback.dart';

class MockRepository extends Mock implements MainRepository {}

class MockGiftBox extends Mock implements GiftBox {}

class MockClaimedGift extends Mock implements ClaimedGift {}

class MockClaimableGift extends Mock implements ClaimableGift {}

class FakeGiftBox extends Fake implements GiftBox {
  @override
  final claimedGifts = [MockClaimedGift()];
  @override
  final claimableGifts = [MockClaimableGift()];
}

void main() {
  final mockRepo = MockRepository();
  final mockFeedbackService = MockFeedbackService();
  late GiftPageViewModel sut;

  setUp(() {
    sut = GiftPageViewModel(
      repository: mockRepo,
      feedbackMixin: mockFeedbackService,
    );
    arrangeSuccessFeedbackReturnsNormal(mockFeedbackService);
  });

  group('頁面初始化', () {
    void arrangeApiReturnFailed() {
      when(
        () => mockRepo.getGiftBox(),
      ).thenAnswer((_) async => ApiResponse.createFailed(MockGiftBox()));
    }

    void arrangeApiThrowsAny() {
      when(() => mockRepo.getGiftBox()).thenThrow('mock error');
    }

    void arrangeApiReturnNormal(GiftBox value) {
      when(
        () => mockRepo.getGiftBox(),
      ).thenAnswer((_) async => ApiResponse.createSuccess(value));
    }

    test('當 api 回應正常，預期回傳', () async {
      arrangeApiReturnFailed();
      await sut.init();
      expect(sut.claimableGifts, isEmpty);
      expect(sut.claimedGifts, isEmpty);

      arrangeApiThrowsAny();
      await sut.init();
      expect(sut.claimableGifts, isEmpty);
      expect(sut.claimedGifts, isEmpty);
    });
    test('當 api 回應正常，預期回傳', () async {
      final fakeGiftBox = FakeGiftBox();
      arrangeApiReturnNormal(fakeGiftBox);
      await sut.init();
      expect(sut.claimableGifts, equals(fakeGiftBox.claimableGifts));
      expect(sut.claimedGifts, equals(fakeGiftBox.claimedGifts));
    });
  });
}
