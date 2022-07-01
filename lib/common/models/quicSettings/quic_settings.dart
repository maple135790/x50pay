import 'package:json_annotation/json_annotation.dart';

part 'quic_settings.g.dart';

@JsonSerializable()
class QuicSettingsModel {
  final bool nfcAuto;
  final bool nfcTicket;
  final String nfcTwo;
  final String nfcSDVX;
  final String nfcNVSV;
  final bool nfcQuic;
  final int nfcQlock;

  const QuicSettingsModel({
    required this.nfcAuto,
    required this.nfcTicket,
    required this.nfcTwo,
    required this.nfcSDVX,
    required this.nfcNVSV,
    required this.nfcQuic,
    required this.nfcQlock,
  });

  factory QuicSettingsModel.fromJson(Map<String, dynamic> json) => _$QuicSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuicSettingsModelToJson(this);
}
