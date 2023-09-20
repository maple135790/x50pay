// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GradeBoxModel _$GradeBoxModelFromJson(Map<String, dynamic> json) =>
    GradeBoxModel(
      card: (json['card'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : GradeBoxItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      cd: (json['cd'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : GradeBoxItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      x50: (json['x50'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : GradeBoxItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      gifts: (json['gifts'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : GradeBoxItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as int,
    );

Map<String, dynamic> _$GradeBoxModelToJson(GradeBoxModel instance) =>
    <String, dynamic>{
      'card': instance.card,
      'cd': instance.cd,
      'x50': instance.x50,
      'gifts': instance.gifts,
      'code': instance.code,
    };

GradeBoxItem _$GradeBoxItemFromJson(Map<String, dynamic> json) => GradeBoxItem(
      rawPicUrl: json['pic'] as String,
      name: json['name'] as String,
      much: json['much'] as int,
      limit: (json['limit'] as num).toDouble(),
      gid: json['gid'] as String,
      eid: json['eid'] as String,
      heart: json['heart'] as int,
    );

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
