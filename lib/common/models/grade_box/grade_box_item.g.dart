// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_box_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeBoxItem _$GradeBoxItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GradeBoxItem',
      json,
      ($checkedConvert) {
        final val = GradeBoxItem(
          $checkedConvert('pic', (v) => v as String),
          $checkedConvert('name', (v) => v as String),
          $checkedConvert('much', (v) => (v as num).toInt()),
          $checkedConvert('limit', (v) => (v as num).toDouble()),
          $checkedConvert('gid', (v) => v as String),
          $checkedConvert('eid', (v) => v as String),
          $checkedConvert('heart', (v) => (v as num).toInt()),
          $checkedConvert('filter', (v) => v as String),
          $checkedConvert('region', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'rawPicUrl': 'pic',
        'giftId': 'gid',
        'eventId': 'eid',
      },
    );
