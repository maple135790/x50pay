import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/mixins/game_mixin.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/game/game_cabs_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class GameCabs extends StatefulWidget {
  const GameCabs({super.key});

  @override
  State<GameCabs> createState() => _GameCabsState();
}

class _GameCabsState extends BaseStatefulState<GameCabs> {
  final repo = Repository();
  late final viewModel = GameCabsViewModel(repository: repo);
  late List<Machine> machine;
  var key = GlobalKey();

  @override
  void initState() {
    super.initState();
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
        child: FutureBuilder<GameList?>(
            key: key,
            future: viewModel.getGamelist(),
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
      ),
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
    Future.delayed(const Duration(milliseconds: 500), () {
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
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                    padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
                    decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        border: Border.all(
                          color: borderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        const Icon(Icons.push_pin_rounded, size: 16),
                        Text('  ${i18n.gameLocation}「 ${widget.storeName} 」'),
                        const Spacer(),
                        GestureDetector(
                          onTap: onChangeStoreTap,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkTheme
                                  ? CustomColorThemes.appbarBoxColorLight
                                  : CustomColorThemes.appbarBoxColorDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Icon(Icons.sync_rounded,
                                color: scaffoldBackgroundColor, size: 26),
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
                          child: const Text('離峰時段',
                              style: TextStyle(fontSize: 13)),
                        )),
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
                ),
                const SizedBox(height: 12),
              ],
            ),
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
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
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
      child: Material(
        elevation: isDarkTheme ? 5 : 10,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: isDarkTheme
                    ? CustomColorThemes.borderColorDark
                    : CustomColorThemes.borderColorLight,
                strokeAlign: BorderSide.strokeAlignOutside,
              )),
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
                        const Icon(Icons.schedule_rounded,
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
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
