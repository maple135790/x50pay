// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tic_used.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicUsedModel _$TicUsedModelFromJson(Map<String, dynamic> json) => TicUsedModel(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      logs: (json['log'] as List<dynamic>)
          .map((e) => TicUsedLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TicUsedModelToJson(TicUsedModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'log': instance.logs,
    };

TicUsedLog _$TicUsedLogFromJson(Map<String, dynamic> json) => TicUsedLog(
      cid: (json['cid'] as num).toInt(),
      disbool: json['disbool'] as bool,
      mid: json['mid'] as String,
      price: (json['price'] as num).toDouble(),
      sid: json['sid'] as String,
      ticn: json['ticn'] as String,
      time: json['time'] as String,
      uid: json['uid'] as String,
      underscoreId: UnderscoreId.fromJson(json['_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicUsedLogToJson(TicUsedLog instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'disbool': instance.disbool,
      'mid': instance.mid,
      'price': instance.price,
      'sid': instance.sid,
      'ticn': instance.ticn,
      'time': instance.time,
      'uid': instance.uid,
      '_id': instance.underscoreId,
    };
