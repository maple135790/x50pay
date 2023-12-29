class RedeemItem {
  /// 物品ID
  final String id;

  /// 商品圖片
  final String rawImgUrl;

  /// 商品名稱
  final String name;

  /// 所需點數
  final int points;

  /// 額外資訊, 例如: 本日剩餘, 期間剩餘, 今日存量, 活動存量
  final List<String>? rawExtra;

  /// 近期被兌換時間
  final List<String>? recentRedeemTime;

  const RedeemItem({
    required this.id,
    required this.rawImgUrl,
    required this.name,
    required this.points,
    required this.rawExtra,
    required this.recentRedeemTime,
  });

  @override
  String toString() {
    return 'RedeemItem(id: $id, rawImgUrl: $rawImgUrl, name: $name, points: $points, rawExtra: $rawExtra, recentRedeemTime: $recentRedeemTime)';
  }

  List<String> get extra => ["所需點數 $points 點", ...rawExtra ?? []];
  String get imgUrl => 'https://pay.x50.fun$rawImgUrl';
}
