import 'package:json_annotation/json_annotation.dart';

part 'pad_settings.g.dart';

@JsonSerializable()
class PadSettingsModel {
  final String shcolor;
  final bool shid;
  final String shname;

  const PadSettingsModel(
      {required this.shcolor, required this.shid, required this.shname});

  factory PadSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$PadSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PadSettingsModelToJson(this);
}
