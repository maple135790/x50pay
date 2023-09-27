import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/repository/repository.dart';

class GameCabsViewModel extends BaseViewModel {
  final Repository repository;

  GameCabsViewModel({required this.repository});

  late String storeName;

  Future<String?> getStoreName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('store_name');
  }

  Future<GameList?> getGamelist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sid = prefs.getString('store_id');

      if (sid == null) return null;

      late final GameList gamelist;
      showLoading();

      storeName = await getStoreName() ?? '';
      gamelist = await repository.getGameList(storeId: sid);
      return gamelist;
    } catch (e) {
      log('', error: '$e', name: 'getGamelist');
      return null;
    } finally {
      dismissLoading();
    }
  }
}
