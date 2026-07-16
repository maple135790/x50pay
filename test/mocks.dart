import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/app_service_mixin.dart';

abstract class FackAppFeedback with AppFeedbackMixin {}

class MockFeedbackService extends Mock implements FackAppFeedback {}
