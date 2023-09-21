import 'dart:convert';
import 'dart:typed_data';

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
  @JsonKey(name: 'rqc')
  final List<QuestCampaign>? questCampaign;

  /// 首頁所使用的資料
  const EntryModel({
    required this.message,
    required this.code,
    required this.gr2,
    this.evlist,
    this.giftlist,
    this.questCampaign,
  });

  factory EntryModel.fromJson(Map<String, dynamic> json) =>
      _$EntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$EntryModelToJson(this);

  String get gradeLv => gr2[0].toString();
  String get gr2HowMuch => gr2[1].toInt().toString();
  String get gr2Limit => gr2[2].toInt().toString();
  String get gr2Next => gr2[3].toString();
  String get gr2Day => gr2[4].toString().replaceAll('天', '');
  String get gr2Date => gr2[5].toString();
  String get gr2GradeBoxContent => gr2[6].toString();
  String get _rawAva => gr2[7].toString().split(',').last;
  bool get gr2ShouldShowBouns => gr2[8];
  String get gr2VDay => gr2[9].toString();
  String get gr2BounsLimit => gr2[10].toString();
  String get gr2Timer => double.parse(gr2[12].toString()).toStringAsFixed(0);
  String get gr2CountMuch => gr2[13].toString();
  double get gr2ProgressV5 => gr2[13] / gr2[1];
  double get gr2Progress => gr2[0] / 15;
  Uint8List get ava => base64Decode(_rawAva);
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

  factory GiftList.fromJson(Map<String, dynamic> json) =>
      _$GiftListFromJson(json);
  Map<String, dynamic> toJson() => _$GiftListToJson(this);
}

@JsonSerializable()
class EventTime {
  @JsonKey(name: '\$date')
  final int date;

  const EventTime({required this.date});

  factory EventTime.fromJson(Map<String, dynamic> json) =>
      _$EventTimeFromJson(json);
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

  factory EntryHistory.fromJson(Map<String, dynamic> json) =>
      _$EntryHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$EntryHistoryToJson(this);
}

@JsonSerializable()
class QuestCampaign {
  @JsonKey(name: 'couid')
  final String rawCouid;
  @JsonKey(name: 'lpic')
  final String rawLpic;
  final bool lpicshow;
  final List<String> mid;
  final String spic;
  @JsonKey(name: '_id')
  final UnderscoreId? underscoreId;

  QuestCampaign({
    required this.rawCouid,
    required this.rawLpic,
    required this.lpicshow,
    required this.mid,
    required this.spic,
    required this.underscoreId,
  });

  factory QuestCampaign.fromJson(Map<String, dynamic> json) =>
      _$QuestCampaignFromJson(json);
  Map<String, dynamic> toJson() => _$QuestCampaignToJson(this);

  String get lpic => "https://pay.x50.fun$rawLpic";
  String get couid =>
      rawCouid.contains('\'') ? rawCouid.replaceAll('\'', '') : rawCouid;
}
