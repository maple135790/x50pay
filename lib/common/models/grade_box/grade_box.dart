import 'package:json_annotation/json_annotation.dart';

part 'grade_box.g.dart';

/// 養成商城
@JsonSerializable()
class GradeBoxModel {
  final List<GradeBoxItem?> card;
  final List<GradeBoxItem?> cd;
  final List<GradeBoxItem?> x50;
  final List<GradeBoxItem?> gifts;
  final int code;

  const GradeBoxModel({
    required this.card,
    required this.cd,
    required this.x50,
    required this.gifts,
    required this.code,
  });

  const GradeBoxModel.empty()
      : card = const [],
        cd = const [],
        x50 = const [],
        gifts = const [],
        code = 0;

  /// 所有兌換物品
  ///
  /// 用於 `全部` 頁面展示用
  List<GradeBoxItem?> get all => [...gifts, ...cd, ...x50, ...card];

  factory GradeBoxModel.fromJson(Map<String, dynamic> json) =>
      _$GradeBoxModelFromJson(json);
  Map<String, dynamic> toJson() => _$GradeBoxModelToJson(this);
}

@JsonSerializable()
class GradeBoxItem {
  /// 圖片網址
  @JsonKey(name: 'pic')
  final String rawPicUrl;

  /// 兌換物品名稱
  final String name;

  /// 兌換剩餘數量
  final int much;

  /// 兌換次數限制
  final double limit;

  /// 兌換物品編號
  final String gid;

  /// 兌換活動編號
  final String eid;

  /// 物品兌換點數
  final int heart;

  const GradeBoxItem({
    required this.rawPicUrl,
    required this.name,
    required this.much,
    required this.limit,
    required this.gid,
    required this.eid,
    required this.heart,
  });

  /// 物品資訊
  ///
  /// 例如：剩餘 12 份，可兌換 2 次
  String get info => '剩餘 $much 份，可兌換 ${limit.toInt()} 次';

  String get picUrl =>
      rawPicUrl.startsWith('/') ? 'https://pay.x50.fun$rawPicUrl' : rawPicUrl;

  factory GradeBoxItem.fromJson(Map<String, dynamic> json) =>
      _$GradeBoxItemFromJson(json);
  Map<String, dynamic> toJson() => _$GradeBoxItemToJson(this);

  factory GradeBoxItem.empty() => const GradeBoxItem(
        rawPicUrl: '',
        name: '',
        much: 0,
        limit: 0,
        gid: '',
        eid: '',
        heart: 0,
      );
}
