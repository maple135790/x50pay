import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class ScanPayViewModel extends BaseViewModel {
  final String mid;
  final String cid;

  ScanPayViewModel(this.mid, this.cid);

  final _repo = Repository();
  String _x50PayUrl = '';
  String _jkoPayUrl = '';
  String _linePayUrl = '';
  String get x50PayUrl => 'https://pay.x50.fun$_x50PayUrl';
  String get jkoPayUrl => _jkoPayUrl;
  String get linePayUrl => _linePayUrl;

  bool get isLinePayAvailable => _linePayUrl.startsWith('https');

  Future<bool> init() async {
    final url = 'https://pay.x50.fun/mid/$mid/$cid';
    await Future.delayed(const Duration(milliseconds: 350));
    late final String rawDocument;
    try {
      log('url: $url', name: 'ScanPayViewModel.init');
      if (!kDebugMode || isForceFetch) {
        final rawResponse = await _repo.getScanPayDocument(url);
        if (rawResponse.statusCode != 200) {
          throw Exception('statusCode: ${rawResponse.statusCode}');
        }
        rawDocument = const Utf8Decoder().convert(rawResponse.bodyBytes);
      } else {
        rawDocument = await rootBundle.loadString('assets/tests/scan_pay.html');
      }

      final doc = parse(rawDocument);
      final webButtons = doc.getElementsByClassName("ts-button is-fluid");
      _x50PayUrl = webButtons[0]
          .attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      _jkoPayUrl = webButtons[1]
          .attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      _linePayUrl = webButtons[2]
          .attributes['onclick']!
          .split('location.href=')
          .last
          .replaceAll("'", '');
      log('x50PayUrl: $x50PayUrl', name: 'ScanPayViewModel.init');
      log('jkoPayUrl: $jkoPayUrl', name: 'ScanPayViewModel.init');
      log('linePayUrl: $linePayUrl', name: 'ScanPayViewModel.init');
      return true;
    } on Exception catch (e) {
      log('', error: e, name: 'ScanPayViewModel.init');
      return false;
    } finally {}
  }
}
