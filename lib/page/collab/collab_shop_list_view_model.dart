import 'dart:developer';

import 'package:html/parser.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/repository/repository.dart';

class Sponser {
  final String? rawSponserImgUrl;
  final String sponserName;
  final String rawMeta;

  const Sponser({
    required this.rawSponserImgUrl,
    required this.sponserName,
    required this.rawMeta,
  });

  Sponser.empty()
      : rawSponserImgUrl = '',
        sponserName = '',
        rawMeta = '';

  String get sponserImgUrl => rawSponserImgUrl == null
      ? ''
      : rawSponserImgUrl!.startsWith('http')
          ? rawSponserImgUrl!
          : 'https://pay.x50.fun$rawSponserImgUrl';

  List<String> get meta =>
      rawMeta.trim().split('\n').map((e) => e.trim()).toList();
}

class CollabShopListViewModel extends BaseViewModel {
  final Repository repository;

  CollabShopListViewModel({required this.repository});

  Future<List<Sponser>> init() async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 350));
    late final String rawDocument;

    try {
      rawDocument = await repository.getSponserDocument();
      final document = parse(rawDocument);
      final rawSponserItems =
          document.querySelector('div > div.ts-menu.is-fluid')?.children ?? [];

      List<Sponser> sponsers = [];
      for (var rawItem in rawSponserItems) {
        final url = rawItem.querySelector("img")?.attributes['src'] ?? '';
        final sponserName = rawItem.getElementsByClassName('header').first.text;
        final rawMeta = rawItem.getElementsByClassName('meta').first.text;

        sponsers.add(Sponser(
          rawSponserImgUrl: url,
          sponserName: sponserName,
          rawMeta: rawMeta,
        ));
      }
      return sponsers;
    } catch (e) {
      log('', error: '$e', name: 'CollabShopList init');
      return [];
    } finally {
      dismissLoading();
    }
  }
}
