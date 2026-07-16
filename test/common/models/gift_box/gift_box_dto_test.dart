import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:x50pay/common/models/gift_box/gift_box_dto.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  test('fromJson 不觸發exception', () async {
    final rawJson = await readFixture('gitf_box_dto.json');
    expect(() => GiftBoxDTO.fromJson(json.decode(rawJson)), throwsNothing);
  });
}
