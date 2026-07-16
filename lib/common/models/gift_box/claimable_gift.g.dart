// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claimable_gift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimableGift _$ClaimableGiftFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ClaimableGift', json, ($checkedConvert) {
      final val = ClaimableGift(
        chid: $checkedConvert('chid', (v) => v as String),
        gid: $checkedConvert('gid', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        pic: $checkedConvert('pic', (v) => v as String),
      );
      return val;
    });
