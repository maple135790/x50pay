import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/api_response.dart';
import 'package:x50pay/common/models/avatar/avatar.dart';
import 'package:x50pay/page/home/dress_room/dress_room_view_model.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class MockRepository extends Mock implements MainRepository {}

class MockAvatar extends Mock implements Avatar {}

void main() {
  final mockRepo = MockRepository();
  late DressRoomViewModel sut;

  setUp(() {
    sut = DressRoomViewModel(repository: mockRepo);
  });

  void arrangeGetAvatarsReturnsNormal() {
    when(() => mockRepo.getAvatar()).thenAnswer((_) async {
      return ApiResponse.createSuccess([MockAvatar()]);
    });
  }

  void arrangeSetAvatarReturnsSuccess() {
    when(() => mockRepo.setAvatar(any())).thenAnswer((_) async {
      return ApiResponse.createSuccess(true);
    });
  }

  void arrangeSetAvatarReturnsFailed() {
    when(() => mockRepo.setAvatar(any())).thenAnswer((_) async {
      return ApiResponse.createFailed(false);
    });
  }

  test('測試取得Dress room 的Avatar', () async {
    arrangeGetAvatarsReturnsNormal();
    final avatars = await sut.getAvatars();
    expect(avatars, isNotEmpty);
  });
  test('當已有選擇id，設定時預期回傳正確', () async {
    sut.selectedId = "fakeId";
    arrangeGetAvatarsReturnsNormal();
    arrangeSetAvatarReturnsSuccess();
    final result = await sut.setAvatar();
    expect(result, isTrue);
  });
  test('當沒有選擇id，設定時預期回傳失敗', () async {
    sut.selectedId = null;
    arrangeGetAvatarsReturnsNormal();
    arrangeSetAvatarReturnsSuccess();
    final result = await sut.setAvatar();
    expect(result, isFalse);
  });
  test('當api回傳失敗，設定時預期回傳失敗', () async {
    sut.selectedId = null;
    arrangeGetAvatarsReturnsNormal();
    arrangeSetAvatarReturnsFailed();
    final result = await sut.setAvatar();
    expect(result, isFalse);
  });
}
