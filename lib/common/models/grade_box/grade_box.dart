import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/models/grade_box/grade_box_dto.dart';
import 'package:x50pay/common/models/grade_box/grade_box_item.dart';

part 'grade_box.g.dart';

/// 養成商城
@JsonSerializable(createToJson: false)
class GradeBox {
  final List<GradeBoxItem> card;
  final List<GradeBoxItem> cd;
  final List<GradeBoxItem> x50;
  final List<GradeBoxItem> gifts;

  const GradeBox({
    required this.card,
    required this.cd,
    required this.x50,
    required this.gifts,
  });

  factory GradeBox.fromJson(Map<String, dynamic> json) =>
      _$GradeBoxFromJson(json);
}

extension GradeBoxExt on GradeBox {
  static GradeBox fromDTO(GradeBoxDTO dto) {
    return GradeBox(
      card: dto.card,
      cd: dto.cd,
      gifts: dto.gifts,
      x50: dto.x50,
    );
  }
}
