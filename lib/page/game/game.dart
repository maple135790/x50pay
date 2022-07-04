import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/game/game_view_model.dart';
import 'package:x50pay/r.g.dart';

part 'game_cabs.dart';

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
  void initState() {
    _initialStore = viewModel.initStore(force: true);
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
        future: viewModel.getGamelist(force: true),
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
                await EasyLoading.showSuccess('已切換至${store.name}', duration: const Duration(seconds: 2))
                    .then((_) async {
                  await Future.delayed(const Duration(seconds: 2));
                  navigator.pushNamed(AppRoute.game);
                });
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
