// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_box_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeBoxDTO _$GradeBoxDTOFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GradeBoxDTO', json, ($checkedConvert) {
      final val = GradeBoxDTO(
        card: $checkedConvert(
          'card',
          (v) => (v as List<dynamic>)
              .map((e) => GradeBoxItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        cd: $checkedConvert(
          'cd',
          (v) => (v as List<dynamic>)
              .map((e) => GradeBoxItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        x50: $checkedConvert(
          'x50',
          (v) => (v as List<dynamic>)
              .map((e) => GradeBoxItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        gifts: $checkedConvert(
          'gifts',
          (v) => (v as List<dynamic>)
              .map((e) => GradeBoxItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    });
