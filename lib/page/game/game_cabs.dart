import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/models/store/store.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/game/fav_game.dart';
import 'package:x50pay/page/game/game_cab_item.dart';
import 'package:x50pay/page/game/game_cabs_view_model.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/repository/repository.dart';

class GameCabs extends StatefulWidget {
  const GameCabs({super.key});

  @override
  State<GameCabs> createState() => _GameCabsState();
}

class _GameCabsState extends BaseStatefulState<GameCabs> {
  final repo = Repository();
  late final GameCabsViewModel viewModel;
  late List<Machine> machine;
  var key = GlobalKey();

  @override
  void initState() {
    super.initState();
    viewModel = GameCabsViewModel(
      repository: repo,
      currentLocale: context.read<LanguageProvider>().currentLocale,
    );
  }

  Future<void> onRefresh() async {
    key = GlobalKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder(
          key: key,
          future: viewModel.init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            return ChangeNotifierProvider.value(
              value: viewModel,
              builder: (context, child) {
                return const _GameCabsLoaded();
              },
            );
          },
        ),
      ),
    );
  }
}

class _GameCabsLoaded extends StatefulWidget {
  const _GameCabsLoaded();

  @override
  State<_GameCabsLoaded> createState() => _GameCabsLoadedState();
}

class _GameCabsLoadedState extends BaseStatefulState<_GameCabsLoaded>
    with TickerProviderStateMixin {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // int currentTabIndex = 0;

  @override
  void dispose() {
    GlobalSingleton.instance.recentPlayedCabinetData = null;
    _scaffoldMessengerKey.currentState?.clearSnackBars();
    super.dispose();
  }

  void clearSnackBar() {
    _scaffoldMessengerKey.currentState!.clearSnackBars();
  }

  void reloadSnackBar() {
    setState(() {});
  }

  void onChangeStoreTap() async {
    final router = GoRouter.of(context);
    Prefs.remove(PrefsToken.storeName);
    Prefs.remove(PrefsToken.storeId);
    router.goNamed(AppRoutes.gameStore.routeName, extra: true);
  }

  void showCabSelectDialog() {
    final recentPlayData = GlobalSingleton.instance.recentPlayedCabinetData!;
    showCupertinoDialog(
        context: context,
        builder: (_) => CabSelect(
              caboid: recentPlayData.caboid,
              cabNum: recentPlayData.cabNum,
              cabinetData: recentPlayData.cabinet,
            )).then((_) {
      setState(() {});
    });
  }

  void showPlayAgainSnackBar() async {
    log('showPlayAgainSnackBar', name: 'GameCabs');
    await Future.delayed(const Duration(milliseconds: 500));

    _scaffoldMessengerKey.currentState!
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          width: 210,
          dismissDirection: DismissDirection.startToEnd,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: '玩',
              onPressed: showCabSelectDialog,
              textColor: const Color(0xfff5222d)),
          duration: const Duration(days: 1),
          content: const Text('再一道？'),
        ),
      );
  }

  String getStoreImage(int? storeId) {
    if (storeId == null) return '';
    return "https://pay.x50.fun/static/storesimg/$storeId.jpg?v1.2";
  }

  Widget buildGameCabsSmall(List<Machine> machines, String storeName) {
    return ListView.builder(
      itemCount: (machines.length / 2).ceil(),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final gameLeft = machines[index * 2];
        final gameRight =
            index * 2 + 1 < machines.length ? machines[index * 2 + 1] : null;
        return Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: GameCabItem(
                  gameLeft,
                  storeName: storeName,
                  onCoinInserted: showPlayAgainSnackBar,
                  onItemPressed: clearSnackBar,
                ),
              ),
            ),
            if (gameRight != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: GameCabItem(
                  gameRight,
                  storeName: storeName,
                  onCoinInserted: showPlayAgainSnackBar,
                  onItemPressed: clearSnackBar,
                ),
              ),
            ],
            const SizedBox(width: 12),
          ],
        );
      },
    );
  }

  Widget buildGameCabsLarge(List<Machine> machines, String storeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: machines
            .map((e) => GameCabItem(
                  e,
                  storeName: storeName,
                  onCoinInserted: showPlayAgainSnackBar,
                  onItemPressed: clearSnackBar,
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store =
        context.select<GameCabsViewModel, Store?>((vm) => vm.selectedStore);
    final storeName = store?.name ?? '';
    final machines = context.select<GameCabsViewModel, List<Machine>>(
        (vm) => vm.gameList.machines!);
    // if (GlobalSingleton.instance.recentPlayedCabinetData != null) {
    //   showPlayAgainSnackBar();
    // }

    final gameCabs = Selector<GameCabsViewModel, GameCabTileStyle>(
      selector: (context, vm) => vm.gameCabTileStyle,
      builder: (context, style, child) {
        return switch (style) {
          GameCabTileStyle.large => buildGameCabsLarge(machines, storeName),
          GameCabTileStyle.small => buildGameCabsSmall(machines, storeName),
        };
      },
    );

    final storeBanner = Container(
      clipBehavior: Clip.hardEdge,
      height: 98,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkTheme
              ? CustomColorThemes.borderColorDark
              : CustomColorThemes.borderColorLight,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: getStoreImage(store?.sid!),
                alignment: const Alignment(0, -0.25),
                fit: BoxFit.fitWidth,
                colorBlendMode: BlendMode.modulate,
              ),
            ),
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
              bottom: 6,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      shadows: [Shadow(color: Colors.black, blurRadius: 18)],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me_rounded,
                        size: 15,
                        color: Color(0xe6ffffff),
                      ),
                      Text(
                        '  | ${store?.address ?? ''}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 15)
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    final segmentedControl = Padding(
      padding: const EdgeInsets.all(12),
      child: Consumer<GameCabsViewModel>(
        builder: (context, vm, child) {
          var tabs = {
            0: Text(i18n.pinnedGame),
          };
          vm.storeDetails.map((details) {
            tabs[vm.storeDetails.indexOf(details) + 1] =
                Text(details.store.name ?? '');
          }).toList();
          return CupertinoSlidingSegmentedControl(
            groupValue: vm.segmentedControlIndex,
            children: tabs,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            thumbColor: Theme.of(context).colorScheme.primaryContainer,
            padding:
                const EdgeInsets.symmetric(vertical: 3.75, horizontal: 7.5),
            onValueChanged: (value) {
              if (value == null) return;
              vm.onTabIndexChanged(value);
            },
          );
        },
      ),
    );

    // final currentStoreIndicator = Container(
    //   margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
    //   padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
    //   decoration: BoxDecoration(
    //       color: scaffoldBackgroundColor,
    //       border: Border.all(
    //         color: borderColor,
    //         width: 1,
    //       ),
    //       borderRadius: BorderRadius.circular(5)),
    //   child: Row(
    //     children: [
    //       const Icon(Icons.push_pin_rounded, size: 16),
    //       Text('  ${i18n.gameLocation}「 $storeName 」'),
    //       const Spacer(),
    //       GestureDetector(
    //         onTap: onChangeStoreTap,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: isDarkTheme
    //                 ? CustomColorThemes.appbarBoxColorLight
    //                 : CustomColorThemes.appbarBoxColorDark,
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    //           child: Icon(Icons.sync_rounded,
    //               color: scaffoldBackgroundColor, size: 26),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    final discountHourCaution = Stack(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
        ),
        Positioned(
          left: 35,
          top: 12,
          child: Container(
            color: scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: const Text(
              '離峰時段',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        const Positioned(
          top: 40,
          left: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('●   部分機種不提供離峰方案'),
              SizedBox(height: 5),
              Text('●   詳情請見粉絲專頁更新貼文'),
            ],
          ),
        )
      ],
    );

    final storeGame = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        storeBanner,
        const Padding(
          padding: EdgeInsets.only(top: 10, bottom: 7),
          child: Divider(
            height: 0,
            indent: 12,
            endIndent: 12,
            color: Color(0xff3e3e3e),
          ),
        ),
        gameCabs,
        discountHourCaution,
      ],
    );

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: Scrollbar(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              segmentedControl,
              Expanded(
                child: SingleChildScrollView(
                  child: store != null
                      ? storeGame
                      : FavGame(
                          scaffoldMessengerKey: _scaffoldMessengerKey,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
