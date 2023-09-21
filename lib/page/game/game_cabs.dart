import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/mixins/game_mixin.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/game/game_cabs_view_model.dart';

class GameCabs extends StatefulWidget {
  const GameCabs({super.key});

  @override
  State<GameCabs> createState() => _GameCabsState();
}

class _GameCabsState extends BaseStatefulState<GameCabs> {
  final viewModel = GameCabsViewModel();
  late List<Machine> machine;
  late Future<GameList?> gameCabsInit;

  @override
  void initState() {
    super.initState();
    gameCabsInit = viewModel.getGamelist();
  }

  @override
  void dispose() {
    log('GameCabs disposed', name: 'GameCabs');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<GameList?>(
          future: gameCabsInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            if (snapshot.data == null) {
              return const SizedBox(child: Text('failed'));
            } else {
              return _GameCabsLoaded(
                viewModel.storeName,
                games: snapshot.data!,
              );
            }
          }),
    );
  }
}

class _GameCabsLoaded extends StatefulWidget {
  final String storeName;
  final GameList games;
  const _GameCabsLoaded(this.storeName, {required this.games});

  @override
  State<_GameCabsLoaded> createState() => _GameCabsLoadedState();
}

class _GameCabsLoadedState extends BaseStatefulState<_GameCabsLoaded> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late final machine = widget.games.machine!;

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('store_name');
    await prefs.remove('store_id');
    router.goNamed(AppRoutes.gameStore.routeName, extra: true);
  }

  void showCabSelectDialog() {
    final recentPlayData = GlobalSingleton.instance.recentPlayedCabinetData!;
    showCupertinoDialog(
        context: context,
        builder: (_) => CabSelect(
              caboid: recentPlayData.caboid,
              cabIndex: recentPlayData.cabIndex,
              cabinetData: recentPlayData.cabinet,
            )).then((_) {
      setState(() {});
    });
  }

  void showPlayAgainSnackBar() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      _scaffoldMessengerKey.currentState!
        ..clearSnackBars()
        ..showSnackBar(SnackBar(
          backgroundColor: const Color(0xff373737),
          width: 210,
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: '玩',
              onPressed: showCabSelectDialog,
              textColor: const Color(0xfff5222d)),
          duration: const Duration(days: 1),
          content:
              const Text('再一道？', style: TextStyle(color: Color(0xfffafafa))),
        ));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GlobalSingleton.instance.recentPlayedCabinetData != null) {
      showPlayAgainSnackBar();
    }
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                  decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      border: Border.all(color: Themes.borderColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      const Icon(Icons.push_pin,
                          color: Color(0xfffafafa), size: 16),
                      Text('  ${i18n.gameLocation}「 ${widget.storeName} 」',
                          style: const TextStyle(color: Color(0xfffafafa))),
                      const Spacer(),
                      GestureDetector(
                        onTap: onChangeStoreTap,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0xfffafafa)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Icon(Icons.sync,
                              color: scaffoldBackgroundColor,
                              size: 26),
                        ),
                      ),
                    ],
                  )),
              Column(
                  children: machine
                      .map((e) => _GameCabItem(
                            e,
                            storeName: widget.storeName,
                            onCoinInserted: reloadSnackBar,
                            onItemPressed: clearSnackBar,
                          ))
                      .toList()),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 80,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Themes.borderColor, width: 1),
                        borderRadius: BorderRadius.circular(5),
                        shape: BoxShape.rectangle),
                  ),
                  Positioned(
                      left: 35,
                      top: 12,
                      child: Container(
                        color: scaffoldBackgroundColor,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: const Text('離峰時段',
                            style: TextStyle(
                                color: Color(0xfffafafa), fontSize: 13)),
                      )),
                  const Positioned(
                    top: 40,
                    left: 35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('●   部分機種不提供離峰方案',
                            style: TextStyle(color: Color(0xfffafafa))),
                        SizedBox(height: 5),
                        Text('●   詳情請見粉絲專頁更新貼文',
                            style: TextStyle(color: Color(0xfffafafa))),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCabItem extends StatelessWidget with GameMixin {
  final VoidCallback onCoinInserted;
  final VoidCallback onItemPressed;
  final Machine machine;
  final String storeName;

  const _GameCabItem(
    this.machine, {
    required this.storeName,
    required this.onCoinInserted,
    required this.onItemPressed,
  });

  @override
  Widget build(BuildContext context) {
    final i18n = S.of(context);
    final isWeekend =
        DateTime.now().weekday == 6 || DateTime.now().weekday == 7;
    final time = machine.mode![0][3] == true
        ? i18n.gameDiscountHour
        : i18n.gameNormalHour;
    final addition = machine.vipb == true
        ? " [${i18n.gameMPass}]"
        : time == i18n.gameNormalHour
            ? ''
            : isWeekend
                ? " [${i18n.gameWeekends}]"
                : " [${i18n.gameWeekday}]";

    onItemPressed.call();
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Themes.borderColor,
                strokeAlign: BorderSide.strokeAlignOutside)),
        height: 155,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(
            children: [
              Positioned.fill(
                  child: CachedNetworkImage(
                imageUrl: getGameCabImage(machine.id!),
                color: const Color.fromARGB(35, 0, 0, 0),
                colorBlendMode: BlendMode.srcATop,
                fit: BoxFit.fitWidth,
                alignment: const Alignment(0, -0.25),
              )),
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
                bottom: 8,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("[$storeName] ${machine.label!}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 18)
                            ])),
                    Row(children: [
                      const Icon(Icons.schedule,
                          size: 15, color: Color(0xe6ffffff)),
                      Text('  $time$addition',
                          style: const TextStyle(
                              color: Color(0xffffffe6),
                              fontSize: 13,
                              shadows: [
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
                    final isInsertToken =
                        await GoRouter.of(context).pushNamed<bool>(
                      AppRoutes.gameCab.routeName,
                      pathParameters: {'mid': machine.id!},
                    );
                    if (isInsertToken == true) {
                      onCoinInserted.call();
                    }
                  },
                  splashColor: Colors.white12,
                  highlightColor: Colors.white12,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
