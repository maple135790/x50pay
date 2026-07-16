import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/app_service_mixin.dart';

abstract class FackAppFeedback with AppFeedbackMixin {}

class MockFeedbackService extends Mock implements FackAppFeedback {}

void arrangeSuccessFeedbackReturnsNormal(MockFeedbackService mockFeedback) {
  when(() => mockFeedback.showLoading()).thenAnswer((_) => Future.value());
  when(() => mockFeedback.dismissLoading()).thenAnswer((_) => Future.value());
  when(() => mockFeedback.showSuccess(any())).thenAnswer((_) => Future.value());
}
