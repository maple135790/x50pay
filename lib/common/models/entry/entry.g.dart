// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntryModel _$EntryModelFromJson(Map<String, dynamic> json) => EntryModel(
      message: json['message'] as String,
      code: json['code'] as int,
      gr2: json['gr2'] as List<dynamic>,
      evlist: (json['evlist'] as List<dynamic>?)
          ?.map((e) => Evlist.fromJson(e as Map<String, dynamic>))
          .toList(),
      giftlist: json['giftlist'] == null
          ? null
          : GiftList.fromJson(json['giftlist'] as Map<String, dynamic>),
      questCampaign: (json['rqc'] as List<dynamic>?)
          ?.map((e) => QuestCampaign.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EntryModelToJson(EntryModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'gr2': instance.gr2,
      'evlist': instance.evlist,
      'giftlist': instance.giftlist,
      'rqc': instance.questCampaign,
    };

Evlist _$EvlistFromJson(Map<String, dynamic> json) => Evlist(
      count: json['count'] as String?,
      countday: json['countday'] as String?,
      describe: json['describe'] as String?,
      end: json['end'] == null
          ? null
          : EventTime.fromJson(json['end'] as Map<String, dynamic>),
      id: json['id'] as String?,
      limit: json['limit'] as int?,
      name: json['name'] as String?,
      point: json['point'] as bool?,
      sid: json['sid'] as String?,
      start: json['start'] == null
          ? null
          : EventTime.fromJson(json['start'] as Map<String, dynamic>),
      ticMid: json['ticMid'] as List<dynamic>?,
      ticdis: json['ticdis'] as String?,
      value: json['value'] as int?,
      which: json['which'] as List<dynamic>?,
      underscoreId: json['_id'] == null
          ? null
          : UnderscoreId.fromJson(json['_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EvlistToJson(Evlist instance) => <String, dynamic>{
      'count': instance.count,
      'countday': instance.countday,
      'describe': instance.describe,
      'end': instance.end,
      'id': instance.id,
      'limit': instance.limit,
      'name': instance.name,
      'point': instance.point,
      'sid': instance.sid,
      'start': instance.start,
      'ticMid': instance.ticMid,
      'ticdis': instance.ticdis,
      'value': instance.value,
      'which': instance.which,
      '_id': instance.underscoreId,
    };

GiftList _$GiftListFromJson(Map<String, dynamic> json) => GiftList(
      gift: json['gift'] as bool?,
    );

Map<String, dynamic> _$GiftListToJson(GiftList instance) => <String, dynamic>{
      'gift': instance.gift,
    };

EventTime _$EventTimeFromJson(Map<String, dynamic> json) => EventTime(
      date: json[r'$date'] as int,
    );

Map<String, dynamic> _$EventTimeToJson(EventTime instance) => <String, dynamic>{
      r'$date': instance.date,
    };

EntryHistory _$EntryHistoryFromJson(Map<String, dynamic> json) => EntryHistory(
      cid: json['cid'] as int?,
      disbool: json['disbool'] as bool?,
      done: json['done'] as bool?,
      freep: (json['freep'] as num?)?.toDouble(),
      inittime: json['inittime'] == null
          ? null
          : InitTime.fromJson(json['inittime'] as Map<String, dynamic>),
      mid: json['mid'] as String?,
      ticn: json['ticn'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      sid: json['sid'] as String?,
      status: json['status'] as String?,
      time: json['time'] as String?,
      uid: json['uid'] as String?,
      underscoreId: json['_id'] == null
          ? null
          : UnderscoreId.fromJson(json['_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EntryHistoryToJson(EntryHistory instance) =>
    <String, dynamic>{
      'cid': instance.cid,
      'disbool': instance.disbool,
      'done': instance.done,
      'freep': instance.freep,
      'inittime': instance.inittime,
      'mid': instance.mid,
      'ticn': instance.ticn,
      'price': instance.price,
      'sid': instance.sid,
      'status': instance.status,
      'time': instance.time,
      'uid': instance.uid,
      '_id': instance.underscoreId,
    };

QuestCampaign _$QuestCampaignFromJson(Map<String, dynamic> json) =>
    QuestCampaign(
      couid: json['couid'] as String,
      lpic: json['lpic'] as String,
      lpicshow: json['lpicshow'] as bool,
      mid: (json['mid'] as List<dynamic>).map((e) => e as String).toList(),
      spic: json['spic'] as String,
      underscoreId: json['_id'] == null
          ? null
          : UnderscoreId.fromJson(json['_id'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$QuestCampaignToJson(QuestCampaign instance) =>
    <String, dynamic>{
      'couid': instance.couid,
      'lpic': instance.lpic,
      'lpicshow': instance.lpicshow,
      'mid': instance.mid,
      'spic': instance.spic,
      '_id': instance.underscoreId,
    };
