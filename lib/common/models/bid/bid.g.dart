// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidLogModel _$BidLogModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BidLogModel', json, ($checkedConvert) {
      final val = BidLogModel(
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        logs: $checkedConvert(
          'log',
          (v) => (v as List<dynamic>)
              .map((e) => BidLog.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'logs': 'log'});

Map<String, dynamic> _$BidLogModelToJson(BidLogModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'log': instance.logs,
      'message': instance.message,
    };

BidLog _$BidLogFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BidLog', json, ($checkedConvert) {
      final val = BidLog(
        point: $checkedConvert('point', (v) => (v as num?)?.toDouble()),
        threekcred: $checkedConvert('3kcred', (v) => v as bool?),
        shop: $checkedConvert('shop', (v) => v as String?),
        time: $checkedConvert('time', (v) => v as String?),
        uid: $checkedConvert('uid', (v) => v as String?),
        id: $checkedConvert(
          '_id',
          (v) => v == null ? null : BidId.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'threekcred': '3kcred', 'id': '_id'});

Map<String, dynamic> _$BidLogToJson(BidLog instance) => <String, dynamic>{
  'point': instance.point,
  '3kcred': instance.threekcred,
  'shop': instance.shop,
  'time': instance.time,
  'uid': instance.uid,
  '_id': instance.id,
};

BidId _$BidIdFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BidId', json, ($checkedConvert) {
      final val = BidId(oid: $checkedConvert(r'$oid', (v) => v as String));
      return val;
    }, fieldKeyMap: const {'oid': r'$oid'});

Map<String, dynamic> _$BidIdToJson(BidId instance) => <String, dynamic>{
  r'$oid': instance.oid,
};
