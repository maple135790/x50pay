// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamelist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameList _$GameListFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GameList', json, ($checkedConvert) {
      final val = GameList(
        message: $checkedConvert('message', (v) => v as String?),
        code: $checkedConvert('code', (v) => (v as num?)?.toInt()),
        machines: $checkedConvert(
          'machinelist',
          (v) => (v as List<dynamic>?)
              ?.map((e) => Machine.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        payMid: $checkedConvert('payMid', (v) => v as String?),
        payLid: $checkedConvert('payLid', (v) => v as String?),
        payCid: $checkedConvert('payCid', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'machines': 'machinelist'});

Map<String, dynamic> _$GameListToJson(GameList instance) => <String, dynamic>{
  'message': instance.message,
  'code': instance.code,
  'machinelist': instance.machines,
  'payMid': instance.payMid,
  'payLid': instance.payLid,
  'payCid': instance.payCid,
};

Machine _$MachineFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Machine',
  json,
  ($checkedConvert) {
    final val = Machine(
      $checkedConvert('lable', (v) => v as String?),
      $checkedConvert('price', (v) => (v as num?)?.toDouble()),
      $checkedConvert('discount', (v) => v as num?),
      $checkedConvert('downprice', (v) => v),
      $checkedConvert(
        'mode',
        (v) => (v as List<dynamic>?)?.map((e) => e as List<dynamic>).toList(),
      ),
      $checkedConvert('note', (v) => v as List<dynamic>?),
      $checkedConvert(
        'cabinet_detail',
        (v) => (v as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(k, e as Map<String, dynamic>),
        ),
      ),
      $checkedConvert('cabinet', (v) => v as num?),
      $checkedConvert('enable', (v) => v as bool?),
      $checkedConvert('id', (v) => v as String?),
      $checkedConvert('shop', (v) => v as String?),
      $checkedConvert('lora', (v) => v as bool?),
      $checkedConvert('pad', (v) => v as bool?),
      $checkedConvert('padlid', (v) => v as String?),
      $checkedConvert('padmid', (v) => v as String?),
      $checkedConvert(
        'qcounter',
        (v) =>
            (v as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList(),
      ),
      $checkedConvert('quic', (v) => v as bool?),
      $checkedConvert('vipb', (v) => v as bool?),
    );
    return val;
  },
  fieldKeyMap: const {'downPrice': 'downprice', 'cabDatail': 'cabinet_detail'},
);

Map<String, dynamic> _$MachineToJson(Machine instance) => <String, dynamic>{
  'lable': instance.lable,
  'price': instance.price,
  'discount': instance.discount,
  'downprice': instance.downPrice,
  'mode': instance.mode,
  'note': instance.note,
  'cabinet_detail': instance.cabDatail,
  'cabinet': instance.cabinet,
  'enable': instance.enable,
  'id': instance.id,
  'shop': instance.shop,
  'lora': instance.lora,
  'pad': instance.pad,
  'padlid': instance.padlid,
  'padmid': instance.padmid,
  'qcounter': instance.qcounter,
  'quic': instance.quic,
  'vipb': instance.vipb,
};
