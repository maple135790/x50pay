import 'package:json_annotation/json_annotation.dart';
part 'gift_box.g.dart';

@JsonSerializable()
class GiftBoxModel {
  final int code;

  /// 已兌換的禮物列表
  @JsonKey(name: 'alchange')
  final List<AlChange> alChange;

  /// 可兌換的禮物列表
  @JsonKey(name: 'canchange')
  final List<CanChange> canChange;

  /// 禮物箱資料
  ///
  /// 用於禮物系統頁面
  const GiftBoxModel({
    required this.code,
    required this.alChange,
    required this.canChange,
  });

  const GiftBoxModel.empty()
      : code = 0,
        alChange = const [],
        canChange = const [];

  factory GiftBoxModel.fromJson(Map<String, dynamic> json) =>
      _$GiftBoxModelFromJson(json);

  Map<String, dynamic> toJson() => _$GiftBoxModelToJson(this);
}

@JsonSerializable()
class AlChange {
  final bool auto;
  final String chid;
  final String gid;
  final String name;
  final String pic;

  const AlChange(
      {required this.auto,
      required this.chid,
      required this.gid,
      required this.name,
      required this.pic});
  factory AlChange.fromJson(Map<String, dynamic> json) =>
      _$AlChangeFromJson(json);

  Map<String, dynamic> toJson() => _$AlChangeToJson(this);
}

@JsonSerializable()
class CanChange {
  final String chid;
  final String gid;
  final String name;
  final String pic;

  const CanChange(
      {required this.chid,
      required this.gid,
      required this.name,
      required this.pic});

  factory CanChange.fromJson(Map<String, dynamic> json) =>
      _$CanChangeFromJson(json);

  Map<String, dynamic> toJson() => _$CanChangeToJson(this);
}
