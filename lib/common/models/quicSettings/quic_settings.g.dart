// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quic_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSettingsModel _$PaymentSettingsModelFromJson(
        Map<String, dynamic> json) =>
    PaymentSettingsModel(
      mtpMode: (json['mtpMode'] as num).toInt(),
      nfcAuto: json['nfcAuto'] as bool,
      nfcTicket: json['nfcTicket'] as bool,
      nfcTwo: json['nfcTwo'] as String,
      nfcSDVX: json['nfcSDVX'] as String,
      nfcNVSV: json['nfcNVSV'] as String,
      nfcQuic: json['nfcQuic'] as bool,
      nfcQlock: (json['nfcQlock'] as num).toInt(),
      aGV: json['aGV'] as bool,
    );

Map<String, dynamic> _$PaymentSettingsModelToJson(
        PaymentSettingsModel instance) =>
    <String, dynamic>{
      'mtpMode': instance.mtpMode,
      'nfcAuto': instance.nfcAuto,
      'nfcNVSV': instance.nfcNVSV,
      'nfcQlock': instance.nfcQlock,
      'nfcQuic': instance.nfcQuic,
      'nfcSDVX': instance.nfcSDVX,
      'nfcTicket': instance.nfcTicket,
      'nfcTwo': instance.nfcTwo,
      'aGV': instance.aGV,
    };
