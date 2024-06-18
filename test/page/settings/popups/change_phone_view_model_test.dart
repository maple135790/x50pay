import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/page/settings/popups/change_phone_view_model.dart';
import 'package:x50pay/repository/setting_repository.dart';

abstract class Callable {
  void call();
}

class MockCallableCallback extends Mock implements Callable {}

class MockSettingRepository extends Mock implements SettingRepository {}

void main() {
  final settingRepo = MockSettingRepository();

  const fakeSuccessResponse = BasicResponse(
    code: 200,
    message: 'fake success, no api is called.',
  );

  const fakeSmsCodeInvalidResponse = BasicResponse(
    code: 700,
    message: 'fake invalid sms code, no api is called.',
  );

  const validPhone = '0912345678';
  const phoneTooLong = '09123456789';
  const phoneTooShort = '091234567';
  const fakeSmsCode = '123456';
  const invalidSmsCode = '12345';

  void arrangeChangePhoneReturnsValidResponse() {
    when(() => settingRepo.changePhone()).thenAnswer((_) async {
      return fakeSuccessResponse;
    });
  }

  void arrangeChangePhoneReturnsEmptyResponse() {
    when(() => settingRepo.changePhone()).thenAnswer((_) async {
      return BasicResponse.empty();
    });
  }

  void arrangeChangePhoneThrowsException() {
    when(() => settingRepo.changePhone()).thenThrow(Exception());
  }

  void arrangeDoChangePhoneReturnsValidResponse() {
    when(() => settingRepo.doChangePhone(phone: any(named: 'phone')))
        .thenAnswer((_) async {
      return fakeSuccessResponse;
    });
  }

  void arrangeDoChangePhoneReturnsEmptyResponse() {
    when(() => settingRepo.doChangePhone(phone: any(named: 'phone')))
        .thenAnswer((_) async {
      return BasicResponse.empty();
    });
  }

  void arrangeDoChangePhoneThrowsException() {
    when(() => settingRepo.doChangePhone(phone: any(named: 'phone')))
        .thenThrow(Exception());
  }

  void arrangeSmsActivateReturnsValidResponse() {
    when(() => settingRepo.smsActivate(sms: any(named: 'sms')))
        .thenAnswer((_) async {
      return fakeSuccessResponse;
    });
  }

  void arrangeSmsActivateReturnsEmptyResponse() {
    when(() => settingRepo.smsActivate(sms: any(named: 'sms')))
        .thenAnswer((_) async {
      return BasicResponse.empty();
    });
  }

  void arrangeSmsActivateReturnsInvalidSmsCodeResponse() {
    when(() => settingRepo.smsActivate(sms: any(named: 'sms')))
        .thenAnswer((_) async {
      return fakeSmsCodeInvalidResponse;
    });
  }

  void arrangeSmsActivateThrowsException() {
    when(() => settingRepo.smsActivate(sms: any(named: 'sms')))
        .thenThrow(Exception());
  }

  test('檢查手機號碼格式，若格式正確則沒有errorText，否則反之', () {
    final viewModel = ChangePhoneViewModel(settingRepo);
    final validFormat = viewModel.checkPhoneFormat(validPhone);
    expect(validFormat, isTrue);
    expect(viewModel.errorText, isNull);

    final invalidFormatTooLong = viewModel.checkPhoneFormat(phoneTooLong);
    expect(invalidFormatTooLong, isFalse);
    expect(viewModel.errorText, isNotNull);

    final invalidFormatTooShort = viewModel.checkPhoneFormat(phoneTooShort);
    expect(invalidFormatTooShort, isFalse);
    expect(viewModel.errorText, isNotNull);
  });

  group("測試解除綁定手機", () {
    test('當回傳正確格式，預期解除綁定', () async {
      arrangeChangePhoneReturnsValidResponse();
      final viewModel = ChangePhoneViewModel(settingRepo);
      final isRemoved = await viewModel.removePhone();
      expect(isRemoved, isTrue);
    });
    test('當回傳不正確格式，預期維持綁定', () async {
      arrangeChangePhoneReturnsEmptyResponse();
      final viewModel = ChangePhoneViewModel(settingRepo);
      final isEmptyResponseCausesRemove = await viewModel.removePhone();
      expect(isEmptyResponseCausesRemove, isFalse);

      arrangeChangePhoneThrowsException();
      final isExceptionCausesRemove = await viewModel.removePhone();
      expect(isExceptionCausesRemove, isFalse);
    });
  });

  group('測試變更手機號碼', () {
    late ChangePhoneViewModel viewModel;
    final mockOnChangeFailed = MockCallableCallback();
    final mockOnChangeSuccess = MockCallableCallback();
    setUp(() {
      viewModel = ChangePhoneViewModel(settingRepo);
    });

    test('當回傳正確格式，預期成功變更手機號碼', () async {
      arrangeDoChangePhoneReturnsValidResponse();
      await viewModel.changePhone(
        phone: validPhone,
        onChangeFailed: mockOnChangeFailed.call,
        onChangeSuccess: mockOnChangeSuccess.call,
      );
      verify(() => mockOnChangeSuccess.call()).called(1);
      verifyNever(() => mockOnChangeFailed.call());
      expect(viewModel.isSentSmsCode, isTrue);
    });

    test('當回傳不正確格式，預期無變更手機號碼', () async {
      arrangeDoChangePhoneReturnsEmptyResponse();
      await viewModel.changePhone(
        phone: validPhone,
        onChangeFailed: mockOnChangeFailed.call,
        onChangeSuccess: mockOnChangeSuccess.call,
      );

      verify(() => mockOnChangeFailed.call()).called(1);
      verifyNever(() => mockOnChangeSuccess.call());
      expect(viewModel.isSentSmsCode, isFalse);

      arrangeDoChangePhoneThrowsException();
      await viewModel.changePhone(
        phone: validPhone,
        onChangeFailed: mockOnChangeFailed.call,
        onChangeSuccess: mockOnChangeSuccess.call,
      );

      verify(() => mockOnChangeFailed.call()).called(1);
      verifyNever(() => mockOnChangeSuccess.call());
      expect(viewModel.isSentSmsCode, isFalse);
    });
  });

  group('測試驗證簡訊碼', () {
    late ChangePhoneViewModel viewModel;
    final mockOnActivateFailed = MockCallableCallback();
    final mockOnActivateSuccess = MockCallableCallback();
    setUp(() {
      viewModel = ChangePhoneViewModel(settingRepo);
    });
    test('當驗證碼長度不足6，預期顯示errorText', () async {
      await viewModel.smsActivate(
        smsCode: invalidSmsCode,
        onActivateFailed: mockOnActivateFailed.call,
        onActivateSuccess: mockOnActivateSuccess.call,
      );
      expect(viewModel.errorText, isNotNull);
      verifyNever(() => mockOnActivateFailed.call());
      verifyNever(() => mockOnActivateSuccess.call());
    });

    test('當驗證碼正確，預期呼叫 onActivateSuccess', () async {
      arrangeSmsActivateReturnsValidResponse();
      await viewModel.smsActivate(
        smsCode: fakeSmsCode,
        onActivateFailed: mockOnActivateFailed.call,
        onActivateSuccess: mockOnActivateSuccess.call,
      );
      verify(() => mockOnActivateSuccess.call()).called(1);
      verifyNever(() => mockOnActivateFailed.call());
    });

    test('當驗證碼輸入錯誤，預期皆不呼叫callback', () async {
      arrangeSmsActivateReturnsInvalidSmsCodeResponse();
      await viewModel.smsActivate(
        smsCode: fakeSmsCode,
        onActivateFailed: mockOnActivateFailed.call,
        onActivateSuccess: mockOnActivateSuccess.call,
      );
      verifyNever(() => mockOnActivateFailed.call());
      verifyNever(() => mockOnActivateSuccess.call());
    });

    test('當回傳格式錯誤，預期呼叫 onActivateFailed', () async {
      arrangeSmsActivateReturnsEmptyResponse();
      await viewModel.smsActivate(
        smsCode: fakeSmsCode,
        onActivateFailed: mockOnActivateFailed.call,
        onActivateSuccess: mockOnActivateSuccess.call,
      );
      verify(() => mockOnActivateFailed.call()).called(1);
      verifyNever(() => mockOnActivateSuccess.call());

      arrangeSmsActivateThrowsException();
      await viewModel.smsActivate(
        smsCode: fakeSmsCode,
        onActivateFailed: mockOnActivateFailed.call,
        onActivateSuccess: mockOnActivateSuccess.call,
      );
      verify(() => mockOnActivateFailed.call()).called(1);
      verifyNever(() => mockOnActivateSuccess.call());
    });
  });
}
