import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:x50pay/common/models/grade_background/grade_background_dto.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  test('fromJson 不觸發exception', () async {
    final rawJson = await readFixture('background_list.json');
    expect(
      () => GradeBackgroundDTO.fromJson(json.decode(rawJson)),
      throwsNothing,
    );
  });
}
