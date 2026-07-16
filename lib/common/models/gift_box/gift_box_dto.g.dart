// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_box_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftBoxDTO _$GiftBoxDTOFromJson(Map<String, dynamic> json) => $checkedCreate(
  'GiftBoxDTO',
  json,
  ($checkedConvert) {
    final val = GiftBoxDTO(
      claimedGifts: $checkedConvert(
        'alchange',
        (v) => (v as List<dynamic>)
            .map((e) => ClaimedGift.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      claimableGifts: $checkedConvert(
        'canchange',
        (v) => (v as List<dynamic>)
            .map((e) => ClaimableGift.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      code: $checkedConvert('code', (v) => (v as num).toInt()),
      message: $checkedConvert('message', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'claimedGifts': 'alchange',
    'claimableGifts': 'canchange',
  },
);
