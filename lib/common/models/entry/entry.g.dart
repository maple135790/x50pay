// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntryModel _$EntryModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EntryModel', json, ($checkedConvert) {
      final val = EntryModel(
        message: $checkedConvert('message', (v) => v as String),
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        gr2: $checkedConvert('gr2', (v) => v as List<dynamic>),
        evlist: $checkedConvert(
          'evlist',
          (v) => (v as List<dynamic>?)
              ?.map((e) => Evlist.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        giftlist: $checkedConvert(
          'giftlist',
          (v) => (v as List<dynamic>?)
              ?.map((e) => GiftList.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        questCampaign: $checkedConvert(
          'rqc',
          (v) => (v as List<dynamic>?)
              ?.map((e) => QuestCampaign.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'questCampaign': 'rqc'});

Map<String, dynamic> _$EntryModelToJson(EntryModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'gr2': instance.gr2,
      'evlist': instance.evlist,
      'giftlist': instance.giftlist,
      'rqc': instance.questCampaign,
    };

Evlist _$EvlistFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Evlist',
  json,
  ($checkedConvert) {
    final val = Evlist(
      count: $checkedConvert('count', (v) => v as String?),
      countday: $checkedConvert('countday', (v) => v as String?),
      describe: $checkedConvert('describe', (v) => v as String?),
      end: $checkedConvert(
        'end',
        (v) => v == null ? null : EventTime.fromJson(v as Map<String, dynamic>),
      ),
      id: $checkedConvert('id', (v) => v as String?),
      limit: $checkedConvert('limit', (v) => (v as num?)?.toInt()),
      name: $checkedConvert('name', (v) => v as String?),
      point: $checkedConvert('point', (v) => v as bool?),
      sid: $checkedConvert('sid', (v) => v as String?),
      start: $checkedConvert(
        'start',
        (v) => v == null ? null : EventTime.fromJson(v as Map<String, dynamic>),
      ),
      ticMid: $checkedConvert('ticMid', (v) => v as List<dynamic>?),
      ticdis: $checkedConvert('ticdis', (v) => v as String?),
      value: $checkedConvert('value', (v) => (v as num?)?.toInt()),
      which: $checkedConvert('which', (v) => v as List<dynamic>?),
      underscoreId: $checkedConvert(
        '_id',
        (v) =>
            v == null ? null : UnderscoreId.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {'underscoreId': '_id'},
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

GiftList _$GiftListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GiftList', json, ($checkedConvert) {
      final val = GiftList(gift: $checkedConvert('gift', (v) => v as bool?));
      return val;
    });

Map<String, dynamic> _$GiftListToJson(GiftList instance) => <String, dynamic>{
  'gift': instance.gift,
};

EventTime _$EventTimeFromJson(Map<String, dynamic> json) => $checkedCreate(
  'EventTime',
  json,
  ($checkedConvert) {
    final val = EventTime(date: $checkedConvert(r'$date', (v) => v as String));
    return val;
  },
  fieldKeyMap: const {'date': r'$date'},
);

Map<String, dynamic> _$EventTimeToJson(EventTime instance) => <String, dynamic>{
  r'$date': instance.date,
};

EntryHistory _$EntryHistoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('EntryHistory', json, ($checkedConvert) {
      final val = EntryHistory(
        cid: $checkedConvert('cid', (v) => (v as num?)?.toInt()),
        disbool: $checkedConvert('disbool', (v) => v as bool?),
        done: $checkedConvert('done', (v) => v as bool?),
        freep: $checkedConvert('freep', (v) => (v as num?)?.toDouble()),
        inittime: $checkedConvert(
          'inittime',
          (v) =>
              v == null ? null : InitTime.fromJson(v as Map<String, dynamic>),
        ),
        mid: $checkedConvert('mid', (v) => v as String?),
        ticn: $checkedConvert('ticn', (v) => v as String?),
        price: $checkedConvert('price', (v) => (v as num?)?.toDouble()),
        sid: $checkedConvert('sid', (v) => v as String?),
        status: $checkedConvert('status', (v) => v as String?),
        time: $checkedConvert('time', (v) => v as String?),
        uid: $checkedConvert('uid', (v) => v as String?),
        underscoreId: $checkedConvert(
          '_id',
          (v) => v == null
              ? null
              : UnderscoreId.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    }, fieldKeyMap: const {'underscoreId': '_id'});

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
    $checkedCreate('QuestCampaign', json, ($checkedConvert) {
      final val = QuestCampaign(
        rawCouid: $checkedConvert('couid', (v) => v as String),
        rawLpic: $checkedConvert('lpic', (v) => v as String),
        lpicshow: $checkedConvert('lpicshow', (v) => v as bool),
        mid: $checkedConvert(
          'mid',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        spic: $checkedConvert('spic', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'rawCouid': 'couid', 'rawLpic': 'lpic'});

Map<String, dynamic> _$QuestCampaignToJson(QuestCampaign instance) =>
    <String, dynamic>{
      'couid': instance.rawCouid,
      'lpic': instance.rawLpic,
      'lpicshow': instance.lpicshow,
      'mid': instance.mid,
      'spic': instance.spic,
    };
