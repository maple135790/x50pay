import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/game/fav_game_view_model.dart';
import 'package:x50pay/page/game/game_cab_item.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/repository/repository.dart';

class FavGame extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const FavGame({super.key, required this.scaffoldMessengerKey});

  @override
  State<FavGame> createState() => _FavGameState();
}

class _FavGameState extends BaseStatefulState<FavGame> {
  final repo = Repository();
  late final FavGameViewModel viewModel;
  late final Future<void> init;

  @override
  void initState() {
    super.initState();
    viewModel = FavGameViewModel(
      repository: repo,
      currentLocale: context.read<LanguageProvider>().currentLocale,
    );
    init = viewModel.init();
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

    widget.scaffoldMessengerKey.currentState!
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          width: 210,
          dismissDirection: DismissDirection.startToEnd,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: '玩',
            onPressed: showCabSelectDialog,
            textColor: const Color(0xfff5222d),
          ),
          duration: const Duration(days: 1),
          content: const Text('再一道？'),
        ),
      );
  }

  void reloadAfterSetFavGame() {
    context.replaceNamed(
      AppRoutes.gameCabs.routeName,
      extra: true,
    );
  }

  void showAddFavGameBottomSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: scaffoldBackgroundColor,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return ChangeNotifierProvider.value(
              value: viewModel,
              builder: (context, child) {
                return AddFavGameModal(
                  scrollController: scrollController,
                  onSetFavGame: reloadAfterSetFavGame,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildLargeTileGames(GameList gameList, Widget changeFavGameButton) {
    return ListView.builder(
      // 最後一個是重新釘選按鈕
      itemCount: gameList.machines!.length + 1,
      padding: const EdgeInsets.all(12),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemExtent: 150,
      itemBuilder: (context, index) {
        return Selector<FavGameViewModel, Map<String, String>>(
          selector: (context, vm) => vm.storeNameMap,
          shouldRebuild: (previous, next) =>
              previous.keys.hashCode != next.keys.hashCode,
          builder: (context, storeNameMap, child) {
            if (index == gameList.machines!.length) {
              return changeFavGameButton;
            }
            final machine = gameList.machines![index];
            final storeName =
                storeNameMap[machine.shop ?? ''] ?? 'unknownStore';
            return GameCabItem(
              machine,
              storeName: storeName,
              onCoinInserted: showPlayAgainSnackBar,
              onItemPressed: clearSnackBar,
            );
          },
        );
      },
    );
  }

  void clearSnackBar() {
    widget.scaffoldMessengerKey.currentState!.clearSnackBars();
  }

  void reloadSnackBar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final addFavGameButton = Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: double.maxFinite,
        height: 236.5,
        child: Card.filled(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: showAddFavGameBottomSheet,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture(
                    Svgs.heartCirclePlus,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).iconTheme.color!,
                      BlendMode.srcIn,
                    ),
                    width: 75,
                    height: 75,
                  ),
                  Text(
                    i18n.addFavGameTitle,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    i18n.addFavGameSubtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xffb4b4b4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final changeFavGameButton = SizedBox(
      width: double.maxFinite,
      height: 150,
      child: Card.outlined(
        margin: const EdgeInsets.only(top: 6),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: showAddFavGameBottomSheet,
          child: Stack(
            children: [
              Positioned(
                right: -33.5,
                bottom: -33.5,
                child: SvgPicture(
                  Svgs.heartCirclePlus,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).iconTheme.color!.withOpacity(0.2),
                    BlendMode.srcIn,
                  ),
                  width: 112,
                  height: 112,
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        i18n.changeFavGameTitle,
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        i18n.changeFavGameSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xffb4b4b4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget buildSmallTileGames(GameList gameList, Widget changeFavGameButton) {
      final machines = gameList.machines;
      if (machines == null) return const SizedBox();
      final rowCount = (machines.length / 2).ceil();

      return ListView.builder(
        // 最後一個是重新釘選按鈕
        itemCount: rowCount + 1,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (index == rowCount) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: changeFavGameButton,
            );
          }

          final gameLeft = machines[index * 2];
          final gameRight =
              index * 2 + 1 < machines.length ? machines[index * 2 + 1] : null;
          return Selector<FavGameViewModel, Map<String, String>>(
              selector: (context, vm) => vm.storeNameMap,
              builder: (context, storeNameMap, child) {
                if (index == gameList.machines!.length) {
                  return changeFavGameButton;
                }
                final storeNameLeft =
                    storeNameMap[gameLeft.shop ?? ''] ?? 'unknownStore';
                final storeNameRight =
                    storeNameMap[gameRight?.shop ?? ''] ?? 'unknownStore';

                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: GameCabItem(
                          gameLeft,
                          storeName: storeNameLeft,
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
                          storeName: storeNameRight,
                          onCoinInserted: showPlayAgainSnackBar,
                          onItemPressed: clearSnackBar,
                        ),
                      ),
                    ],
                    const SizedBox(width: 12),
                  ],
                );
              });
        },
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: ChangeNotifierProvider.value(
        value: viewModel,
        builder: (context, child) {
          return FutureBuilder(
            future: init,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }

              final gameList = context
                  .select<FavGameViewModel, GameList>((vm) => vm.favGameList);
              final style = context.select<FavGameViewModel, GameCabTileStyle>(
                  (vm) => vm.tileStyle);
              if (gameList.machines?.isEmpty ?? true) {
                return addFavGameButton;
              }

              return switch (style) {
                GameCabTileStyle.small =>
                  buildSmallTileGames(gameList, changeFavGameButton),
                GameCabTileStyle.large =>
                  buildLargeTileGames(gameList, changeFavGameButton),
              };
            },
          );
        },
      ),
    );
  }
}

class AddFavGameModal extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onSetFavGame;

  const AddFavGameModal({
    super.key,
    required this.scrollController,
    required this.onSetFavGame,
  });

  @override
  State<AddFavGameModal> createState() => _AddFavGameModalState();
}

class _AddFavGameModalState extends BaseStatefulState<AddFavGameModal> {
  late final Future<Map<String, List<Machine>>> getStoreGames;

  @override
  void initState() {
    super.initState();
    getStoreGames = context.read<FavGameViewModel>().getAllGames();
  }

  List<Widget> buildMachineChips(Map<String, List<Machine>> storeMachine) {
    final children = <Widget>[];
    for (final machineEntry in storeMachine.entries) {
      final storeName = machineEntry.key;
      final machines = machineEntry.value;

      for (final machine in machines) {
        final label = "$storeName - ${machine.lable}";
        final chip = Consumer<FavGameViewModel>(
          builder: (context, vm, child) {
            return ChoiceChip(
              label: Text(label),
              selected: vm.selectedFavMachines.contains(machine.id),
              onSelected: (_) {
                vm.onMachineSelected(machine);
              },
            );
          },
        );
        children.add(chip);
      }

      children.add(const Divider());
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            i18n.setFavGameTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: FutureBuilder(
                future: getStoreGames,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox();
                  }
                  if (snapshot.hasError) {
                    log('', error: snapshot.error, name: 'AddFavGameModal');
                    return const Text('Error');
                  }
                  final storeMachine =
                      snapshot.data as Map<String, List<Machine>>;

                  return Wrap(
                    spacing: 8,
                    children: buildMachineChips(storeMachine),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 65,
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              style: CustomButtonThemes.severe(
                isRRect: false,
                outlinedBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                context.read<FavGameViewModel>().setFavGames();
                widget.onSetFavGame.call();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.check),
              label: Text(i18n.dialogConfirm),
            ),
          ),
        ],
      ),
    );
  }
}
