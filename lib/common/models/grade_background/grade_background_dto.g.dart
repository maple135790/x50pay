// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_background_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeBackgroundDTO _$GradeBackgroundDTOFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GradeBackgroundDTO', json, ($checkedConvert) {
      final val = GradeBackgroundDTO(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        message: $checkedConvert('message', (v) => v as String),
        backgrounds: $checkedConvert(
          'result',
          (v) => (v as List<dynamic>)
              .map((e) => GradeBackground.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'backgrounds': 'result'});

Map<String, dynamic> _$GradeBackgroundDTOToJson(GradeBackgroundDTO instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'result': instance.backgrounds,
    };
