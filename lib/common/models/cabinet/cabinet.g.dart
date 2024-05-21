// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cabinet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CabinetModel _$CabinetModelFromJson(Map<String, dynamic> json) => CabinetModel(
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
      note: json['note'] as List<dynamic>,
      caboid: json['caboid'] as String,
      spic: (json['spic'] as List<dynamic>?)?.map((e) => e as String).toList(),
      surl: (json['surl'] as List<dynamic>?)?.map((e) => e as String).toList(),
      pad: json['pad'] as bool,
      padmid: json['padmid'] as String,
      padlid: json['padlid'] as String,
      cabinets: (json['cabinet'] as List<dynamic>)
          .map((e) => Cabinet.fromJson(e as Map<String, dynamic>))
          .toList(),
      reservations: (json['re'] as List<dynamic>)
          .map((e) => (e as List<dynamic>?)?.map((e) => e as String).toList())
          .toList(),
    );

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

Cabinet _$CabinetFromJson(Map<String, dynamic> json) => Cabinet(
      num: (json['num'] as num).toInt(),
      id: json['id'] as String,
      label: json['lable'] as String,
      mode: (json['mode'] as List<dynamic>)
          .map((e) => e as List<dynamic>)
          .toList(),
      card: json['card'] as bool,
      isBool: json['bool'] as bool,
      vipbool: json['vipbool'] as bool,
      notice: json['notice'] as String,
      busy: json['busy'] as String,
      nbusy: json['nbusy'] as String,
      pcl: json['pcl'] as bool,
    );

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
