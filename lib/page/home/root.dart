import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_loaded.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account.dart';
import 'package:x50pay/page/collab/collab.dart';
import 'package:x50pay/page/game/game.dart';
import 'package:x50pay/page/giftSystem/gift_system.dart';
import 'package:x50pay/page/home/home.dart';
import 'package:x50pay/r.g.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with AutomaticKeepAliveClientMixin<Root> {
  static const navBarStyle = BorderSide(color: Color(0xff3e3e3e), width: 1);
  final menus = [
    (icon: Icons.sports_esports, label: '投幣', routeName: AppRoute.game),
    (icon: Icons.settings, label: '設定', routeName: AppRoute.account),
    (icon: Icons.home_rounded, label: 'Me', routeName: AppRoute.home),
    (icon: Icons.redeem_rounded, label: '禮物', routeName: AppRoute.gift),
    (icon: Icons.handshake_rounded, label: '合作', routeName: AppRoute.collab),
  ];

  late final String? currentRouteName = ModalRoute.of(context)?.settings.name;
  late ValueNotifier<int> menuIndexNotifier =
      ValueNotifier(menus.indexWhere((menu) {
    if (currentRouteName == '/buyMPass') return menu.routeName == AppRoute.home;
    return menu.routeName == currentRouteName;
  }));

  final tabs = [
    const Tab(icon: Icon(Icons.sports_esports), text: '投幣'),
    const Tab(icon: Icon(Icons.settings), text: '設定'),
    const Tab(icon: Icon(Icons.home_rounded), text: 'Me'),
    const Tab(icon: Icon(Icons.redeem_rounded), text: '禮物'),
    const Tab(icon: Icon(Icons.handshake_rounded), text: '合作'),
  ];
  final tabViews = [
    const Game(),
    const Account(),
    const Home(),
    const GiftSystem(),
    const Collab(),
  ];
  int selectedMenuIndex = 2;

  void Function()? debugFunction;

  Widget buildButtomNavBar() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xff3e3e3e)))),
      child: ValueListenableBuilder(
          valueListenable: menuIndexNotifier,
          builder: (context, selectedIndex, child) {
            return NavigationBar(
              selectedIndex: selectedIndex,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: (index) async {
                menuIndexNotifier.value = index;
                log('change menu: ${menus[index].label}',
                    name: 'buildButtomNavBar');
                if (menus[index].routeName.isEmpty) {
                  Fluttertoast.showToast(msg: 'dev');
                  return;
                }
                selectedMenuIndex = index;
                await _tabNavigateTo(menus[index].routeName);
              },
              destinations: menus
                  .map((menu) => NavigationDestination(
                        icon: Icon(menu.icon, color: const Color(0xffb4b4b4)),
                        label: menu.label,
                        selectedIcon:
                            Icon(menu.icon, color: const Color(0xfffafafa)),
                      ))
                  .toList(),
            );
          }),
    );
  }

  Future _tabNavigateTo(String nextRouteName) async {
    final nav = Navigator.of(context);
    final val = await GlobalSingleton.instance.checkUser(force: true);
    log('nextRoute: $nextRouteName', name: '_tabNavigateTo');
    for (var route in NavigationHistoryObserver().history) {
      log('name: ${route.settings.name}', name: '_tabNavigateTo');
    }
    if (val == false) {
      await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
    } else {
      log('top: ${NavigationHistoryObserver().top!.settings.name}',
          name: '_tabNavigateTo');

      NavigationHistoryObserver().history.length == 3
          ? nav.pushReplacementNamed(nextRouteName)
          : nav.pushNamed(nextRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        initialIndex: 2,
        child: Scaffold(
          appBar: _LoadedAppBar.functional(),
          floatingActionButton: kDebugMode && debugFunction != null
              ? FloatingActionButton(
                  onPressed: debugFunction,
                  child: const Icon(Icons.developer_mode))
              : null,
          body: TabBarView(children: tabViews),
          bottomNavigationBar: buildButtomNavBar(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum LoadedHeaderType {
  fixed,
  functional,
}

class _LoadedAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _kFixedHeaderHeight = 40;
  static const double _kFunctionalHeaderHeight = 50;
  final LoadedHeaderType _type;
  final String? title;
  final int point;

  const _LoadedAppBar.fixed()
      : _type = LoadedHeaderType.fixed,
        title = null,
        point = 0;
  const _LoadedAppBar.functional({Key? key, this.point = 0})
      : _type = LoadedHeaderType.functional,
        title = null;

  @override
  Size get preferredSize => _type == LoadedHeaderType.fixed
      ? const Size.fromHeight(_kFixedHeaderHeight)
      : const Size.fromHeight(_kFunctionalHeaderHeight);

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case LoadedHeaderType.fixed:
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(
                  bottom: BorderSide(color: Themes.borderColor, width: 1))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    backgroundImage: R.image.header_icon_rsz(),
                    backgroundColor: Colors.black,
                    radius: 14),
              ],
            ),
          ),
        );
      case LoadedHeaderType.functional:
        return Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3)),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(width: 15),
              // Padding(
              //   padding: const EdgeInsets.all(5),
              //   child: InkWell(
              //       onTap: () {
              //         Navigator.of(context).pop();
              //       },
              //       splashFactory: NoSplash.splashFactory,
              //       child: const Icon(Icons.chevron_left_outlined, size: 25, color: Color(0xfffafafa))),
              // ),
              const Spacer(),
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5.5, horizontal: 18),
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 15,
                            spreadRadius: 0.5)
                      ],
                      color: const Color(0xff3e3e3e),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('$point P',
                      style: const TextStyle(
                          color: Color(0xfffafafa),
                          fontWeight: FontWeight.bold))),
              const SizedBox(width: 20),
              Padding(
                padding: const EdgeInsets.all(5),
                child: InkWell(
                    onTap: () async {
                      var status = await Permission.camera.status;
                      if (status.isDenied) await Permission.camera.request();

                      if (context.mounted) {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                ScanQRCode(status == PermissionStatus.granted));
                      }
                    },
                    splashFactory: NoSplash.splashFactory,
                    child: const Icon(Icons.qr_code,
                        size: 28, color: Color(0xfffafafa))),
              ),
              const SizedBox(width: 15),
            ]),
          ),
        );
    }
  }
}
