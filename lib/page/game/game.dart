import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/game/cab_detail_view_model.dart';
import 'package:x50pay/page/game/game_view_model.dart';
import 'package:x50pay/r.g.dart';

part 'game_cabs.dart';
part 'cab_detail.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends BaseStatefulState<Game> {
  final viewModel = GameViewModel();
  late Future<StoreModel?> _getStoreData;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await GlobalSingleton.instance.checkUser(force: false);
  }

  void init({
    required void Function(StoreModel? storeData) onNoRecentStore,
    required void Function(Gamelist? gameList) onHasRecentStore,
  }) async {
    // 先查有沒有選擇過店家
    // 有的話就直接跳到選擇機台
    // 沒有的話就跳到選擇店家
    final hasRecentStore = await viewModel.hasRecentStore();
    if (!hasRecentStore) {
      final storeData = await viewModel.getStoreData();
      onNoRecentStore.call(storeData);
      return;
    }
    final gameList = await viewModel.getGamelist();
    onHasRecentStore.call(gameList);
  }

  @override
  void initState() {
    super.initState();
    _getStoreData = viewModel.getStoreData();

    // init(
    //   onNoRecentStore: (StoreModel? storeData) {
    //     GoRouter.of(context).pushNamed(
    //       AppRoutes.gameStore.routeName,
    //       extra: storeData,
    //     );
    //   },
    //   onHasRecentStore: (gameList) {
    //     GoRouter.of(context).pushNamed(
    //       AppRoutes.gameCabs.routeName,
    //       extra: gameList,
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: viewModel.hasRecentStore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }
        if (snapshot.data == true) {
          return loadGamelist();
        } else {
          return loadGameStore();
        }
      },
    );
  }

  FutureBuilder<StoreModel?> loadGameStore() {
    return FutureBuilder<StoreModel?>(
      future: _getStoreData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Text(kDebugMode ? 'loading...' : '');
        }
        if (snapshot.data == null) return const Text('failed');

        return _GameStoreLoaded(snapshot.data!);
      },
    );
  }

  FutureBuilder<Gamelist?> loadGamelist() {
    return FutureBuilder<Gamelist?>(
        future: viewModel.getGamelist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }
          if (snapshot.data == null) {
            return const SizedBox(child: Text('failed'));
          } else {
            return GameCabs(
              games: snapshot.data!,
              storeName: viewModel.storeName!,
            );
          }
        });
  }
}

class _GameStoreLoaded extends StatelessWidget {
  final StoreModel stores;
  const _GameStoreLoaded(this.stores, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Storelist> storeList = stores.storelist!;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: storeList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) =>
          _StoreItem(storeList[index], stores.prefix!),
    );
  }
}

class _StoreItem extends StatelessWidget {
  final Storelist store;
  final String prefix;
  const _StoreItem(this.store, this.prefix, {Key? key}) : super(key: key);

  ImageProvider _getStoreImage(int storeId, {bool isOnline = false}) {
    late _X50Store store;

    if (isOnline) {
      return NetworkImage(
          "https://pay.x50.fun/static/storesimg/$storeId.jpg?v1.2");
    }
    for (var s in _X50Store.values) {
      if (s.sid == storeId) {
        store = s;
        break;
      }
    }

    switch (store) {
      case _X50Store.ximen1:
        return R.image.a37656_jpg();
      case _X50Store.shilin:
        return R.image.a37657_jpg();
      case _X50Store.ximen2:
        return R.image.a37658_jpg();
    }
  }

  void onStoreSelected(GoRouter router) async {
    await SharedPreferences.getInstance()
      ..setString('store_name', store.name!)
      ..setString('store_id', prefix + (store.sid!.toString()));
    await EasyLoading.showInfo('已切換至${store.name}\n\n少女祈禱中...',
        duration: const Duration(seconds: 2));
    await Future.delayed(const Duration(seconds: 2));
    router.pushNamed(AppRoutes.game.routeName);
    // Navigator.of(context).pushReplacement(
    // CupertinoPageRoute(builder: (context) => const Game()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          border: Border.all(color: Themes.borderColor),
          borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GestureDetector(
          onTap: () {
            final router = GoRouter.of(context);
            onStoreSelected(router);
          },
          child: SizedBox(
            width: double.infinity,
            height: 180,
            child: Stack(
              children: [
                Positioned(
                    width: 400,
                    top: -100,
                    child: Image(
                      image: _getStoreImage(store.sid!,
                          isOnline: GlobalSingleton.instance.isOnline),
                      fit: BoxFit.fitWidth,
                      colorBlendMode: BlendMode.modulate,
                    )),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.1, 1]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 18)
                              ])),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(Icons.near_me,
                                size: 15, color: Color(0xe6ffffff)),
                            Text('  | ${store.address!}',
                                style: const TextStyle(
                                    color: Color(0xffbcbfbf),
                                    fontSize: 13,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black, blurRadius: 15)
                                    ]))
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _X50Store {
  ximen1(37656),
  shilin(37657),
  ximen2(37658);

  final int sid;
  const _X50Store(this.sid);
}

ImageProvider _getGameCabImageFallback(String gameId) {
  final machine = _Machine.values.firstWhereOrNull((m) => m.gameId == gameId);

  switch (machine) {
    case _Machine.chu:
      return R.image.chu();
    case _Machine.ddr:
      return R.image.ddr();
    case _Machine.gc:
      return R.image.gc();
    case _Machine.ju:
      return R.image.ju();
    case _Machine.mmdx:
      return R.image.mmdx();
    case _Machine.nvsv:
      return R.image.nvsv();
    case _Machine.pop:
      return R.image.pop();
    case _Machine.sdvx:
      return R.image.sdvx();
    case _Machine.tko:
      return R.image.tko();
    case _Machine.wac:
      return R.image.wac();
    case _Machine.x40chu:
      return R.image.x40chu();
    case _Machine.x40ddr:
      return R.image.x40ddr();
    case _Machine.x40maidx:
      return R.image.x40maidx();
    case _Machine.x40sdvx:
      return R.image.x40sdvx();
    case _Machine.x40tko:
      return R.image.x40tko();
    case _Machine.x40wac:
      return R.image.x40wac();
    case _Machine.twoChu:
      return R.image.a2chu();
    case _Machine.twoMmdx:
      return R.image.a2mmdx();
    case _Machine.twoTko:
      return R.image.a2tko();
    case _Machine.twoDm:
      return R.image.a2dm();
    case _Machine.twoNos:
      return R.image.a2nos();
    case _Machine.twoBom:
      return R.image.a2bom();
    default:
      log('', name: "err _getBackground", error: 'unknown machine: $gameId');
      return R.image.logo_150_jpg();
  }
}

ImageProvider _getGameCabImage(String gameId, {bool isOnline = false}) {
  return NetworkImage('https://pay.x50.fun/static/gamesimg/$gameId.png?v1.1');
}

enum _Machine {
  chu('chu'),
  ddr('ddr'),
  gc('gc'),
  ju('ju'),
  mmdx('mmdx'),
  nvsv('nvsv'),
  pop('pop'),
  sdvx('sdvx'),
  tko('tko'),
  wac('wac'),
  twoChu('2chu'),
  twoMmdx('2mmdx'),
  twoTko('2tko'),
  twoDm('2dm'),
  twoNos('2nos'),
  twoBom('2bom'),
  x40chu('x40chu'),
  x40ddr('x40ddr'),
  x40maidx('x40maidx'),
  x40sdvx('x40sdvx'),
  x40tko('x40tko'),
  x40wac('x40wac');

  final String gameId;
  const _Machine(this.gameId);
}
