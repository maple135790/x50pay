import 'package:json_annotation/json_annotation.dart';

part "tic_date.g.dart";

@JsonSerializable()
class TicDateLogModel {
  final int code;
  @JsonKey(name: 'log')
  final List<List<dynamic>> logs;
  final String message;

  const TicDateLogModel({required this.code, required this.logs, required this.message});

  factory TicDateLogModel.fromJson(Map<String, dynamic> json) => _$TicDateLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicDateLogModelToJson(this);
}
