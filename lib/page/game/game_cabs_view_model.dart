import 'dart:developer';

import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/repository.dart';

class GameCabsViewModel extends BaseViewModel {
  final Repository repository;

  GameCabsViewModel({required this.repository});

  late String storeName;

  Future<String?> getStoreName() async {
    final storeName = Prefs.getString(PrefsToken.storeName);
    return storeName;
  }

  Future<GameList?> getGamelist() async {
    try {
      final sid = await Prefs.getString(PrefsToken.storeId);
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
