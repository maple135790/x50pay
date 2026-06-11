// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quic_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSettingsModel _$PaymentSettingsModelFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('PaymentSettingsModel', json, ($checkedConvert) {
  final val = PaymentSettingsModel(
    mtpMode: $checkedConvert('mtpMode', (v) => (v as num).toInt()),
    nfcAuto: $checkedConvert('nfcAuto', (v) => v as bool),
    nfcTicket: $checkedConvert('nfcTicket', (v) => v as bool),
    nfcTwo: $checkedConvert('nfcTwo', (v) => v as String),
    nfcSDVX: $checkedConvert('nfcSDVX', (v) => v as String),
    nfcNVSV: $checkedConvert('nfcNVSV', (v) => v as String),
    nfcQuic: $checkedConvert('nfcQuic', (v) => v as bool),
    nfcQlock: $checkedConvert('nfcQlock', (v) => (v as num).toInt()),
    aGV: $checkedConvert('aGV', (v) => v as bool),
  );
  return val;
});

Map<String, dynamic> _$PaymentSettingsModelToJson(
  PaymentSettingsModel instance,
) => <String, dynamic>{
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
