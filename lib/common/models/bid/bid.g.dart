// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidLogModel _$BidLogModelFromJson(Map<String, dynamic> json) => BidLogModel(
      code: json['code'] as int,
      logs: (json['log'] as List<dynamic>)
          .map((e) => BidLog.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
    );

Map<String, dynamic> _$BidLogModelToJson(BidLogModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'log': instance.logs,
      'message': instance.message,
    };

BidLog _$BidLogFromJson(Map<String, dynamic> json) => BidLog(
      point: (json['point'] as num?)?.toDouble(),
      threekcred: json['3kcred'] as bool?,
      shop: json['shop'] as String?,
      time: json['time'] as String?,
      uid: json['uid'] as String?,
      id: json['_id'] == null
          ? null
          : BidId.fromJson(json['_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BidLogToJson(BidLog instance) => <String, dynamic>{
      'point': instance.point,
      '3kcred': instance.threekcred,
      'shop': instance.shop,
      'time': instance.time,
      'uid': instance.uid,
      '_id': instance.id,
    };

BidId _$BidIdFromJson(Map<String, dynamic> json) => BidId(
      oid: json[r'$oid'] as String,
    );

Map<String, dynamic> _$BidIdToJson(BidId instance) => <String, dynamic>{
      r'$oid': instance.oid,
    };
