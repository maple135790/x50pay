// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tic_used.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicUsedModel _$TicUsedModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TicUsedModel', json, ($checkedConvert) {
      final val = TicUsedModel(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        message: $checkedConvert('message', (v) => v as String),
        logs: $checkedConvert(
          'log',
          (v) => (v as List<dynamic>)
              .map((e) => TicUsedLog.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'logs': 'log'});

Map<String, dynamic> _$TicUsedModelToJson(TicUsedModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'log': instance.logs,
    };

TicUsedLog _$TicUsedLogFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TicUsedLog', json, ($checkedConvert) {
      final val = TicUsedLog(
        cid: $checkedConvert('cid', (v) => (v as num).toInt()),
        disbool: $checkedConvert('disbool', (v) => v as bool),
        mid: $checkedConvert('mid', (v) => v as String),
        price: $checkedConvert('price', (v) => (v as num).toDouble()),
        sid: $checkedConvert('sid', (v) => v as String),
        ticn: $checkedConvert('ticn', (v) => v as String),
        time: $checkedConvert('time', (v) => v as String),
        uid: $checkedConvert('uid', (v) => v as String),
        underscoreId: $checkedConvert(
          '_id',
          (v) => UnderscoreId.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'underscoreId': '_id'});

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
