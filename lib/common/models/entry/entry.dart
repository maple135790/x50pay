// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';

@immutable
class Entry {
  final String? message;
  final int? code;
  final List<dynamic>? grade;
  final List<Evlist>? evlist;
  final List<List<History>?>? history;
  final Giftlist? giftlist;

  const Entry({
    this.message,
    this.code,
    this.grade,
    this.evlist,
    this.history,
    this.giftlist,
  });

  @override
  String toString() {
    return 'Entry(message: $message, code: $code, grade: $grade, evlist: $evlist, history: $history, giftlist: $giftlist)';
  }

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
        message: json['message'] as String?,
        code: json['code'] as int?,
        grade: json['grade'] as List<dynamic>?,
        evlist: (json['evlist'] as List<dynamic>?)
            ?.map((e) => Evlist.fromJson(e as Map<String, dynamic>))
            .toList(),
        history: [
          (json['history'][0] as List<dynamic>?)
              ?.map((e) => History.fromJson(e as Map<String, dynamic>))
              .toList(),
          (json['history'][1] as List<dynamic>?)
              ?.map((e) => History.fromJson(e as Map<String, dynamic>))
              .toList(),
        ],
        giftlist:
            json['giftlist'] == null ? null : Giftlist.fromJson(json['giftlist'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
        'grade': grade,
        'evlist': evlist?.map((e) => e.toJson()).toList(),
        'history': [
          history?[0]?.map((e) => e.toJson()).toList(),
          history?[1]?.map((e) => e.toJson()).toList(),
        ],
        'giftlist': giftlist?.toJson(),
      };

  Entry copyWith({
    String? message,
    int? code,
    List<dynamic>? grade,
    List<Evlist>? evlist,
    List<List<History>>? history,
    Giftlist? giftlist,
  }) {
    return Entry(
      message: message ?? this.message,
      code: code ?? this.code,
      grade: grade ?? this.grade,
      evlist: evlist ?? this.evlist,
      history: history ?? history,
      giftlist: giftlist ?? giftlist,
    );
  }
}

@immutable
class End {
  final int? date;

  const End({this.date});

  @override
  String toString() => 'End(date: $date)';

  factory End.fromJson(Map<String, dynamic> json) => End(
        date: json['\$date'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '\$date': date,
      };

  End copyWith({
    int? date,
  }) {
    return End(
      date: date ?? this.date,
    );
  }
}

@immutable
class Giftlist {
  final bool? gift;

  const Giftlist({this.gift});

  @override
  String toString() => 'Giftlist(gift: $gift)';

  factory Giftlist.fromJson(Map<String, dynamic> json) => Giftlist(
        gift: json['gift'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'gift': gift,
      };

  Giftlist copyWith({
    bool? gift,
  }) {
    return Giftlist(
      gift: gift ?? this.gift,
    );
  }
}

@immutable
class History {
  final P_Id? id;
  final String? uid;
  final String? sid;
  final String? mid;
  final int? cid;
  final Inittime? inittime;
  final String? status;
  final bool? done;
  final bool? disbool;
  final int? freep;
  final int? price;
  final String? time;
  final String? ticn;

  const History({
    this.id,
    this.uid,
    this.sid,
    this.mid,
    this.cid,
    this.inittime,
    this.status,
    this.done,
    this.disbool,
    this.freep,
    this.price,
    this.time,
    this.ticn,
  });

  @override
  String toString() {
    return 'History(id: $id, uid: $uid, sid: $sid, mid: $mid, cid: $cid, inittime: $inittime, status: $status, done: $done, disbool: $disbool, freep: $freep, price: $price, time: $time, ticn: $ticn)';
  }

