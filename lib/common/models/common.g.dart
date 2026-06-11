// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InitTime _$InitTimeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('InitTime', json, ($checkedConvert) {
      final val = InitTime(date: $checkedConvert(r'$date', (v) => v as String));
      return val;
    }, fieldKeyMap: const {'date': r'$date'});

Map<String, dynamic> _$InitTimeToJson(InitTime instance) => <String, dynamic>{
  r'$date': instance.date,
};

UnderscoreId _$UnderscoreIdFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UnderscoreId', json, ($checkedConvert) {
      final val = UnderscoreId(
        oid: $checkedConvert(r'$oid', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'oid': r'$oid'});

Map<String, dynamic> _$UnderscoreIdToJson(UnderscoreId instance) =>
    <String, dynamic>{r'$oid': instance.oid};
