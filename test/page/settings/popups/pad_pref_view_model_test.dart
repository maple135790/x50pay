import 'dart:convert';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/page/settings/popups/pad_pref_view_model.dart';
import 'package:x50pay/repository/setting_repository.dart';

abstract class Callable {
  void call();
}

class MockCallableCallback extends Mock implements Callable {}

class MockSettingRepository extends Mock implements SettingRepository {}

final mockRepo = MockSettingRepository();

void main() {
  setUp(() {
    when(() => mockRepo.getPadSettings()).thenAnswer(
      (_) async {
        const rawJson =
            r'''{"shid": true, "shcolor": "#123456", "shname": "test"} ''';
        return PadSettingsModel.fromJson(jsonDecode(rawJson));
      },
    );
    when(() => mockRepo.setPadSettings(
          shname: any(named: 'shname'),
          shid: any(named: 'shid'),
          shcolor: any(named: 'shcolor'),
        )).thenAnswer(
      (_) async {
        const rawJson =
            r'''{"shid": true, "shcolor": "#123456", "shname": "test"} ''';

        return Response(rawJson, 200);
      },
    );
  });

  test('測試取得排隊平板設定', () async {
    final viewModel = PadPrefsViewModel(mockRepo);
    await viewModel.getPadSettings();
    final name = viewModel.nickname;
    final color = viewModel.showColor;
    final isHidden = viewModel.isNameHidden;

    expect(name, isNotEmpty);
    expect(color, isNot(PadPrefsViewModel.defaultColor));
    expect(isHidden, isTrue);
  });

  group('測試設定排隊平板偏好', () {
    final viewModel = PadPrefsViewModel(mockRepo)
      ..onIsNameShownChanged(true)
      ..onShowColorChanged(const Color(0xFF654321));

    final onNotSetMock = MockCallableCallback();
    final onSetMock = MockCallableCallback();

    test('不允許的暱稱', () async {
      const forbiddenName = '1234567890123456789012345678901234567890';
      viewModel.onNicknameChanged(forbiddenName);
      expect(viewModel.nickname, forbiddenName);
      await viewModel.setPadSettings(
        onNotSet: onNotSetMock.call,
        onSet: onSetMock.call,
      );

      verify(() => onNotSetMock.call()).called(1);
      verifyNever(() => onSetMock.call());
    });

    test('允許的暱稱', () async {
      const acceptableName = 'name';
      when(() => mockRepo.getPadSettings()).thenAnswer(
        (_) async {
          const rawJson =
              '''{"shid": true, "shcolor": "#123456", "shname": "$acceptableName"} ''';
          return PadSettingsModel.fromJson(jsonDecode(rawJson));
        },
      );

      viewModel.onNicknameChanged(acceptableName);
      expect(viewModel.nickname, acceptableName);
      await viewModel.setPadSettings(
        onNotSet: onNotSetMock.call,
        onSet: onSetMock.call,
      );

      verify(() => onSetMock.call()).called(1);
      verifyNever(() => onNotSetMock.call());
    });
  });

  test('測試顏色hex轉換', () async {
    final viewModel = PadPrefsViewModel(mockRepo);
    const color = Color(0xFF123456);
    final convertedHex = viewModel.convertColorToHex(color);
    expect(convertedHex, '#123456');
    final convertedColor = viewModel.convertHexToColor(convertedHex);
    expect(convertedColor, color);
  });
}
