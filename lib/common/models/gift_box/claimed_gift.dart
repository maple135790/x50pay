import 'package:json_annotation/json_annotation.dart';
part 'claimed_gift.g.dart';

@JsonSerializable(createToJson: false)
class ClaimedGift {
  final bool auto;
  final String chid;
  final String gid;
  final String name;
  final String pic;

  const ClaimedGift({
    required this.auto,
    required this.chid,
    required this.gid,
    required this.name,
    required this.pic,
  });
  factory ClaimedGift.fromJson(Map<String, dynamic> json) =>
      _$ClaimedGiftFromJson(json);
}
