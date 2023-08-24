import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class UserModel {
  final String message;
  final int code;
  @JsonKey(name: "userimg")
  final String? rawUserImgUrl;
  final String? email;
  final String? uid;
  final double? point;
  final String? name;
  final int? ticketint;
  final int? fpoint;
  final int? givebool;

  /// 手機是否驗證
  final bool? phoneactive;

  /// 是否有月票身分
  final bool? vip;
  final VipDate? vipdate;
  final String? sid;
  final String? sixn;
  final int? tphone;
  final String? doorpwd;

  UserModel(
      {required this.message,
      required this.code,
      this.rawUserImgUrl,
      this.email,
      this.uid,
      this.point,
      this.name,
      this.ticketint,
      this.phoneactive,
      this.fpoint,
      this.givebool,
      this.vip,
      this.vipdate,
      this.sid,
      this.sixn,
      this.tphone,
      this.doorpwd});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get userImageUrl => rawUserImgUrl == null
      ? "https://pay.x50.fun/static/logo.jpg"
      : "$rawUserImgUrl&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg";
  bool get hasTicket => ticketint != null && ticketint! > 0;
  bool get isStaff => uid != null && uid!.startsWith('X');
  bool get isInsertGod => uid != null && uid!.startsWith('v');

  @override
  String toString() {
    return 'UserModel(message: $message, code: $code, userimg: $rawUserImgUrl, email: $email, uid: $uid, point: $point, name: $name, ticketint: $ticketint, phoneactive: $phoneactive, vip: $vip, vipdate: $vipdate, sid: $sid, sixn: $sixn, tphone: $tphone, doorpwd: $doorpwd)';
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
