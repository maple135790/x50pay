// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftBoxModel _$GiftBoxModelFromJson(Map<String, dynamic> json) => GiftBoxModel(
      code: (json['code'] as num).toInt(),
      alChange: (json['alchange'] as List<dynamic>)
          .map((e) => AlChange.fromJson(e as Map<String, dynamic>))
          .toList(),
      canChange: (json['canchange'] as List<dynamic>)
          .map((e) => CanChange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GiftBoxModelToJson(GiftBoxModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'alchange': instance.alChange,
      'canchange': instance.canChange,
    };

AlChange _$AlChangeFromJson(Map<String, dynamic> json) => AlChange(
      auto: json['auto'] as bool,
      chid: json['chid'] as String,
      gid: json['gid'] as String,
      name: json['name'] as String,
      pic: json['pic'] as String,
    );

Map<String, dynamic> _$AlChangeToJson(AlChange instance) => <String, dynamic>{
      'auto': instance.auto,
      'chid': instance.chid,
      'gid': instance.gid,
      'name': instance.name,
      'pic': instance.pic,
    };

CanChange _$CanChangeFromJson(Map<String, dynamic> json) => CanChange(
      chid: json['chid'] as String,
      gid: json['gid'] as String,
      name: json['name'] as String,
      pic: json['pic'] as String,
    );

Map<String, dynamic> _$CanChangeToJson(CanChange instance) => <String, dynamic>{
      'chid': instance.chid,
      'gid': instance.gid,
      'name': instance.name,
      'pic': instance.pic,
    };
