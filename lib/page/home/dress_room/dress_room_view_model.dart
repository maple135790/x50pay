import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/home/dress_room/dress_room.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

class DressRoomViewModel extends BaseViewModel {
  static const avatarUrl = 'https://pay.x50.fun/api/v1/list/avater';
  List<Avatar> avatars = [];
  final client = http.Client();
  final repo = Repository();

  Future<List<Avatar>> init() async {
    const parentSelector = 'body > div > div > div';

    try {
      late String rawDoc;
      if (!kDebugMode || isForceFetch) {
        final response = await repo.getAvatar();
        if (response.statusCode != 200) {
          throw Exception('statusCode: ${response.statusCode}');
        }
        rawDoc = response.body;
      } else {
        rawDoc = await R.text.avater_txt();
      }
      final doc = html.parse(rawDoc, encoding: 'utf8');
      final parents = doc.querySelectorAll(parentSelector);
      for (var parent in parents) {
        avatars.add((
          b64Image: parent.children[0].attributes['src']!
              .split('data:image/webp;base64,')
              .last,
          id: parent.children[0].attributes['onclick']?.split("'")[1],
          badgeText:
              parent.children[1].querySelector('div > div > div')!.text.trim(),
        ));
      }
    } catch (e) {
      log(e.toString(), name: 'DressRoomViewModel init');
    }
    return avatars;
  }

  Future<String> setAvatar(String id) async {
    String text = '';
    EasyLoading.show();
    if (!kDebugMode || isForceFetch) {
      final response = await repo.setAvatar(id);
      text = response.body;
    } else {
      text = '成功更換衣裝';
    }
    EasyLoading.dismiss();

    return text;
  }
}
