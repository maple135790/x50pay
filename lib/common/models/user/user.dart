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

  const UserModel({
    required this.message,
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
    this.doorpwd,
  });

  const UserModel.empty()
      : message = "",
        code = 0,
        rawUserImgUrl = "",
        email = "",
        uid = "",
        point = 0,
        name = "",
        ticketint = 0,
        phoneactive = false,
        fpoint = 0,
        givebool = 0,
        vip = false,
        vipdate = null,
        sid = "",
        sixn = "",
        tphone = 0,
        doorpwd = "";

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

  @override
  operator ==(other) {
    return other is UserModel && other.hashCode == hashCode;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        code.hashCode ^
        rawUserImgUrl.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        point.hashCode ^
        name.hashCode ^
        ticketint.hashCode ^
        phoneactive.hashCode ^
        fpoint.hashCode ^
        givebool.hashCode ^
        vip.hashCode ^
        vipdate.hashCode ^
        sid.hashCode ^
        sixn.hashCode ^
        tphone.hashCode ^
        doorpwd.hashCode;
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
