// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quic_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuicSettingsModel _$QuicSettingsModelFromJson(Map<String, dynamic> json) =>
    QuicSettingsModel(
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
      'nfcAuto': instance.nfcAuto,
      'nfcTicket': instance.nfcTicket,
      'nfcTwo': instance.nfcTwo,
      'nfcSDVX': instance.nfcSDVX,
      'nfcNVSV': instance.nfcNVSV,
      'nfcQuic': instance.nfcQuic,
      'nfcQlock': instance.nfcQlock,
    };
