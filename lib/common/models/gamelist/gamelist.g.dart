// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamelist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameList _$GamelistFromJson(Map<String, dynamic> json) => GameList(
      message: json['message'] as String?,
      code: json['code'] as int?,
      machine: (json['machinelist'] as List<dynamic>?)
          ?.map((e) => Machine.fromJson(e as Map<String, dynamic>))
          .toList(),
      payMid: json['payMid'] as String?,
      payLid: json['payLid'] as String?,
      payCid: json['payCid'] as String?,
    );

Map<String, dynamic> _$GamelistToJson(GameList instance) => <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'machinelist': instance.machine,
      'payMid': instance.payMid,
      'payLid': instance.payLid,
      'payCid': instance.payCid,
    };

Machine _$MachineFromJson(Map<String, dynamic> json) => Machine(
      json['lable'] as String?,
      (json['price'] as num?)?.toDouble(),
      json['discount'] as num?,
      json['downprice'],
      (json['mode'] as List<dynamic>?)?.map((e) => e as List<dynamic>).toList(),
      json['note'] as List<dynamic>?,
      (json['cabinet_detail'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as Map<String, dynamic>),
      ),
      json['cabinet'] as num?,
      json['enable'] as bool?,
      json['id'] as String?,
      json['shop'] as String?,
      json['lora'] as bool?,
      json['pad'] as bool?,
      json['padlid'] as String?,
      json['padmid'] as String?,
      (json['qcounter'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      json['quic'] as bool?,
      json['vipb'] as bool?,
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
