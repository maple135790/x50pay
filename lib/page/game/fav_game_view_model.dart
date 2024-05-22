import 'dart:developer';
import 'dart:ui';

import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/repository.dart';

class FavGameViewModel extends BaseViewModel {
  final Repository repository;
  final Locale currentLocale;

  FavGameViewModel({
    required this.repository,
    required this.currentLocale,
  });

  final selectedFavMachines = <String>[];
  final storeNameMap = <String, String>{};
  var _storeModel = const StoreModel.empty();
  var _fetchedGameList = const GameList.empty();

  GameList get favGameList => _favGameList;
  GameList _favGameList = const GameList.empty();

  GameCabTileStyle get tileStyle => _tileStyle;
  GameCabTileStyle _tileStyle =
      GameCabTileStyle.fromInt(GameCabTileStyle.pinnedDefaultValue);

  Future<Map<String, List<Machine>>> getAllGames() async {
    try {
      showLoading();

      if (_storeModel.storelist == null) return {};
      _initFavMachines(_fetchedGameList);
      final storeMachines = <String, List<Machine>>{};
      final composedStoreIds = <String>[];
      for (final store in _storeModel.storelist!) {
        final composedStoreId = _storeModel.prefix! + store.sid!.toString();
        composedStoreIds.add(composedStoreId);
      }
      final gameLists = await Future.wait(
        composedStoreIds.map((id) => repository.getGameList(storeId: id)),
      );

      for (final gameList in gameLists) {
        final storeName =
            storeNameMap[gameList.machines?.first.shop] ?? 'unknown store';
        final machines = gameList.machines;
        if (machines == null) continue;
        if (!storeMachines.containsKey(storeName)) {
          storeMachines[storeName] = [];
        }
        storeMachines[storeName]!.addAll(machines);
      }
      return storeMachines;
    } catch (e, stacktrace) {
      log('', error: '$e', name: 'getAllGames', stackTrace: stacktrace);
      return {};
    } finally {
      notifyListeners();
      dismissLoading();
    }
  }

  Future<GameList> _getFavGame() async {
    try {
      showLoading();
      _storeModel = await _getStoreData();

      _buildStoreNameMap();
      _fetchedGameList = await repository.favGameList();
      _initFavMachines(_fetchedGameList);
      return _fetchedGameList;
    } catch (e) {
      log('', error: '$e', name: 'getFavCabs');
      showError(serviceErrorMessage);
      return const GameList.empty();
    } finally {
      dismissLoading();
    }
  }

  void onMachineSelected(Machine selectedMachine) {
    final id = selectedMachine.id;
    // 沒有id的機台不加入
    if (id == null) return;

    if (selectedFavMachines.contains(id)) {
      selectedFavMachines.remove(id);
    } else {
      selectedFavMachines.add(id);
    }
    notifyListeners();
  }

  Future<void> init() async {
    _favGameList = await _getFavGame();
    _tileStyle = await _getTileStyle();
    notifyListeners();
  }

  Future<GameCabTileStyle> _getTileStyle() async {
    final tileStyleValue =
        await Prefs.getInt(PrefsToken.pinnedGameCabTileStyle);
    return GameCabTileStyle.fromInt(
        tileStyleValue ?? GameCabTileStyle.pinnedDefaultValue);
  }

  Future<StoreModel> _getStoreData() async {
    final storeModel = await repository.getStores(currentLocale);

    return storeModel;
  }

  void _initFavMachines(GameList favGameList) {
    selectedFavMachines.clear();
    if (favGameList.machines == null) return;
    for (final machine in favGameList.machines!) {
      // 沒有id的機台不加入
      if (machine.id == null) continue;
      selectedFavMachines.add(machine.id!);
    }
  }

  void _buildStoreNameMap() {
    storeNameMap.clear();

    for (final store in _storeModel.storelist!) {
      final storeName = store.name ?? 'unknown store';
      final composedStoreId = _storeModel.prefix! + store.sid!.toString();
      storeNameMap[composedStoreId] = storeName;
    }
  }

  void setFavGames() async {
    await repository.setFavGames(selectedFavMachines);
  }
}
