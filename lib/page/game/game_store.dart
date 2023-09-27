import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/language_view_model.dart';
import 'package:x50pay/page/game/game_store_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class GameStore extends StatefulWidget {
  /// 選店頁面
  const GameStore({super.key});

  @override
  State<GameStore> createState() => _GameStoreState();
}

class _GameStoreState extends BaseStatefulState<GameStore> {
  final repo = Repository();
  late final viewModel = GameStoreViewModel(repository: repo);
  var key = GlobalKey();

  Locale get currentLocale => context.read<LanguageViewModel>().currentLocale;

  Future<void> onRefresh() async {
    key = GlobalKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<StoreModel?>(
          key: key,
          future: viewModel.getStoreData(currentLocale: currentLocale),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Text(kDebugMode ? 'loading...' : '');
            }
            if (snapshot.data == null) return const Text('failed');

            return _GameStoreLoaded(snapshot.data!);
          },
        ),
      ),
    );
  }
}

class _GameStoreLoaded extends StatelessWidget {
  final StoreModel stores;
  const _GameStoreLoaded(this.stores);

  @override
  Widget build(BuildContext context) {
    final List<Store> storeList = stores.storelist!;

    return ListView.builder(
      itemCount: storeList.length,
      itemBuilder: (context, index) {
        return _StoreItem(storeList[index], stores.prefix!);
      },
    );
  }
}

class _StoreItem extends StatelessWidget {
  final Store store;
  final String prefix;

  /// 店家項目
  const _StoreItem(this.store, this.prefix);

  String getStoreImage(int storeId) {
    return "https://pay.x50.fun/static/storesimg/$storeId.jpg?v1.2";
  }

  void onStoreSelected(GoRouter router) async {
    Prefs.setString(PrefsToken.storeName, store.name!);
    Prefs.setString(PrefsToken.storeId, prefix + (store.sid!.toString()));
    await EasyLoading.showInfo('已切換至${store.name}\n\n少女祈禱中...',
        duration: const Duration(milliseconds: 800));
    await Future.delayed(const Duration(milliseconds: 800));
    EasyLoading.dismiss();
    await Future.delayed(const Duration(milliseconds: 150));
    router.goNamed(AppRoutes.gameCabs.routeName);
    return;
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
            width: double.maxFinite,
            height: 180,
            child: Stack(
              children: [
                Positioned.fill(
                    child: CachedNetworkImage(
                        imageUrl: getStoreImage(store.sid!),
                        alignment: const Alignment(0, -0.25),
                        fit: BoxFit.fitWidth,
                        colorBlendMode: BlendMode.modulate)),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [Colors.black, Colors.transparent],
                        transform: GradientRotation(12),
                        stops: [0, 0.6],
                      ),
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
                      Row(children: [
                        const Icon(Icons.near_me,
                            size: 15, color: Color(0xe6ffffff)),
                        Text('  | ${store.address!}',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                shadows: const [
                                  Shadow(color: Colors.black, blurRadius: 15)
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
