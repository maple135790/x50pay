import 'package:json_annotation/json_annotation.dart';

part 'quic_settings.g.dart';

@JsonSerializable()
class QuicSettingsModel {
  final int mtpMode;
  final bool nfcAuto;
  final String nfcNVSV;
  final int nfcQlock;
  final bool nfcQuic;
  final String nfcSDVX;
  final bool nfcTicket;
  final String nfcTwo;

  const QuicSettingsModel({
    required this.mtpMode,
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
