import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:x50pay/common/models/entry/entry.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  test('fromJson 不觸發exception', () async {
    final rawJson = await readFixture('entry.json');
    expect(() => EntryModel.fromJson(json.decode(rawJson)), throwsNothing);
  });
}
