import 'package:json_annotation/json_annotation.dart';
import 'package:x50pay/common/global_singleton.dart';
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
  final double? fpoint;
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

  const UserModel(
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

  static VipDate setVipDate(String unixTimestamp) =>
      VipDate(rawDate: unixTimestamp);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  String get userImageUrl => rawUserImgUrl == null
      ? "https://pay.x50.fun/static/logo.jpg"
      : "$rawUserImgUrl&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg";
  String get settingsUserImageUrl => _getSettingsUserImageUrl();
  bool get hasTicket => ticketint != null && ticketint! > 0;
  bool get isStaff => uid != null && uid!.startsWith('X');
  bool get isInsertGod => uid != null && uid!.startsWith('v');

  String _getSettingsUserImageUrl() {
    if (!GlobalSingleton.instance.isServiceOnline) {
      return "https://pay.x50.fun/static/logo.jpg";
    }
    if (rawUserImgUrl!.contains('size')) {
      return '${rawUserImgUrl!.split('size').first}size=80&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg';
    } else {
      return rawUserImgUrl! +
          r"&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg";
    }
  }

  @override
  String toString() {
    return 'UserModel(message: $message, code: $code, userimg: $rawUserImgUrl, email: $email, uid: $uid, point: $point, name: $name, ticketint: $ticketint, phoneactive: $phoneactive, vip: $vip, vipdate: $vipdate, sid: $sid, sixn: $sixn, tphone: $tphone, doorpwd: $doorpwd)';
  }

  bool equals(UserModel user) {
    return email == user.email &&
        uid == user.uid &&
        point == user.point &&
        name == user.name &&
        ticketint == user.ticketint &&
        phoneactive == user.phoneactive &&
        fpoint == user.fpoint &&
        givebool == user.givebool &&
        vip == user.vip &&
        vipdate == user.vipdate &&
        sid == user.sid &&
        sixn == user.sixn &&
        tphone == user.tphone &&
        rawUserImgUrl == user.rawUserImgUrl &&
        doorpwd == user.doorpwd;
  }
}

@JsonSerializable()
class VipDate {
  @JsonKey(name: "\$date")
  final String rawDate;

  const VipDate({required this.rawDate});

  factory VipDate.fromJson(Map<String, dynamic> json) =>
      _$VipDateFromJson(json);
  Map<String, dynamic> toJson() => _$VipDateToJson(this);
}
