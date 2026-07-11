import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/grade_background/grade_background.dart';

part 'grade_background_dto.g.dart';

@JsonSerializable()
class GradeBackgroundDTO extends BasicResponse {
  @JsonKey(name: 'result')
  final List<GradeBackground> backgrounds;

  const GradeBackgroundDTO({
    required super.code,
    required super.message,
    required this.backgrounds,
  });

  factory GradeBackgroundDTO.fromJson(Map<String, dynamic> json) =>
      _$GradeBackgroundDTOFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GradeBackgroundDTOToJson(this);
}

