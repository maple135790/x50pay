import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/repository/repository.dart';

mixin NfcPadMixin {
  final _repo = Repository();

  Future<String> _getNfcPadDocument(String url) async {
    try {
      final response = await _repo.getDocument(url);
      if (response.statusCode != 200) {
        throw Exception('statusCode: ${response.statusCode}');
      }
      return response.body;
    } catch (e) {
      log('', error: e, name: 'NfcPadMixin._getNfcPadDocument');
      rethrow;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<String> _getNfcPadConfirmDocument(
    String internalUrl,
    String refererUrl,
  ) async {
    late final String doc;
    try {
      if (!kDebugMode) {
        doc = await _repo.getDocumentWithDomainPrefix(
          internalUrl,
          refererUrl,
          descLabel: '使用nfc pad 排隊api',
        );
      } else {
        doc = '平板點選確認';
      }
      return doc;
    } finally {
      EasyLoading.dismiss();
    }
  }

  void handleNfcPad(String padmid) async {
    final url = 'https://pay.x50.fun/nfcPad/byMid/$padmid';
    final rawDoc = await _getNfcPadDocument(url);
    final internalUrl =
        rawDoc.split('location.replace("').last.split('")').first;
    if (internalUrl.isEmpty) throw Exception('trueUrl is empty');
    final resultDoc = await _getNfcPadConfirmDocument(internalUrl, url);
    if (resultDoc.contains('平板點選確認')) {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
      EasyLoading.showSuccess('請於平板點選確認');
    }
  }
}
