import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/common.dart';

part "tic_used.g.dart";

@JsonSerializable()
class TicUsedModel {
  final int code;
  final String message;
  @JsonKey(name: 'log')
  final List<TicUsedLog> logs;

  const TicUsedModel(
      {required this.code, required this.message, required this.logs});

  factory TicUsedModel.fromJson(Map<String, dynamic> json) =>
      _$TicUsedModelFromJson(json);
  Map<String, dynamic> toJson() => _$TicUsedModelToJson(this);
}

@JsonSerializable()
class TicUsedLog {
  final int cid;
  final bool disbool;
  final String mid;
  final double price;
  final String sid;
  final String ticn;
  final String time;
  final String uid;
  @JsonKey(name: '_id')
  final UnderscoreId underscoreId;

  const TicUsedLog(
      {required this.cid,
      required this.disbool,
      required this.mid,
      required this.price,
      required this.sid,
      required this.ticn,
      required this.time,
      required this.uid,
      required this.underscoreId});

  factory TicUsedLog.fromJson(Map<String, dynamic> json) =>
      _$TicUsedLogFromJson(json);
  Map<String, dynamic> toJson() => _$TicUsedLogToJson(this);
}
