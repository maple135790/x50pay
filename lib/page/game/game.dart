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
    if (storeName == '?????????') {
      return R.image.x50mgs_jpg();
    }
    if (storeName == '?????????') {
      return R.image.x40mgs_jpg();
    }
    return R.image.logo_150_jpg();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          child: Ink.image(
            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.modulate),
            alignment: Alignment.bottomCenter,
            image: _getBackground(store.name!),
            fit: BoxFit.fitWidth,
            width: double.infinity,
            height: 180,
            child: InkWell(
              onTap: () async {
                final navigator = Navigator.of(context);
                await SharedPreferences.getInstance()
                  ..setString('store_name', store.name!)
                  ..setString('store_id', store.sid!.toString());
                await EasyLoading.showInfo('????????????${store.name}\n\n???????????????...',
                    duration: const Duration(seconds: 2));
                await Future.delayed(const Duration(seconds: 2));
                navigator.pushNamed(AppRoute.game);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.name!, style: const TextStyle(color: Colors.white, fontSize: 18)),
                    Row(children: [
                      const Icon(Icons.near_me, size: 15, color: Color(0xe6ffffff)),
                      Text('  | ${store.address!}', style: const TextStyle(color: Color(0xe6ffffff)))
                    ]),
                  ],
                ),
              ),
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
