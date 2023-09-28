import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/quest_campaign/campaign.dart';
import 'package:x50pay/common/models/quest_campaign/redeem_item.dart';
import 'package:x50pay/repository/repository.dart';

class QuestCampaignViewModel extends BaseViewModel {
  final Repository repository;

  QuestCampaignViewModel({required this.repository});

  Future<Campaign?> init({required String campaignId}) async {
    showLoading();
    await Future.delayed(const Duration(milliseconds: 100));

    late final String rawDocument;
    try {
      rawDocument = await repository.getCampaignDocument(campaignId);

      final document = parse(rawDocument);

      final imgUrl = document
          .querySelector('div > div> div.ts-image > img')
          ?.attributes['src'];
      final campaignTitle = document
          .querySelector('div > div> div.ts-mask.is-bottom > div > div')
          ?.text;
      final campaignItem = document
          .querySelector(
              'div > div> div.ts-mask.is-bottom > div > div.ts-header.is-gameinfo')
          ?.text
          .trim()
          .replaceAll('\t', '')
          .replaceAll('\n', '')
          .split(' ')
          .toSet();
      final stampRowCounts =
          document.getElementsByClassName('ts-row is-evenly-divided').length;
      final pointInfo = document.querySelector('div > center')!.text;
      final items = document
          .querySelectorAll('div > div')
          .sublist(4)
          .where((element) => element.className == 'ts-box')
          .toList();

      final campaign = Campaign(
        rawImgUrl: imgUrl,
        campaignTitle: campaignTitle,
        campaignGoodThruDate: campaignItem?.first,
        minQuestPoints: campaignItem?.last,
        pointInfo: pointInfo,
        redeemItems: items
            .map((e) => RedeemItem(
                  rawImgUrl: e
                          .querySelector('div > div > div> div > img')
                          ?.attributes['src'] ??
                      '',
                  name: e
                          .querySelector(
                              'div.column.is-fluid.content > div.header')
                          ?.text ??
                      '',
                  points: int.parse(e
                          .querySelector(
                              'div > div > div.column.is-fluid.content > div.meta > div')
                          ?.text
                          .split(' ')[1] ??
                      '0'),
                  rawExtra: e.nextElementSibling
                      ?.querySelector(
                          'div > div.ts-content.is-center-aligned.is-vertically-padded > div.ts-box.is-horizontal > div.ts-content > p')
                      ?.text
                      .replaceAll("  ", "")
                      .trim()
                      .split('\n')
                      .sublist(1),
                  recentRedeemTime: e.nextElementSibling
                      ?.querySelectorAll(
                          "div > div.ts-content.is-center-aligned.is-vertically-padded > center")
                      .map((e) => e.text)
                      .toList(),
                ))
            .toList(),
        stampRowCounts: stampRowCounts,
      );
      return campaign;
    } catch (e) {
      log('', error: e.toString(), name: 'QuestCampaignViewModel');
      return null;
    } finally {
      dismissLoading();
    }
  }

  Future<void> onAddStampRowTap({required String campaignId}) async {
    if (!kDebugMode || isForceFetch) repository.addCampaignStampRow(campaignId);
    return;
  }
}
