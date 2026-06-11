// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreModel _$StoreModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('StoreModel', json, ($checkedConvert) {
      final val = StoreModel(
        prefix: $checkedConvert('prefix', (v) => v as String?),
        storelist: $checkedConvert(
          'storelist',
          (v) => (v as List<dynamic>?)
              ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$StoreModelToJson(StoreModel instance) =>
    <String, dynamic>{
      'prefix': instance.prefix,
      'storelist': instance.storelist,
    };

Store _$StoreFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Store', json, ($checkedConvert) {
      final val = Store(
        address: $checkedConvert('address', (v) => v as String?),
        name: $checkedConvert('name', (v) => v as String?),
        sid: $checkedConvert('sid', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
  'address': instance.address,
  'name': instance.name,
  'sid': instance.sid,
};
