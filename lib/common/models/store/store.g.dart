// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => StoreModel(
      prefix: json['prefix'] as String?,
      storelist: (json['storelist'] as List<dynamic>?)
          ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'prefix': instance.prefix,
      'storelist': instance.storelist,
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      address: json['address'] as String?,
      name: json['name'] as String?,
      sid: json['sid'] as int?,
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'address': instance.address,
      'name': instance.name,
      'sid': instance.sid,
    };
