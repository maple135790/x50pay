// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayRecordModel _$PlayRecordModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlayRecordModel', json, ($checkedConvert) {
      final val = PlayRecordModel(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        message: $checkedConvert('message', (v) => v as String),
        logs: $checkedConvert(
          'log',
          (v) => (v as List<dynamic>)
              .map((e) => PlayLog.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'logs': 'log'});

Map<String, dynamic> _$PlayRecordModelToJson(PlayRecordModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'log': instance.logs,
    };

PlayLog _$PlayLogFromJson(Map<String, dynamic> json) =>
    $checkedCreate('PlayLog', json, ($checkedConvert) {
      final val = PlayLog(
        cid: $checkedConvert('cid', (v) => (v as num).toInt()),
        disbool: $checkedConvert('disbool', (v) => v as bool),
        done: $checkedConvert('done', (v) => v as bool),
        freep: $checkedConvert('freep', (v) => (v as num).toDouble()),
        initTime: $checkedConvert(
          'inittime',
          (v) => InitTime.fromJson(v as Map<String, dynamic>),
        ),
        mid: $checkedConvert('mid', (v) => v as String),
        price: $checkedConvert('price', (v) => (v as num).toDouble()),
        sid: $checkedConvert('sid', (v) => v as String),
        status: $checkedConvert('status', (v) => v as String),
        time: $checkedConvert('time', (v) => v as String),
        uid: $checkedConvert('uid', (v) => v as String),
        id: $checkedConvert(
          '_id',
          (v) => UnderscoreId.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'initTime': 'inittime', 'id': '_id'});

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
