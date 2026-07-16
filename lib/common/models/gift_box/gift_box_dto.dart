import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/gift_box/claimable_gift.dart';
import 'package:x50pay/common/models/gift_box/claimed_gift.dart';

part 'gift_box_dto.g.dart';

@JsonSerializable(createToJson: false)
class GiftBoxDTO extends BasicResponse {
  /// 已兌換的禮物列表
  @JsonKey(name: 'alchange')
  final List<ClaimedGift> claimedGifts;

  /// 可兌換的禮物列表
  @JsonKey(name: 'canchange')
  final List<ClaimableGift> claimableGifts;

  /// 禮物箱資料
  ///
  /// 用於禮物系統頁面
  const GiftBoxDTO({
    required this.claimedGifts,
    required this.claimableGifts,
    required super.code,
    required super.message,
  });

  factory GiftBoxDTO.fromJson(Map<String, dynamic> json) =>
      _$GiftBoxDTOFromJson(json);
}
