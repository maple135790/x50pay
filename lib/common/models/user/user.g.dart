// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      message: json['message'] as String,
      code: json['code'] as int,
      userimg: json['userimg'] as String?,
      email: json['email'] as String?,
      uid: json['uid'] as String?,
      point: (json['point'] as num?)?.toDouble(),
      name: json['name'] as String?,
      ticketint: json['ticketint'] as int?,
      phoneactive: json['phoneactive'] as bool?,
      vip: json['vip'] as bool?,
      vipdate: json['vipdate'] == null
          ? null
          : VipDate.fromJson(json['vipdate'] as Map<String, dynamic>),
      sid: json['sid'] as String?,
      sixn: json['sixn'] as String?,
      tphone: json['tphone'] as int?,
      doorpwd: json['doorpwd'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
      'userimg': instance.userimg,
      'email': instance.email,
      'uid': instance.uid,
      'point': instance.point,
      'name': instance.name,
      'ticketint': instance.ticketint,
      'phoneactive': instance.phoneactive,
      'vip': instance.vip,
      'vipdate': instance.vipdate,
      'sid': instance.sid,
      'sixn': instance.sixn,
      'tphone': instance.tphone,
      'doorpwd': instance.doorpwd,
    };

VipDate _$VipDateFromJson(Map<String, dynamic> json) => VipDate(
      date: json[r'$date'] as int,
    );

Map<String, dynamic> _$VipDateToJson(VipDate instance) => <String, dynamic>{
      r'$date': instance.date,
    };
