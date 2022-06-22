// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gamelist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gamelist _$GamelistFromJson(Map<String, dynamic> json) => Gamelist(
      message: json['message'] as String?,
      code: json['code'] as int?,
      machineList: (json['machinelist'] as List<dynamic>?)
          ?.map((e) => MachineList.fromJson(e as Map<String, dynamic>))
          .toList(),
      payMid: json['payMid'] as String?,
      payLid: json['payLid'] as String?,
      payCid: json['payCid'] as String?,
    );

Map<String, dynamic> _$GamelistToJson(Gamelist instance) => <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'machinelist': instance.machineList,
      'payMid': instance.payMid,
      'payLid': instance.payLid,
      'payCid': instance.payCid,
    };

MachineList _$MachineListFromJson(Map<String, dynamic> json) => MachineList(
      json['lable'] as String?,
      json['price'] as int?,
      json['discount'] as num?,
      json['downprice'],
      (json['mode'] as List<dynamic>?)?.map((e) => e as List<dynamic>).toList(),
      json['note'] as List<dynamic>?,
      (json['cabinet_detail'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), e as Map<String, dynamic>),
      ),
      json['cabinet'] as int?,
      json['enable'] as bool?,
      json['id'] as String?,
      json['shop'] as String?,
      json['lora'] as bool?,
      json['pad'] as bool?,
      json['padlid'] as String?,
      json['padmid'] as String?,
      (json['qcounter'] as List<dynamic>?)?.map((e) => e as int).toList(),
      json['quic'] as bool?,
      json['vipb'] as bool?,
    );

Map<String, dynamic> _$MachineListToJson(MachineList instance) =>
    <String, dynamic>{
      'lable': instance.lable,
      'price': instance.price,
      'discount': instance.discount,
      'downprice': instance.downPrice,
      'mode': instance.mode,
      'note': instance.note,
      'cabinet_detail':
          instance.cabDatail?.map((k, e) => MapEntry(k.toString(), e)),
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
