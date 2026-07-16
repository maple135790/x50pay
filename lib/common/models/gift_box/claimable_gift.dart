import 'package:json_annotation/json_annotation.dart';
part 'claimable_gift.g.dart';

@JsonSerializable(createToJson: false)
class ClaimableGift {
  final String chid;
  final String gid;
  final String name;
  final String pic;

  const ClaimableGift({
    required this.chid,
    required this.gid,
    required this.name,
    required this.pic,
  });

  factory ClaimableGift.fromJson(Map<String, dynamic> json) =>
      _$ClaimableGiftFromJson(json);
}
