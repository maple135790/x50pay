import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/page/game/game_view_model.dart';
import 'package:x50pay/r.g.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends BaseStatefulState<Game> with BaseLoaded {
  final GameViewModel viewModel = GameViewModel();
  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    return FutureBuilder<bool>(
      future: viewModel.initStore(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(child: Center(child: Text('loading')));
        }
        return _GameStoreLoaded(viewModel.store!);
      },
    );
  }
}

class _GameStoreLoaded extends StatelessWidget {
  final Store stores;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          image: DecorationImage(
              image: _getBackground(store.name!),
              fit: BoxFit.fitWidth,
              opacity: 0.9,
              alignment: Alignment.bottomCenter),
        ),
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
    );
  }
}
