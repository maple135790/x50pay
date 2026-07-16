// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeBox _$GradeBoxFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GradeBox', json, ($checkedConvert) {
      final val = GradeBox(
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
      );
      return val;
    });
