import 'package:json_annotation/json_annotation.dart';

part "store.g.dart";

@JsonSerializable()
class StoreModel {
  /// 店家編號的前綴
  ///
  /// 用於區別體系
  final String? prefix;

  /// 店家資料List
  final List<Store>? storelist;

  /// 店家資料的Model
  ///
  /// 用於選店頁面的店家資料。
  const StoreModel({this.prefix, this.storelist});

  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreModelToJson(this);

  const StoreModel.empty()
      : prefix = null,
        storelist = const [];
}

@JsonSerializable()
class Store {
  /// 店家地址
  final String? address;

  /// 店家名稱
  final String? name;

  /// 店家編號
  final int? sid;

  /// 單一店家資料
  const Store({this.address, this.name, this.sid});

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
