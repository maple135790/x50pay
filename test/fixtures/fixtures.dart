import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

Future<String> readFixture(String filename) async {
  try {
    final file = File(
      p.join(Directory.current.path, 'test', 'fixtures', filename),
    );
    return await file.readAsString();
  } catch (e) {
    // ignore: avoid_print
    print('Error reading fixture $filename: $e');
    rethrow;
  }
}

Matcher get throwsNothing => isNot(throwsA(anything));
