// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tic_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicDateLogModel _$TicDateLogModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TicDateLogModel', json, ($checkedConvert) {
      final val = TicDateLogModel(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        logs: $checkedConvert(
          'log',
          (v) => (v as List<dynamic>).map((e) => e as List<dynamic>).toList(),
        ),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'logs': 'log'});

Map<String, dynamic> _$TicDateLogModelToJson(TicDateLogModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'log': instance.logs,
      'message': instance.message,
    };
