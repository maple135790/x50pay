import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:x50pay/common/models/user/user.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  test('fromJson 不觸發exception', () async {
    final rawJson = await readFixture('user.json');
    expect(() => UserModel.fromJson(json.decode(rawJson)), throwsNothing);
  });
}
