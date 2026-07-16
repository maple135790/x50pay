import 'package:json_annotation/json_annotation.dart';

part 'grade_box_item.g.dart';

@JsonSerializable(createToJson: false)
class GradeBoxItem {
  /// 圖片網址
  @JsonKey(name: 'pic')
  final String rawPicUrl;

  /// 兌換活動編號
  @JsonKey(name: 'eid')
  final String eventId;

  final String filter;

  /// 兌換物品編號
  @JsonKey(name: 'gid')
  final String giftId;

  /// 物品兌換點數
  final int heart;

  /// 兌換次數限制
  final double limit;

  /// 兌換剩餘數量
  final int much;

  /// 兌換物品名稱
  final String name;

  /// 物品所在店鋪區域
  final String region;

  const GradeBoxItem(
    this.rawPicUrl,
    this.name,
    this.much,
    this.limit,
    this.giftId,
    this.eventId,
    this.heart,
    this.filter,
    this.region,
  );

  /// 物品資訊
  ///
  /// 例如：剩餘 12 份，可兌換 2 次
  String get info => '剩餘 $much 份，可兌換 ${limit.toInt()} 次';

  String get picUrl =>
      rawPicUrl.startsWith('/') ? 'https://pay.x50.fun$rawPicUrl' : rawPicUrl;

  factory GradeBoxItem.fromJson(Map<String, dynamic> json) =>
      _$GradeBoxItemFromJson(json);
}
