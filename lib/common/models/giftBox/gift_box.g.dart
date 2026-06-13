// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftBoxModel _$GiftBoxModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'GiftBoxModel',
      json,
      ($checkedConvert) {
        final val = GiftBoxModel(
          code: $checkedConvert('code', (v) => (v as num).toInt()),
          alChange: $checkedConvert(
            'alchange',
            (v) => (v as List<dynamic>)
                .map((e) => AlChange.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          canChange: $checkedConvert(
            'canchange',
            (v) => (v as List<dynamic>)
                .map((e) => CanChange.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
        );
        return val;
      },
      fieldKeyMap: const {'alChange': 'alchange', 'canChange': 'canchange'},
    );

Map<String, dynamic> _$GiftBoxModelToJson(GiftBoxModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'alchange': instance.alChange,
      'canchange': instance.canChange,
    };

AlChange _$AlChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AlChange', json, ($checkedConvert) {
      final val = AlChange(
        auto: $checkedConvert('auto', (v) => v as bool),
        chid: $checkedConvert('chid', (v) => v as String),
        gid: $checkedConvert('gid', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        pic: $checkedConvert('pic', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AlChangeToJson(AlChange instance) => <String, dynamic>{
  'auto': instance.auto,
  'chid': instance.chid,
  'gid': instance.gid,
  'name': instance.name,
  'pic': instance.pic,
};

CanChange _$CanChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('CanChange', json, ($checkedConvert) {
      final val = CanChange(
        chid: $checkedConvert('chid', (v) => v as String),
        gid: $checkedConvert('gid', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        pic: $checkedConvert('pic', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$CanChangeToJson(CanChange instance) => <String, dynamic>{
  'chid': instance.chid,
  'gid': instance.gid,
  'name': instance.name,
  'pic': instance.pic,
};
