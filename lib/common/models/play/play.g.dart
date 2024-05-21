// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayRecordModel _$PlayRecordModelFromJson(Map<String, dynamic> json) =>
    PlayRecordModel(
      code: (json['code'] as num).toInt(),
      message: json['message'] as String,
      logs: (json['log'] as List<dynamic>)
          .map((e) => PlayLog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlayRecordModelToJson(PlayRecordModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'log': instance.logs,
    };

PlayLog _$PlayLogFromJson(Map<String, dynamic> json) => PlayLog(
      cid: (json['cid'] as num).toInt(),
      disbool: json['disbool'] as bool,
      done: json['done'] as bool,
      freep: (json['freep'] as num).toDouble(),
      initTime: InitTime.fromJson(json['inittime'] as Map<String, dynamic>),
      mid: json['mid'] as String,
      price: (json['price'] as num).toDouble(),
      sid: json['sid'] as String,
      status: json['status'] as String,
      time: json['time'] as String,
      uid: json['uid'] as String,
      id: UnderscoreId.fromJson(json['_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayLogToJson(PlayLog instance) => <String, dynamic>{
      'cid': instance.cid,
      'disbool': instance.disbool,
      'done': instance.done,
      'freep': instance.freep,
      'inittime': instance.initTime,
      'mid': instance.mid,
      'price': instance.price,
      'sid': instance.sid,
      'status': instance.status,
      'time': instance.time,
      'uid': instance.uid,
      '_id': instance.id,
    };