  factory History.fromJson(Map<String, dynamic> json) => History(
        id: json['_id'] == null ? null : P_Id.fromJson(json['_id'] as Map<String, dynamic>),
        uid: json['uid'] as String?,
        sid: json['sid'] as String?,
        mid: json['mid'] as String?,
        cid: json['cid'] as int?,
        inittime:
            json['inittime'] == null ? null : Inittime.fromJson(json['inittime'] as Map<String, dynamic>),
        status: json['status'] as String?,
        done: json['done'] as bool?,
        disbool: json['disbool'] as bool?,
        freep: json['freep'] as int?,
        price: json['price'] as int?,
        time: json['time'] as String?,
        ticn: json['ticn'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id?.toJson(),
        'uid': uid,
        'sid': sid,
        'mid': mid,
        'cid': cid,
        'inittime': inittime?.toJson(),
        'status': status,
        'done': done,
        'disbool': disbool,
        'freep': freep,
        'price': price,
        'time': time,
        'ticn': ticn,
      };

  History copyWith({
    P_Id? id,
    String? uid,
    String? sid,
    String? mid,
    int? cid,
    Inittime? inittime,
    String? status,
    bool? done,
    bool? disbool,
    int? freep,
    int? price,
    String? time,
    String? ticn,
  }) {
    return History(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      sid: sid ?? this.sid,
      mid: mid ?? this.mid,
      cid: cid ?? this.cid,
      inittime: inittime ?? this.inittime,
      status: status ?? this.status,
      done: done ?? this.done,
      disbool: disbool ?? this.disbool,
      freep: freep ?? this.freep,
      price: price ?? this.price,
      time: time ?? this.time,
      ticn: ticn ?? this.ticn,
    );
  }
}

@immutable
class P_Id {
  final String? oid;

  const P_Id({this.oid});

  @override
  String toString() => 'Id(oid: $oid)';

  factory P_Id.fromJson(Map<String, dynamic> json) => P_Id(
        oid: json['\$oid'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '\$oid': oid,
      };

  P_Id copyWith({
    String? oid,
  }) {
    return P_Id(
      oid: oid ?? this.oid,
    );
  }
}

@immutable
class Inittime {
  final int? date;

  const Inittime({this.date});

  @override
  String toString() => 'Inittime(date: $date)';

  factory Inittime.fromJson(Map<String, dynamic> json) => Inittime(
        date: json['\$date'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '\$date': date,
      };

  Inittime copyWith({
    int? date,
  }) {
    return Inittime(
      date: date ?? this.date,
    );
  }
}

@immutable
class Start {
  final int? date;

  const Start({this.date});

  @override
  String toString() => 'Start(date: $date)';

  factory Start.fromJson(Map<String, dynamic> json) => Start(
        date: json['\$date'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '\$date': date,
      };

  Start copyWith({
    int? date,
  }) {
    return Start(
      date: date ?? this.date,
    );
  }
}

@immutable
class Evlist {
  final P_Id? p_id;
  final String? name;
  final List<dynamic>? which;
  final String? describe;
  final String? count;
  final Start? start;
  final End? end;
  final bool? point;
  final int? value;
  final int? limit;
  final String? countday;
  final String? id;
  final List<dynamic>? ticMid;
  final String? sid;
  final String? ticdis;

  const Evlist({
    this.p_id,
    this.name,
    this.which,
    this.describe,
    this.count,
    this.start,
    this.end,
    this.point,
    this.value,
    this.limit,
    this.countday,
    this.id,
    this.ticMid,
    this.sid,
    this.ticdis,
  });

  @override
  String toString() {
    return 'Evlist(_id: $p_id, name: $name, which: $which, describe: $describe, count: $count, start: $start, end: $end, point: $point, value: $value, limit: $limit, countday: $countday, id: $id, ticMid: $ticMid, sid: $sid, ticdis: $ticdis)';
  }

