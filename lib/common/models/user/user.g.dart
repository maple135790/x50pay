// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UserModel', json, ($checkedConvert) {
      final val = UserModel(
        message: $checkedConvert('message', (v) => v as String),
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        rawUserImgUrl: $checkedConvert('userimg', (v) => v as String?),
        email: $checkedConvert('email', (v) => v as String?),
        uid: $checkedConvert('uid', (v) => v as String?),
        point: $checkedConvert('point', (v) => (v as num?)?.toDouble()),
        name: $checkedConvert('name', (v) => v as String?),
        ticketint: $checkedConvert('ticketint', (v) => (v as num?)?.toInt()),
        phoneactive: $checkedConvert('phoneactive', (v) => v as bool?),
        fpoint: $checkedConvert('fpoint', (v) => (v as num?)?.toDouble()),
        givebool: $checkedConvert('givebool', (v) => (v as num?)?.toInt()),
        vip: $checkedConvert('vip', (v) => v as bool?),
        vipdate: $checkedConvert(
          'vipdate',
          (v) => v == null ? null : VipDate.fromJson(v as Map<String, dynamic>),
        ),
        sid: $checkedConvert('sid', (v) => v as String?),
        sixn: $checkedConvert('sixn', (v) => v as String?),
        tphone: $checkedConvert('tphone', (v) => v as String?),
        doorpwd: $checkedConvert('doorpwd', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'rawUserImgUrl': 'userimg'});

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'message': instance.message,
  'code': instance.code,
  'userimg': instance.rawUserImgUrl,
  'email': instance.email,
  'uid': instance.uid,
  'point': instance.point,
  'name': instance.name,
  'ticketint': instance.ticketint,
  'fpoint': instance.fpoint,
  'givebool': instance.givebool,
  'phoneactive': instance.phoneactive,
  'vip': instance.vip,
  'vipdate': instance.vipdate,
  'sid': instance.sid,
  'sixn': instance.sixn,
  'tphone': instance.tphone,
  'doorpwd': instance.doorpwd,
};

VipDate _$VipDateFromJson(Map<String, dynamic> json) => $checkedCreate(
  'VipDate',
  json,
  ($checkedConvert) {
    final val = VipDate(rawDate: $checkedConvert(r'$date', (v) => v as String));
    return val;
  },
  fieldKeyMap: const {'rawDate': r'$date'},
);

Map<String, dynamic> _$VipDateToJson(VipDate instance) => <String, dynamic>{
  r'$date': instance.rawDate,
};
