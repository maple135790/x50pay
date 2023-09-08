import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/common.dart';

part 'free_p.g.dart';

@JsonSerializable()
class FreePModel {
  final int code;
  final String message;
  @JsonKey(name: 'log')
  final List<FreePLog> logs;

  const FreePModel(
      {required this.code, required this.message, required this.logs});

  factory FreePModel.fromJson(Map<String, dynamic> json) =>
      _$FreePModelFromJson(json);
  Map<String, dynamic> toJson() => _$FreePModelToJson(this);
}

@JsonSerializable()
class FreePLog {
  @JsonKey(name: 'limittime')
  final String limitTime;
  final double fpoint;
  final double much;
  final bool expire;
  final String uid;
  @JsonKey(name: '_id')
  final UnderscoreId id;

  const FreePLog(
      {required this.limitTime,
      required this.uid,
      required this.expire,
      required this.fpoint,
      required this.much,
      required this.id});

  factory FreePLog.fromJson(Map<String, dynamic> json) =>
      _$FreePLogFromJson(json);
  Map<String, dynamic> toJson() => _$FreePLogToJson(this);
}
