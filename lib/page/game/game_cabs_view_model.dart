import 'dart:developer';
import 'dart:ui';

import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/repository/repository.dart';

typedef StoreDetail = ({Store store, String composedStoreId});

class GameCabsViewModel extends BaseViewModel {
  final Repository repository;
  final Locale currentLocale;

  GameCabsViewModel({
    required this.repository,
    required this.currentLocale,
  });

  Store? get selectedStore => _selectedStore;
  Store? _selectedStore;

  int _segmentedControlIndex = 0;
  int get segmentedControlIndex => _segmentedControlIndex;
  final storeDetails = <StoreDetail>[];

  GameList get gameList => _gameList;
  GameList _gameList = const GameList.empty();

  bool _isRememberGameTab = false;

  Future<void> _getGamelist(String composedStoreId) async {
    try {
      showLoading();

      final gamelist = await repository.getGameList(storeId: composedStoreId);
      _gameList = gamelist;
    } catch (e) {
      log('', error: '$e', name: 'getGamelist');
      showError(serviceErrorMessage);
      _gameList = const GameList.empty();
    } finally {
      dismissLoading();
    }
  }

  /// 取得店家資料
  Future<StoreModel?> getStoreData() async {
    try {
      showLoading();
      await Future.delayed(const Duration(milliseconds: 100));

      late final StoreModel stores;
      stores = await repository.getStores(currentLocale);

      return stores;
    } catch (e, stacktrace) {
      log('', error: '$e', name: 'getStoreData', stackTrace: stacktrace);
      return null;
    } finally {
      dismissLoading();
    }
  }

  Future<void> init() async {
    // 先取得店家資料，再取得投幣頁的記憶策略
    // 完成後，依據記憶策略的結果：
    // 1. 若有記憶策略，則設定 segmentedControlIndex
    // 2. 若無記憶策略，則 segmentedControlIndex 為預設值 = 0
    // segmentedControlIndex 設定後，再讓各 TabView 自行取得資料
    final storeData = await getStoreData();
    if (storeData == null || storeData.storelist == null) return;
    storeDetails.clear();
    for (final store in storeData.storelist!) {
      storeDetails.add((
        store: store,
        composedStoreId: storeData.prefix! + store.sid.toString()
      ));
    }
    _isRememberGameTab = await Prefs.getBool(PrefsToken.rememberGameTab) ??
        PrefsToken.rememberGameTab.defaultValue;
    final lastStoreId = await Prefs.getString(PrefsToken.storeId);
    final lastTabIndex = await Prefs.getInt(PrefsToken.lastGameTabIndex);

    // 若無記憶策略，則預設tab 頁面為釘選機台
    if (!_isRememberGameTab || lastStoreId == null) {
      _segmentedControlIndex = 0;
      return;
    }
    // 有記憶策略，若 tab index = 0, 則直接設定 tab 頁面
    // 若 != 0，則需先取得機台資料，再設定 tab 頁面
    if (lastTabIndex == 0) {
      _segmentedControlIndex = 0;
      return;
    }
    var storeIndex = 0;
    for (var i = 0; i < storeData.storelist!.length; i++) {
      final store = storeData.storelist![i];
      final composedStoreId = storeData.prefix! + store.sid.toString();
      if (composedStoreId != lastStoreId) continue;
      assert(composedStoreId == lastStoreId, 'store id 不一致');
      storeIndex = i;
    }
    await _getGamelist(lastStoreId);
    _selectedStore = storeData.storelist![storeIndex];
    // index 0 是訂選機台，所以要加 1
    _segmentedControlIndex = 1 + storeIndex;
  }

  void onTabIndexChanged(int index) async {
    _segmentedControlIndex = index;
    if (index == 0) {
      _selectedStore = null;
      _gameList = const GameList.empty();
    } else {
      // 0 是釘選機台，所以要減 1
      final storeDetail = storeDetails[index - 1];
      await _onStoreSelected(storeDetail.store, storeDetail.composedStoreId);
      await _getGamelist(storeDetail.composedStoreId);
      _selectedStore = storeDetail.store;
    }
    if (_isRememberGameTab) {
      await Prefs.setInt(PrefsToken.lastGameTabIndex, index);
    }
    notifyListeners();
  }

  Future<void> _onStoreSelected(
    Store store,
    String composedStoreId,
  ) async {
    showInfo(
      '已切換至${store.name}\n\n少女祈禱中...',
      duration: const Duration(milliseconds: 650),
    );
    Prefs.setString(PrefsToken.storeId, composedStoreId);
    await Future.delayed(const Duration(milliseconds: 750));
    dismissLoading();
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
