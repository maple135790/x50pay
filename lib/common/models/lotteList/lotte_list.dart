import 'package:json_annotation/json_annotation.dart';

part "lotte_list.g.dart";

@JsonSerializable()
class LotteListModel {
  @JsonKey(name: 'list')
  final List<dynamic> rawLotteList;
  final int self;
  final String name;
  final String date;
  final String tic;

  LotteListModel(this.rawLotteList)
      : self = rawLotteList[4],
        name = rawLotteList[0],
        date = rawLotteList[1],
        tic = rawLotteList[2].toString();

  factory LotteListModel.fromJson(Map<String, dynamic> json) =>
      _$LotteListModelFromJson(json);

  Map<String, dynamic> toJson() => _$LotteListModelToJson(this);
}
