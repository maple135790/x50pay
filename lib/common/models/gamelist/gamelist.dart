import 'package:json_annotation/json_annotation.dart';

part 'gamelist.g.dart';

@JsonSerializable()
class Gamelist {
  final String? message;
  final int? code;
  @JsonKey(name: "machinelist")
  final List<MachineList>? machineList;
  // unknown
  final String? payMid;
  // unknown
  final String? payLid;
  // unknown
  final String? payCid;

  Gamelist({this.message, this.code, this.machineList, this.payMid, this.payLid, this.payCid});

  factory Gamelist.fromJson(Map<String, dynamic> json) => _$GamelistFromJson(json);

  Map<String, dynamic> toJson() => _$GamelistToJson(this);
}

@JsonSerializable()
class MachineList {
  final String? lable;
  final int? price;
  final num? discount;
  @JsonKey(name: "downprice")
  final dynamic downPrice;
  final List<List<dynamic>>? mode;
  final List<dynamic>? note;
  @JsonKey(name: "cabinet_detail")
  final Map<int, Map<String, dynamic>>? cabDatail;
  final int? cabinet;
  final bool? enable;
  final String? id;
  final String? shop;
  final bool? lora;
  final bool? pad;
  final String? padlid;
  final String? padmid;
  final List<int>? qcounter;
  final bool? quic;
  final bool? vipb;

  MachineList(
      this.lable,
      this.price,
      this.discount,
      this.downPrice,
      this.mode,
      this.note,
      this.cabDatail,
      this.cabinet,
      this.enable,
      this.id,
      this.shop,
      this.lora,
      this.pad,
      this.padlid,
      this.padmid,
      this.qcounter,
      this.quic,
      this.vipb);

  factory MachineList.fromJson(Map<String, dynamic> json) => _$MachineListFromJson(json);

  Map<String, dynamic> toJson() => _$MachineListToJson(this);
}
