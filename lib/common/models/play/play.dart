import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/common.dart';

part 'play.g.dart';

@JsonSerializable()
class PlayRecordModel {
  final int code;
  final String message;
  @JsonKey(name: 'log')
  final List<PlayLog> logs;

  const PlayRecordModel(
      {required this.code, required this.message, required this.logs});

  factory PlayRecordModel.fromJson(Map<String, dynamic> json) =>
      _$PlayRecordModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlayRecordModelToJson(this);
}

@JsonSerializable()
class PlayLog {
  final int cid;
  final bool disbool;
  final bool done;
  final double freep;
  @JsonKey(name: 'inittime')
  final InitTime initTime;
  final String mid;
  final double price;
  final String sid;
  final String status;
  final String time;
  final String uid;
  @JsonKey(name: '_id')
  final UnderscoreId id;

  const PlayLog(
      {required this.cid,
      required this.disbool,
      required this.done,
      required this.freep,
      required this.initTime,
      required this.mid,
      required this.price,
      required this.sid,
      required this.status,
      required this.time,
      required this.uid,
      required this.id});

  factory PlayLog.fromJson(Map<String, dynamic> json) =>
      _$PlayLogFromJson(json);
  Map<String, dynamic> toJson() => _$PlayLogToJson(this);
}
