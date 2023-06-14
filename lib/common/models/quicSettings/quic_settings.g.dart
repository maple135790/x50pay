// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quic_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuicSettingsModel _$QuicSettingsModelFromJson(Map<String, dynamic> json) =>
    QuicSettingsModel(
      mtpMode: json['mtpMode'] as int,
      nfcAuto: json['nfcAuto'] as bool,
      nfcTicket: json['nfcTicket'] as bool,
      nfcTwo: json['nfcTwo'] as String,
      nfcSDVX: json['nfcSDVX'] as String,
      nfcNVSV: json['nfcNVSV'] as String,
      nfcQuic: json['nfcQuic'] as bool,
      nfcQlock: json['nfcQlock'] as int,
    );

Map<String, dynamic> _$QuicSettingsModelToJson(QuicSettingsModel instance) =>
    <String, dynamic>{
      'mtpMode': instance.mtpMode,
      'nfcAuto': instance.nfcAuto,
      'nfcNVSV': instance.nfcNVSV,
      'nfcQlock': instance.nfcQlock,
      'nfcQuic': instance.nfcQuic,
      'nfcSDVX': instance.nfcSDVX,
      'nfcTicket': instance.nfcTicket,
      'nfcTwo': instance.nfcTwo,
    };
