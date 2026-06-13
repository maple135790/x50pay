// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CabinetModel _$CabinetModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CabinetModel', json, ($checkedConvert) {
      final val = CabinetModel(
        message: $checkedConvert('message', (v) => v as String),
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        note: $checkedConvert('note', (v) => v as List<dynamic>),
        caboid: $checkedConvert('caboid', (v) => v as String),
        spic: $checkedConvert(
          'spic',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        surl: $checkedConvert(
          'surl',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        pad: $checkedConvert('pad', (v) => v as bool),
        padmid: $checkedConvert('padmid', (v) => v as String),
        padlid: $checkedConvert('padlid', (v) => v as String),
        cabinets: $checkedConvert(
          'cabinet',
          (v) => (v as List<dynamic>)
              .map((e) => Cabinet.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        reservations: $checkedConvert(
          're',
          (v) => (v as List<dynamic>)
              .map(
                (e) => (e as List<dynamic>?)?.map((e) => e as String).toList(),
              )
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'cabinets': 'cabinet', 'reservations': 're'});

Map<String, dynamic> _$CabinetModelToJson(CabinetModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'note': instance.note,
      'caboid': instance.caboid,
      'spic': instance.spic,
      'surl': instance.surl,
      'pad': instance.pad,
      'padmid': instance.padmid,
      'padlid': instance.padlid,
      'cabinet': instance.cabinets,
      're': instance.reservations,
    };

Cabinet _$CabinetFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Cabinet', json, ($checkedConvert) {
      final val = Cabinet(
        num: $checkedConvert('num', (v) => (v as num).toInt()),
        id: $checkedConvert('id', (v) => v as String),
        label: $checkedConvert('lable', (v) => v as String),
        mode: $checkedConvert(
          'mode',
          (v) => (v as List<dynamic>).map((e) => e as List<dynamic>).toList(),
        ),
        card: $checkedConvert('card', (v) => v as bool),
        isBool: $checkedConvert('bool', (v) => v as bool),
        vipbool: $checkedConvert('vipbool', (v) => v as bool),
        notice: $checkedConvert('notice', (v) => v as String),
        busy: $checkedConvert('busy', (v) => v as String),
        nbusy: $checkedConvert('nbusy', (v) => v as String),
        pcl: $checkedConvert('pcl', (v) => v as bool),
      );
      return val;
    }, fieldKeyMap: const {'label': 'lable', 'isBool': 'bool'});

Map<String, dynamic> _$CabinetToJson(Cabinet instance) => <String, dynamic>{
  'num': instance.num,
  'id': instance.id,
  'lable': instance.label,
  'mode': instance.mode,
  'card': instance.card,
  'bool': instance.isBool,
  'vipbool': instance.vipbool,
  'notice': instance.notice,
  'busy': instance.busy,
  'nbusy': instance.nbusy,
  'pcl': instance.pcl,
};
