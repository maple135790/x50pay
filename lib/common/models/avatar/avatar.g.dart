// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Avatar _$AvatarFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Avatar',
  json,
  ($checkedConvert) {
    final val = Avatar(
      $checkedConvert('canbuy', (v) => v as bool),
      $checkedConvert('enable', (v) => v as bool),
      $checkedConvert('have', (v) => v as bool),
      $checkedConvert('id', (v) => v as String),
      $checkedConvert('lv', (v) => (v as num).toInt()),
      $checkedConvert('pp', (v) => (v as num).toInt()),
      $checkedConvert('webp', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'canBuy': 'canbuy',
    'isEnabled': 'enable',
    'isOwned': 'have',
    'level': 'lv',
    'dataUri': 'webp',
  },
);
