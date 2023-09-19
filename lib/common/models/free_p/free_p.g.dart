// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_p.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FreePointModel _$FreePModelFromJson(Map<String, dynamic> json) =>
    FreePointModel(
      code: json['code'] as int,
      message: json['message'] as String,
      logs: (json['log'] as List<dynamic>)
          .map((e) => FreePLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FreePModelToJson(FreePointModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'log': instance.logs,
    };

FreePLog _$FreePLogFromJson(Map<String, dynamic> json) => FreePLog(
      limitTime: json['limittime'] as String,
      uid: json['uid'] as String,
      expire: json['expire'] as bool,
      fpoint: (json['fpoint'] as num).toDouble(),
      much: (json['much'] as num).toDouble(),
      id: UnderscoreId.fromJson(json['_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FreePLogToJson(FreePLog instance) => <String, dynamic>{
      'limittime': instance.limitTime,
      'fpoint': instance.fpoint,
      'much': instance.much,
      'expire': instance.expire,
      'uid': instance.uid,
      '_id': instance.id,
    };
