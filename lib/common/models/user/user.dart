import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class UserModel {
  final String message;
  final int code;
  final String? userimg;
  final String? email;
  final String? uid;
  final double? point;
  final String? name;
  final int? ticketint;
  final bool? phoneactive;
  final bool? vip;
  final VipDate? vipdate;
  final String? sid;
  final String? sixn;
  final int? tphone;
  final String? doorpwd;

  UserModel(
      {required this.message,
      required this.code,
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
      this.doorpwd});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return 'UserModel(message: $message, code: $code, userimg: $userimg, email: $email, uid: $uid, point: $point, name: $name, ticketint: $ticketint, phoneactive: $phoneactive, vip: $vip, vipdate: $vipdate, sid: $sid, sixn: $sixn, tphone: $tphone, doorpwd: $doorpwd)';
  }
}

@JsonSerializable()
class VipDate {
  @JsonKey(name: "\$date")
  final int date;

  const VipDate({required this.date});

  factory VipDate.fromJson(Map<String, dynamic> json) =>
      _$VipDateFromJson(json);
  Map<String, dynamic> toJson() => _$VipDateToJson(this);
}
