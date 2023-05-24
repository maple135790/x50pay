import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/common.dart';

part "entry.g.dart";

@JsonSerializable()
class EntryModel {
  final String message;
  final int code;
  final List<dynamic> gr2;
  final List<Evlist>? evlist;
  final GiftList? giftlist;

  const EntryModel(
      {required this.message,
      required this.code,
      required this.gr2,
      this.evlist,
      this.giftlist});

  factory EntryModel.fromJson(Map<String, dynamic> json) => _$EntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$EntryModelToJson(this);
}

@JsonSerializable()
class Evlist {
  final String? count;
  final String? countday;
  final String? describe;
  final EventTime? end;
  final String? id;
  final int? limit;
  final String? name;
  final bool? point;
  final String? sid;
  final EventTime? start;
  final List? ticMid;
  final String? ticdis;
  final int? value;
  final List<dynamic>? which;
  @JsonKey(name: '_id')
  final UnderscoreId? underscoreId;

  const Evlist(
      {this.count,
      this.countday,
      this.describe,
      this.end,
      this.id,
      this.limit,
      this.name,
      this.point,
      this.sid,
      this.start,
      this.ticMid,
      this.ticdis,
      this.value,
      this.which,
      this.underscoreId});

  factory Evlist.fromJson(Map<String, dynamic> json) => _$EvlistFromJson(json);
  Map<String, dynamic> toJson() => _$EvlistToJson(this);
}

@JsonSerializable()
class GiftList {
  final bool? gift;

  const GiftList({this.gift});

  factory GiftList.fromJson(Map<String, dynamic> json) => _$GiftListFromJson(json);
  Map<String, dynamic> toJson() => _$GiftListToJson(this);
}

@JsonSerializable()
class EventTime {
  @JsonKey(name: '\$date')
  final int date;

  const EventTime({required this.date});

  factory EventTime.fromJson(Map<String, dynamic> json) => _$EventTimeFromJson(json);
  Map<String, dynamic> toJson() => _$EventTimeToJson(this);
}

@JsonSerializable()
class EntryHistory {
  final int? cid;
  final bool? disbool;
  final bool? done;
  final double? freep;
  final InitTime? inittime;
  final String? mid;
  final String? ticn;
  final double? price;
  final String? sid;
  final String? status;
  final String? time;
  final String? uid;
  @JsonKey(name: '_id')
  final UnderscoreId? underscoreId;

  const EntryHistory(
      {this.cid,
      this.disbool,
      this.done,
      this.freep,
      this.inittime,
      this.mid,
      this.ticn,
      this.price,
      this.sid,
      this.status,
      this.time,
      this.uid,
      this.underscoreId});

  factory EntryHistory.fromJson(Map<String, dynamic> json) => _$EntryHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryHistoryToJson(this);
}
