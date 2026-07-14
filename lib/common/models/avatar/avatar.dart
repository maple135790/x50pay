import 'package:json_annotation/json_annotation.dart';

part 'avatar.g.dart';

@JsonSerializable(createToJson: false)
class Avatar {
  @JsonKey(name: 'canbuy')
  final bool canBuy;
  @JsonKey(name: 'enable')
  final bool isEnabled;
  @JsonKey(name: 'have')
  final bool isOwned;
  final String id;
  @JsonKey(name: "lv")
  final int level;
  final int pp;
  @JsonKey(name: "webp")
  final String dataUri;

  const Avatar(
    this.canBuy,
    this.isEnabled,
    this.isOwned,
    this.id,
    this.level,
    this.pp,
    this.dataUri,
  );

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
}
