// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotte_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LotteListModel _$LotteListModelFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LotteListModel', json, ($checkedConvert) {
      final val = LotteListModel(
        $checkedConvert('list', (v) => v as List<dynamic>),
      );
      return val;
    }, fieldKeyMap: const {'rawLotteList': 'list'});

Map<String, dynamic> _$LotteListModelToJson(LotteListModel instance) =>
    <String, dynamic>{'list': instance.rawLotteList};
