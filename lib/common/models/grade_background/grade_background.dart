import 'package:json_annotation/json_annotation.dart';

part 'grade_background.g.dart';

@JsonSerializable()
class GradeBackground {
  @JsonKey(name: 'bgid')
  final String id;
  @JsonKey(name: 'enable')
  final bool isEnabled;
  final String name;

  const GradeBackground(this.id, this.isEnabled, this.name);

  factory GradeBackground.fromJson(Map<String, dynamic> json) =>
      _$GradeBackgroundFromJson(json);
  Map<String, dynamic> toJson() => _$GradeBackgroundToJson(this);
}
