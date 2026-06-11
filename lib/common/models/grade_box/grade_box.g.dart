// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeBoxModel _$GradeBoxModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GradeBoxModel', json, ($checkedConvert) {
      final val = GradeBoxModel(
        card: $checkedConvert(
          'card',
          (v) => (v as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : GradeBoxItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        cd: $checkedConvert(
          'cd',
          (v) => (v as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : GradeBoxItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        x50: $checkedConvert(
          'x50',
          (v) => (v as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : GradeBoxItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        gifts: $checkedConvert(
          'gifts',
          (v) => (v as List<dynamic>)
              .map(
                (e) => e == null
                    ? null
                    : GradeBoxItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
        code: $checkedConvert('code', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$GradeBoxModelToJson(GradeBoxModel instance) =>
    <String, dynamic>{
      'card': instance.card,
      'cd': instance.cd,
      'x50': instance.x50,
      'gifts': instance.gifts,
      'code': instance.code,
    };

GradeBoxItem _$GradeBoxItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GradeBoxItem', json, ($checkedConvert) {
      final val = GradeBoxItem(
        rawPicUrl: $checkedConvert('pic', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        much: $checkedConvert('much', (v) => (v as num).toInt()),
        limit: $checkedConvert('limit', (v) => (v as num).toDouble()),
        gid: $checkedConvert('gid', (v) => v as String),
        eid: $checkedConvert('eid', (v) => v as String),
        heart: $checkedConvert('heart', (v) => (v as num).toInt()),
      );
      return val;
    }, fieldKeyMap: const {'rawPicUrl': 'pic'});

Map<String, dynamic> _$GradeBoxItemToJson(GradeBoxItem instance) =>
    <String, dynamic>{
      'pic': instance.rawPicUrl,
      'name': instance.name,
      'much': instance.much,
      'limit': instance.limit,
      'gid': instance.gid,
      'eid': instance.eid,
      'heart': instance.heart,
    };
