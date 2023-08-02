import 'package:x50pay/common/models/quest_campaign/redeem_item.dart';

class Campaign {
  final String? rawImgUrl;
  final String? campaignTitle;
  final String? campaignGoodThruDate;
  final String? minQuestPoints;
  final String? pointInfo;
  final List<RedeemItem>? redeemItems;
  final int? stampRowCounts;

  const Campaign({
    required this.rawImgUrl,
    required this.campaignTitle,
    required this.campaignGoodThruDate,
    required this.minQuestPoints,
    required this.pointInfo,
    required this.redeemItems,
    required this.stampRowCounts,
  });

  String get campaignImageUrl => 'https://pay.x50.fun$rawImgUrl';

  @override
  String toString() {
    return 'Campaign{rawImgUrl: $rawImgUrl, campaignTitle: $campaignTitle, campaignGoodThruDate: $campaignGoodThruDate, minQuestPoints: $minQuestPoints, pointInfo: $pointInfo, redeemItems: $redeemItems, stampRowCounts: $stampRowCounts}';
  }

  Campaign.empty()
      : rawImgUrl = '',
        campaignTitle = '',
        campaignGoodThruDate = '',
        minQuestPoints = '',
        pointInfo = '',
        stampRowCounts = 0,
        redeemItems = const [];
}
