import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/route_generator.dart';
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

class _GameState extends BaseStatefulState<Game> with BaseLoaded {
  final GameViewModel viewModel = GameViewModel();
  Future<bool>? _initialStore;

  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await GlobalSingleton.instance.checkUser(force: false);
  }

  @override
  void initState() {
    _initialStore = viewModel.initStore();
    super.initState();
  }

  @override
  Widget body() {
    return FutureBuilder<bool>(
      future: viewModel.hasRecentStore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
        if (snapshot.data == true) {
          return loadGamelist();
        } else {
          return loadGameStore();
        }
      },
    );
  }

  FutureBuilder<bool> loadGameStore() {
    return FutureBuilder<bool>(
      future: _initialStore,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Text('loading...');
        }
        return _GameStoreLoaded(viewModel.stores!);
      },
    );
  }

  FutureBuilder<bool> loadGamelist() {
    return FutureBuilder<bool>(
        future: viewModel.getGamelist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
          if (snapshot.data == false) {
            return const SizedBox(child: Text('failed'));
          } else {
            return _GameCabs(games: viewModel.gamelist!, storeName: viewModel.storeName!);
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
      itemBuilder: (context, index) => _StoreItem(storeList[index]),
    );
  }
}

class _StoreItem extends StatelessWidget {
  final Storelist store;
  const _StoreItem(this.store, {Key? key}) : super(key: key);

  ImageProvider _getBackground(String storeName) {
    if (storeName == '西門店') {
      return R.image.x50mgs_jpg();
    }
    if (storeName == '士林店') {
      return R.image.x40mgs_jpg();
    }
    return R.image.logo_150_jpg();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          border: Border.all(color: Themes.borderColor), borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GestureDetector(
          onTap: () async {
            final navigator = Navigator.of(context);
            await SharedPreferences.getInstance()
              ..setString('store_name', store.name!)
              ..setString('store_id', store.sid!.toString());
            await EasyLoading.showInfo('已切換至${store.name}\n\n少女祈禱中...', duration: const Duration(seconds: 2));
            await Future.delayed(const Duration(seconds: 2));
            navigator.pushNamed(AppRoute.game);
          },
          child: SizedBox(
            width: double.infinity,
            height: 150,
            child: Stack(
              children: [
                Positioned(
                    width: 400,
                    top: -100,
                    child: Image(
                      image: _getBackground(store.name!),
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
                  bottom: 15,
                  left: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(store.name!, style: const TextStyle(color: Colors.white, fontSize: 18)),
                      //             Row(children: [
                      //               const Icon(Icons.near_me, size: 15, color: Color(0xe6ffffff)),
                      //               Text('  | ${store.address!}', style: const TextStyle(color: Color(0xe6ffffff)))
                      //             ]),
                      Text(store.name!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              shadows: [Shadow(color: Colors.black, blurRadius: 18)])),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        const Icon(Icons.near_me, size: 15, color: Color(0xe6ffffff)),
                        Text('  | ${store.address!}',
                            style: const TextStyle(
                                color: Color(0xffbcbfbf),
                                fontSize: 13,
                                shadows: [Shadow(color: Colors.black, blurRadius: 15)]))
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

ImageProvider _getBackground(String gameId) {
  if (gameId == 'chu') {
    return R.image.chu();
  }
  if (gameId == 'ddr') {
    return R.image.ddr();
  }
  if (gameId == 'gc') {
    return R.image.gc();
  }
  if (gameId == 'ju') {
    return R.image.ju();
  }
  if (gameId == 'mmdx') {
    return R.image.mmdx();
  }
  if (gameId == 'nvsv') {
    return R.image.nvsv();
  }
  if (gameId == 'pop') {
    return R.image.pop();
  }
  if (gameId == 'sdvx') {
    return R.image.sdvx();
  }
  if (gameId == 'tko') {
    return R.image.tko();
  }
  if (gameId == 'wac') {
    return R.image.wac();
  }
  if (gameId == 'x40chu') {
    return R.image.x40chu();
  }
  if (gameId == 'x40ddr') {
    return R.image.x40ddr();
  }
  if (gameId == 'x40maidx') {
    return R.image.x40maidx();
  }
  if (gameId == 'x40sdvx') {
    return R.image.x40sdvx();
  }
  if (gameId == 'x40tko') {
    return R.image.x40tko();
  }
  if (gameId == 'x40wac') {
    return R.image.x40wac();
  }
  return R.image.logo_150_jpg();
}
