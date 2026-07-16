// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftBox _$GiftBoxFromJson(Map<String, dynamic> json) => $checkedCreate(
  'GiftBox',
  json,
  ($checkedConvert) {
    final val = GiftBox(
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
    );
    return val;
  },
  fieldKeyMap: const {
    'claimedGifts': 'alchange',
    'claimableGifts': 'canchange',
  },
);
