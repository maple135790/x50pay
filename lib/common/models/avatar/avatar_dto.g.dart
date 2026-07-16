// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvatarDTO _$AvatarDTOFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AvatarDTO', json, ($checkedConvert) {
      final val = AvatarDTO(
        $checkedConvert(
          'result',
          (v) => (v as List<dynamic>)
              .map((e) => Avatar.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        code: $checkedConvert('code', (v) => (v as num).toInt()),
        message: $checkedConvert('message', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'avatars': 'result'});