  factory Evlist.fromJson(Map<String, dynamic> json) => Evlist(
        p_id: json['_id'] == null ? null : P_Id.fromJson(json['_id'] as Map<String, dynamic>),
        name: json['name'] as String?,
        which: json['which'] as List<dynamic>?,
        describe: json['describe'] as String?,
        count: json['count'] as String?,
        start: json['start'] == null ? null : Start.fromJson(json['start'] as Map<String, dynamic>),
        end: json['end'] == null ? null : End.fromJson(json['end'] as Map<String, dynamic>),
        point: json['point'] as bool?,
        value: json['value'] as int?,
        limit: json['limit'] as int?,
        countday: json['countday'] as String?,
        id: json['id'] as String?,
        ticMid: json['ticMid'] as List<dynamic>?,
        sid: json['sid'] as String?,
        ticdis: json['ticdis'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': p_id?.toJson(),
        'name': name,
        'which': which,
        'describe': describe,
        'count': count,
        'start': start?.toJson(),
        'end': end?.toJson(),
        'point': point,
        'value': value,
        'limit': limit,
        'countday': countday,
        'id': p_id,
        'ticMid': ticMid,
        'sid': sid,
        'ticdis': ticdis,
      };

  Evlist copyWith({
    P_Id? uid,
    String? name,
    List<dynamic>? which,
    String? describe,
    String? count,
    Start? start,
    End? end,
    bool? point,
    int? value,
    int? limit,
    String? countday,
    String? id,
    List<dynamic>? ticMid,
    String? sid,
    String? ticdis,
  }) {
    return Evlist(
      p_id: uid ?? p_id,
      name: name ?? this.name,
      which: which ?? this.which,
      describe: describe ?? this.describe,
      count: count ?? this.count,
      start: start ?? this.start,
      end: end ?? this.end,
      point: point ?? this.point,
      value: value ?? this.value,
      limit: limit ?? this.limit,
      countday: countday ?? this.countday,
      id: id ?? this.id,
      ticMid: ticMid ?? this.ticMid,
      sid: sid ?? this.sid,
      ticdis: ticdis ?? this.ticdis,
    );
  }
}

Entry testEntry = const Entry(
  message: 'done',
  code: 200,
  grade: [0, 999999, 999999, "0/0", ""],
  giftlist: Giftlist(gift: false),
  evlist: [
    Evlist(
      p_id: P_Id(oid: "62a646a3ec1b194108944457"),
      name: '暑假前哨活動',
      which: [],
      describe: '於全體系使用付費 Point 遊玩任意機種 3 道送該機種全店遊玩券1張（隔日發放）[6/12-6/26]',
      count: '2',
      start: Start(date: 1655395200000),
      end: End(date: 1655481599000),
      point: false,
      value: 0,
      limit: 5,
      countday: "1",
      id: '220617',
      ticMid: [],
      sid: "0",
      ticdis: "全店可用",
    )
  ],
  history: [
    [
      History(
          id: P_Id(oid: "62a74bfd4fa5d263c1a434e3"),
          uid: '938',
          sid: '7037656',
          mid: '[西門] Jubeat',
          cid: 1,
          inittime: Inittime(date: 1655131133071),
          status: 'payment done',
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfd4fa5d263c1a434e3"),
          uid: '938',
          sid: '7037656',
          mid: '[西門] Jubeat',
          cid: 1,
          inittime: Inittime(date: 1655131133071),
          status: 'payment done',
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
      History(
          id: P_Id(oid: "62a74bfc068521b28ed06aa8"),
          uid: "938",
          sid: "7037656",
          mid: "[西門] Jubeat",
          cid: 1,
          inittime: Inittime(date: 1655131132257),
          status: "payment done",
          done: true,
          disbool: true,
          freep: 0,
          price: 19,
          time: "2022年06月13日] [22 : 38"),
    ],
    [
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
      History(
          id: P_Id(oid: '62a5f52b068521b28ed06950'),
          uid: "938",
          mid: "[西門] DanceDanceRevolution",
          cid: 1,
          price: 27,
          disbool: false,
          ticn: "月票無期限遊玩卷",
          sid: "7037656",
          time: "2022年06月12日] [22 : 16"),
    ],
  ],
);
