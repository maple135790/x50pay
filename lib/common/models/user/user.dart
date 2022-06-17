import 'package:flutter/material.dart';
import 'package:x50pay/common/models/user/vipdate.dart';

@immutable
class User {
  final String? message;
  final int? code;
  final String? userimg;
  final String? email;
  final String? uid;
  final int? point;
  final String? name;
  final int? ticketint;
  final bool? phoneactive;
  final bool? vip;
  final Vipdate? vipdate;
  final String? sid;
  final String? sixn;
  final int? tphone;
  final String? doorpwd;

  const User({
    this.message,
    this.code,
    this.userimg,
    this.email,
    this.uid,
    this.point,
    this.name,
    this.ticketint,
    this.phoneactive,
    this.vip,
    this.vipdate,
    this.sid,
    this.sixn,
    this.tphone,
    this.doorpwd,
  });

  @override
  String toString() {
    return 'User(message: $message, code: $code, userimg: $userimg, email: $email, uid: $uid, point: $point, name: $name, ticketint: $ticketint, phoneactive: $phoneactive, vip: $vip, vipdate: $vipdate, sid: $sid, sixn: $sixn, tphone: $tphone, doorpwd: $doorpwd)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        message: json['message'] as String?,
        code: json['code'] as int?,
        userimg: json['userimg'] as String?,
        email: json['email'] as String?,
        uid: json['uid'] as String?,
        point: json['point'] as int?,
        name: json['name'] as String?,
        ticketint: json['ticketint'] as int?,
        phoneactive: json['phoneactive'] as bool?,
        vip: json['vip'] as bool?,
        vipdate: json['vipdate'] == null ? null : Vipdate.fromJson(json['vipdate'] as Map<String, dynamic>),
        sid: json['sid'] as String?,
        sixn: json['sixn'] as String?,
        tphone: json['tphone'] as int?,
        doorpwd: json['doorpwd'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
        'userimg': userimg,
        'email': email,
        'uid': uid,
        'point': point,
        'name': name,
        'ticketint': ticketint,
        'phoneactive': phoneactive,
        'vip': vip,
        'vipdate': vipdate?.toJson(),
        'sid': sid,
        'sixn': sixn,
        'tphone': tphone,
        'doorpwd': doorpwd,
      };

  User copyWith({
    String? message,
    int? code,
    String? userimg,
    String? email,
    String? uid,
    int? point,
    String? name,
    int? ticketint,
    bool? phoneactive,
    bool? vip,
    Vipdate? vipdate,
    String? sid,
    String? sixn,
    int? tphone,
    String? doorpwd,
  }) {
    return User(
      message: message ?? this.message,
      code: code ?? this.code,
      userimg: userimg ?? this.userimg,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      point: point ?? this.point,
      name: name ?? this.name,
      ticketint: ticketint ?? this.ticketint,
      phoneactive: phoneactive ?? this.phoneactive,
      vip: vip ?? this.vip,
      vipdate: vipdate ?? this.vipdate,
      sid: sid ?? this.sid,
      sixn: sixn ?? this.sixn,
      tphone: tphone ?? this.tphone,
      doorpwd: doorpwd ?? this.doorpwd,
    );
  }
}

User testUser = const User(
    message: "done",
    code: 200,
    userimg: 'https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250',
    email: "maple135790@gmail.com",
    uid: '938',
    point: 222,
    name: "鯖缶",
    ticketint: 9,
    phoneactive: true,
    vip: true,
    vipdate: Vipdate(date: 1657660411780),
    sid: "",
    sixn: "575707",
    tphone: 1,
    doorpwd: "本期門禁密碼爲 : 1743#");

/*
{
  "message": "done",
  "code": 200,
  "userimg": "https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250",
  "email": "maple135790@gmail.com",
  "uid": "938",
  "point": 222,
  "name": "鯖缶",
  "ticketint": 9,
  "phoneactive": true,
  "vip": true,
  "vipdate": {
    "$date": 1657660411780
  },
  "sid": "",
  "sixn": "575707",
  "tphone": 1,
  "doorpwd": "本期門禁密碼爲 : 1743#"
}
 */