import 'package:json_annotation/json_annotation.dart';

part 'bid.g.dart';

@JsonSerializable()
class BidLogModel {
  final int code;
  @JsonKey(name: 'log')
  final List<BidLog> logs;
  final String message;

  const BidLogModel({required this.code, required this.logs, required this.message});
  factory BidLogModel.fromJson(Map<String, dynamic> json) => _$BidLogModelFromJson(json);
  Map<String, dynamic> toJson() => _$BidLogModelToJson(this);
}

@JsonSerializable()
class BidLog {
  final double? point;
  @JsonKey(name: '3kcred')
  final bool? threekcred;
  final String? shop;
  final String? time;
  final String? uid;
  @JsonKey(name: '_id')
  final BidId? id;

  const BidLog({this.point, this.threekcred, this.shop, this.time, this.uid, this.id});

  factory BidLog.fromJson(Map<String, dynamic> json) => _$BidLogFromJson(json);
  Map<String, dynamic> toJson() => _$BidLogToJson(this);
}

@JsonSerializable()
class BidId {
  @JsonKey(name: '\$oid')
  final String oid;

  const BidId({required this.oid});

  factory BidId.fromJson(Map<String, dynamic> json) => _$BidIdFromJson(json);
  Map<String, dynamic> toJson() => _$BidIdToJson(this);
}
