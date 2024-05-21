import 'package:json_annotation/json_annotation.dart';

part 'gamelist.g.dart';

@JsonSerializable()
class GameList {
  final String? message;
  final int? code;
  @JsonKey(name: "machinelist")
  final List<Machine>? machines;
  final String? payMid;
  final String? payLid;
  final String? payCid;

  const GameList(
      {this.message,
      this.code,
      this.machines,
      this.payMid,
      this.payLid,
      this.payCid});

  const GameList.empty()
      : message = '',
        code = 0,
        machines = const [],
        payMid = '',
        payLid = '',
        payCid = '';

  factory GameList.fromJson(Map<String, dynamic> json) =>
      _$GameListFromJson(json);

  Map<String, dynamic> toJson() => _$GameListToJson(this);
}

@JsonSerializable()
class Machine {
  final String? lable;
  final double? price;
  final num? discount;
  @JsonKey(name: "downprice")
  final dynamic downPrice;
  final List<List<dynamic>>? mode;
  final List<dynamic>? note;
  @JsonKey(name: "cabinet_detail")
  final Map<String, Map<String, dynamic>>? cabDatail;
  final num? cabinet;
  final bool? enable;
  final String? id;
  final String? shop;
  final bool? lora;
  final bool? pad;
  final String? padlid;
  final String? padmid;
  final List<double>? qcounter;
  final bool? quic;
  final bool? vipb;

  const Machine(
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
    this.vipb,
  );

  factory Machine.fromJson(Map<String, dynamic> json) =>
      _$MachineFromJson(json);

  Map<String, dynamic> toJson() => _$MachineToJson(this);

  String get storeId => shop ?? 'null storeId';
}
