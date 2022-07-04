import 'package:json_annotation/json_annotation.dart';

part "store.g.dart";

@JsonSerializable()
class StoreModel {
  final String? prefix;
  final List<Storelist>? storelist;

  const StoreModel({this.prefix, this.storelist});

  factory StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreModelToJson(this);
}

@JsonSerializable()
class Storelist {
  final String? address;
  final String? name;
  final int? sid;

  const Storelist({this.address, this.name, this.sid});

  factory Storelist.fromJson(Map<String, dynamic> json) => _$StorelistFromJson(json);
  Map<String, dynamic> toJson() => _$StorelistToJson(this);
}
