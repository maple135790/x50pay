// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_p.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreePointModel _$FreePointModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FreePointModel', json, ($checkedConvert) {
      final val = FreePointModel(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        message: $checkedConvert('message', (v) => v as String),
        logs: $checkedConvert(
          'log',
          (v) => (v as List<dynamic>)
              .map((e) => FreePLog.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'logs': 'log'});

Map<String, dynamic> _$FreePointModelToJson(FreePointModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'log': instance.logs,
    };

FreePLog _$FreePLogFromJson(Map<String, dynamic> json) =>
    $checkedCreate('FreePLog', json, ($checkedConvert) {
      final val = FreePLog(
        limitTime: $checkedConvert('limittime', (v) => v as String),
        uid: $checkedConvert('uid', (v) => v as String),
        expire: $checkedConvert('expire', (v) => v as bool),
        fpoint: $checkedConvert('fpoint', (v) => (v as num).toDouble()),
        much: $checkedConvert('much', (v) => (v as num).toDouble()),
        id: $checkedConvert(
          '_id',
          (v) => UnderscoreId.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'limitTime': 'limittime', 'id': '_id'});

Map<String, dynamic> _$FreePLogToJson(FreePLog instance) => <String, dynamic>{
  'limittime': instance.limitTime,
  'fpoint': instance.fpoint,
  'much': instance.much,
  'expire': instance.expire,
  'uid': instance.uid,
  '_id': instance.id,
};
