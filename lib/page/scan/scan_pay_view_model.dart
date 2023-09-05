import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/page/scan/scan_pay_data.dart';
import 'package:x50pay/repository/repository.dart';

class ScanPayViewModel extends BaseViewModel {
  final String mid;
  final String cid;

  ScanPayViewModel(this.mid, this.cid);

  final _repo = Repository();
  late final bool hasLogined;
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
      hasLogined = doc.getElementsByClassName("ts-notice is-outlined").isEmpty;
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

  Future<ScanPayData> getScanPayData() async {
    late final String rawDoc;
    try {
      if (!kDebugMode || isForceFetch) {
        rawDoc = await Repository().getNFCPayDocument(x50PayUrl);
      } else {
        rawDoc =
            await rootBundle.loadString('assets/tests/scan_pay_x50pay.html');
      }
      final doc = parse(rawDoc);
      final imageUrl =
          doc.querySelector('body > div > a > div > img')!.attributes['src']!;
      final cabName =
          doc.querySelector('body > div > a > div > div')!.text.trim();
      final cabNum = doc
          .querySelector(
              'body > div > div.center.aligned.content > div > div > div.header > strong')!
          .text
          .trim()
          .split(' ')[1];
      final rawScript = doc.querySelectorAll("body > script")[3].text.trim();
      final rawModes = doc.querySelectorAll(
          "body > div > div.center.aligned.content > div > div > p");
      List<List<dynamic>> modes = [];
      for (var rawMode in rawModes) {
        final modeName = rawMode.text.trim();
        String pointPrice = '';
        String pointPayUrl = '';
        String ticketPayUrl = '';
        for (var rawButton
            in rawMode.nextElementSibling!.children.first.children) {
          String id = '';
          bool isPointBtn = false;

          id = "\"#${rawButton.attributes['id']!.split('-').first}\"";
          isPointBtn = rawButton.text.contains('P');
          if (isPointBtn) {
            pointPrice = rawButton.text.trim().replaceAll('P', '');
          }
          final url = rawScript
              .split(id)[1]
              .split(' });\n});')
              .first
              .split("\$.post(")[1]
              .split('\'')[1];
          if (isPointBtn) {
            pointPayUrl = url;
          } else {
            ticketPayUrl = url;
          }
        }

        modes.add([
          [pointPayUrl, ticketPayUrl],
          modeName,
          pointPrice,
        ]);
      }
      return ScanPayData(
        rawGameCabImageUrl: imageUrl,
        cabLabel: cabName,
        cabNum: int.parse(cabNum),
        mode: modes,
      );
    } on Exception catch (e) {
      log('', error: e, name: 'ScanPayViewModel.gameSelect');
      rethrow;
    }
  }
}
