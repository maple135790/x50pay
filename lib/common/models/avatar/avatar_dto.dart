import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/avatar/avatar.dart';
import 'package:x50pay/common/models/basic_response.dart';

part 'avatar_dto.g.dart';

@JsonSerializable(createToJson: false)
class AvatarDTO extends BasicResponse {
  @JsonKey(name: 'result')
  final List<Avatar> avatars;

  const AvatarDTO(this.avatars, {required super.code, required super.message});

  factory AvatarDTO.fromJson(Map<String, dynamic> json) =>
      _$AvatarDTOFromJson(json);
}
