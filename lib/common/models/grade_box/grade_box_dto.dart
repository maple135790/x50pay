import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/grade_box/grade_box_item.dart';

part 'grade_box_dto.g.dart';

/// 養成商城
@JsonSerializable(createToJson: false)
class GradeBoxDTO extends BasicResponse {
  final List<GradeBoxItem> card;
  final List<GradeBoxItem> cd;
  final List<GradeBoxItem> x50;
  final List<GradeBoxItem> gifts;

  const GradeBoxDTO({
    required this.card,
    required this.cd,
    required this.x50,
    required this.gifts,
    required super.code,
    required super.message,
  });

  factory GradeBoxDTO.fromJson(Map<String, dynamic> json) =>
      _$GradeBoxDTOFromJson(json);
}
