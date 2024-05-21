// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tic_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicDateLogModel _$TicDateLogModelFromJson(Map<String, dynamic> json) =>
    TicDateLogModel(
      code: (json['code'] as num).toInt(),
      logs: (json['log'] as List<dynamic>)
          .map((e) => e as List<dynamic>)
          .toList(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$TicDateLogModelToJson(TicDateLogModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'log': instance.logs,
      'message': instance.message,
    };
