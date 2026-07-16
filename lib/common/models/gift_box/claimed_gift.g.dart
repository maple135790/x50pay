// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claimed_gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimedGift _$ClaimedGiftFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ClaimedGift', json, ($checkedConvert) {
      final val = ClaimedGift(
        auto: $checkedConvert('auto', (v) => v as bool),
        chid: $checkedConvert('chid', (v) => v as String),
        gid: $checkedConvert('gid', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        pic: $checkedConvert('pic', (v) => v as String),
      );
      return val;
    });
