import 'package:json_annotation/json_annotation.dart';

part 'cabinet.g.dart';

@JsonSerializable()
class CabinetModel {
  final String message;
  final int code;
  final List<dynamic> note;
  final String caboid;

  /// stream pic
  final List<String>? spic;

  /// stream url
  final List<String>? surl;
  final bool pad;
  final String padmid;
  final String padlid;
  @JsonKey(name: 'cabinet')
  final List<Cabinet> cabinets;
  @JsonKey(name: 're')
  final List<List<String>?> reservations;

  const CabinetModel(
      {required this.message,
      required this.code,
      required this.note,
      required this.caboid,
      this.spic,
      this.surl,
      required this.pad,
      required this.padmid,
      required this.padlid,
      required this.cabinets,
      required this.reservations});

  factory CabinetModel.fromJson(Map<String, dynamic> json) =>
      _$CabinetModelFromJson(json);
  Map<String, dynamic> toJson() => _$CabinetModelToJson(this);
}

@JsonSerializable()
class Cabinet {
  final int num;
  final String id;
  @JsonKey(name: 'lable')
  final String label;
  final List<List<dynamic>> mode;
  final bool card;
  @JsonKey(name: 'bool')
  final bool isBool;
  final bool vipbool;
  final String notice;
  final String busy;
  final String nbusy;
  final bool pcl;

  const Cabinet(
      {required this.num,
      required this.id,
      required this.label,
      required this.mode,
      required this.card,
      required this.isBool,
      required this.vipbool,
      required this.notice,
      required this.busy,
      required this.nbusy,
      required this.pcl});

  factory Cabinet.fromJson(Map<String, dynamic> json) =>
      _$CabinetFromJson(json);
  Map<String, dynamic> toJson() => _$CabinetToJson(this);

  const Cabinet.empty()
      : num = 0,
        id = '',
        label = '',
        mode = const [],
        card = false,
        isBool = false,
        vipbool = false,
        notice = '',
        busy = '',
        nbusy = '',
        pcl = false;

  @override
  String toString() {
    return """Cabinet(num: $num, id: $id, label: $label, mode: $mode, card: $card, isBool: $isBool, vipbool: $vipbool, notice: $notice, busy: $busy, nbusy: $nbusy, pcl: $pcl)\n""";
  }
}
