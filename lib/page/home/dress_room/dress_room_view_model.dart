import 'dart:developer';

import 'package:html/parser.dart' as html;
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/home/dress_room/dress_room.dart';
import 'package:x50pay/repository/repository.dart';

class DressRoomViewModel extends BaseViewModel {
  final Repository repository;

  DressRoomViewModel({required this.repository});

  static const avatarUrl = 'https://pay.x50.fun/api/v1/list/avater';
  List<Avatar> avatars = [];

  Future<List<Avatar>> getAvatars() async {
    const parentSelector = 'body > div > div > div';

    try {
      late String rawDoc;
      final response = await repository.getAvatar();
      if (response.statusCode != 200) {
        throw Exception('statusCode: ${response.statusCode}');
      }
      rawDoc = response.body;
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
      log('', name: 'DressRoomViewModel init', error: e);
    }
    return avatars;
  }

  Future<String> setAvatar(String id) async {
    String text = '';
    showLoading();
    final response = await repository.setAvatar(id);
    text = response.body;
    dismissLoading();

    return text;
  }
}
