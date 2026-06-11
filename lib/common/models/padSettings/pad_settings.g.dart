// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pad_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PadSettingsModel _$PadSettingsModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PadSettingsModel', json, ($checkedConvert) {
      final val = PadSettingsModel(
        shcolor: $checkedConvert('shcolor', (v) => v as String),
        shid: $checkedConvert('shid', (v) => v as bool),
        shname: $checkedConvert('shname', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$PadSettingsModelToJson(PadSettingsModel instance) =>
    <String, dynamic>{
      'shcolor': instance.shcolor,
      'shid': instance.shid,
      'shname': instance.shname,
    };
