import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/page/game/game_store_view_model.dart';
import 'package:x50pay/providers/language_provider.dart';
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

  Locale get currentLocale => context.read<LanguageProvider>().currentLocale;

  Future<void> onRefresh() async {
    key = GlobalKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider.value(
        value: viewModel,
        builder: (context, child) => RefreshIndicator(
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
    final isStoreSelected = context.select<GameStoreViewModel, bool>(
      (viewModel) => viewModel.isStoreSelected,
    );

    return Scrollbar(
      child: AbsorbPointer(
        absorbing: isStoreSelected,
        child: ListView.builder(
          itemCount: storeList.length,
          itemBuilder: (context, index) {
            return _StoreItem(
              store: storeList[index],
              prefix: stores.prefix!,
            );
          },
        ),
      ),
    );
  }
}

class _StoreItem extends StatelessWidget {
  final Store store;
  final String prefix;

  /// 店家項目
  const _StoreItem({required this.store, required this.prefix});

  String getStoreImage(int storeId) {
    return "https://pay.x50.fun/static/storesimg/$storeId.jpg?v1.2";
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
      child: Material(
        elevation: 2.5,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              border: Border.all(
                color: isDarkTheme
                    ? CustomColorThemes.borderColorDark
                    : CustomColorThemes.borderColorLight,
              ),
              borderRadius: BorderRadius.circular(5)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
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
                          const Icon(Icons.near_me_rounded,
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
                  Positioned.fill(
                      child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        context.read<GameStoreViewModel>().onStoreSelected(
                          store,
                          prefix,
                          onPageChange: () {
                            context.goNamed(AppRoutes.gameCabs.routeName);
                          },
                        );
                      },
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
