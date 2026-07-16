import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html;
import 'package:x50pay/repository/main_repository/main_repository.dart';

class Sponser {
  final String? rawSponserImgUrl;
  final String sponserName;
  final String rawMeta;

  const Sponser({
    required this.rawSponserImgUrl,
    required this.sponserName,
    required this.rawMeta,
  });

  String get sponserImgUrl => rawSponserImgUrl == null
      ? ''
      : rawSponserImgUrl!.startsWith('http')
      ? rawSponserImgUrl!
      : 'https://pay.x50.fun$rawSponserImgUrl';

  List<String> get meta =>
      rawMeta.trim().split('\n').map((e) => e.trim()).toList();
}

class CollabShopListViewModel extends ChangeNotifier {
  final MainRepository _repository;

  CollabShopListViewModel({required this._repository});

  Future<List<Sponser>> init() async {
    try {
      final rawDocument = await _repository.getSponserDocument();
      final document = html.parse(rawDocument);
      final rawSponserItems = document
          .querySelector('#spon > div.ts-menu.is-fluid')
          ?.children;

      if (rawSponserItems == null || rawSponserItems.isEmpty) return [];

      final sponsers = <Sponser>[];
      for (var rawItem in rawSponserItems) {
        final url = rawItem.querySelector("img")?.attributes['src'] ?? '';
        final sponserName = rawItem.getElementsByClassName('header').first.text;
        final rawMeta = rawItem.getElementsByClassName('meta').first.text;

        sponsers.add(
          Sponser(
            rawSponserImgUrl: url,
            sponserName: sponserName,
            rawMeta: rawMeta,
          ),
        );
      }
      return sponsers;
    } catch (e) {
      log('', error: '$e', name: 'CollabShopList init');
      return [];
    }
  }
}
