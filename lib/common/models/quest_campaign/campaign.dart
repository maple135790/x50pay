import 'package:x50pay/common/models/quest_campaign/redeem_item.dart';

class Campaign {
  /// 網頁上的靜態圖片路徑
  /// 
  /// 若要顯示圖片，請使用 [campaignImageUrl]
  final String? rawImgUrl;

  /// 活動標題
  final String? campaignTitle;

  /// 活動截止日期
  final String? campaignGoodThruDate;

  /// 最低兌換點數
  final String? minQuestPoints;

  /// 點數說明
  /// 
  /// 例如：「已擁有 0 點，已兌換 0 點」
  final String? pointInfo;

  /// 活動可兌換的全部項目
  final List<RedeemItem>? redeemItems;

  /// 顯示的印章列數
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

  /// 活動圖片路徑
  String get campaignImageUrl => 'https://pay.x50.fun$rawImgUrl';

  int get ownedPoints =>
      int.tryParse(pointInfo
              ?.split(' , ')
              .first
              .split(' : ')
              .last
              .replaceAll(' 點', '') ??
          '') ??
      -1;

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
