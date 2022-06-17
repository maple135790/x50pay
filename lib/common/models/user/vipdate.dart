import 'package:flutter/material.dart';

@immutable
class Vipdate {
  final int? date;

  const Vipdate({this.date});

  @override
  String toString() => 'Vipdate(date: $date)';

  factory Vipdate.fromJson(Map<String, dynamic> json) =>
      Vipdate(date: json['date'] as int?);

  Map<String, dynamic> toJson() => {'$date': date};

  Vipdate copyWith({int? date}) {
    return Vipdate(date: date ?? this.date);
  }
}
