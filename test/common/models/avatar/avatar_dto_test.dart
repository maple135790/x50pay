import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:x50pay/common/models/avatar/avatar_dto.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  test('fromJson 不觸發exception', () async {
    final rawJson = await readFixture('avatar.json');
    expect(() => AvatarDTO.fromJson(json.decode(rawJson)), throwsNothing);
  });
}
