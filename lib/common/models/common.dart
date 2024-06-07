import 'package:json_annotation/json_annotation.dart';

part "common.g.dart";

@JsonSerializable()
class InitTime {
  @JsonKey(name: '\$date')
  final String date;

  const InitTime({required this.date});

  factory InitTime.fromJson(Map<String, dynamic> json) =>
      _$InitTimeFromJson(json);
  Map<String, dynamic> tojson() => _$InitTimeToJson(this);
}

@JsonSerializable()
class UnderscoreId {
  @JsonKey(name: '\$oid')
  final String oid;

  const UnderscoreId({required this.oid});

  factory UnderscoreId.fromJson(Map<String, dynamic> json) =>
      _$UnderscoreIdFromJson(json);
  Map<String, dynamic> tojson() => _$UnderscoreIdToJson(this);
}
