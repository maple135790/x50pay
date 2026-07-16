// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_background.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeBackground _$GradeBackgroundFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GradeBackground', json, ($checkedConvert) {
      final val = GradeBackground(
        $checkedConvert('bgid', (v) => v as String),
        $checkedConvert('enable', (v) => v as bool),
        $checkedConvert('name', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'id': 'bgid', 'isEnabled': 'enable'});

Map<String, dynamic> _$GradeBackgroundToJson(GradeBackground instance) =>
    <String, dynamic>{
      'bgid': instance.id,
      'enable': instance.isEnabled,
      'name': instance.name,
    };
