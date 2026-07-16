import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/gift_box/claimable_gift.dart';
import 'package:x50pay/common/models/gift_box/claimed_gift.dart';
import 'package:x50pay/common/models/gift_box/gift_box_dto.dart';
part 'gift_box.g.dart';

@JsonSerializable(createToJson: false)
class GiftBox {
  /// 已兌換的禮物列表
  @JsonKey(name: 'alchange')
  final List<ClaimedGift> claimedGifts;

  /// 可兌換的禮物列表
  @JsonKey(name: 'canchange')
  final List<ClaimableGift> claimableGifts;

  /// 禮物箱資料
  ///
  /// 用於禮物系統頁面
  const GiftBox({required this.claimedGifts, required this.claimableGifts});

  factory GiftBox.fromJson(Map<String, dynamic> json) =>
      _$GiftBoxFromJson(json);
}

extension GiftBoxExt on GiftBox {
  static GiftBox fromDTO(GiftBoxDTO dto) {
    return GiftBox(
      claimableGifts: dto.claimableGifts,
      claimedGifts: dto.claimedGifts,
    );
  }
}
