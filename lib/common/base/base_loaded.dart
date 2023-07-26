import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

part "../../page/scan/scan.dart";

mixin BaseLoaded<T extends StatefulWidget> on BaseStatefulState<T> {
  BaseViewModel? baseViewModel();
  Widget body();
  int selectedMenuIndex = 2;
  int? point;
  bool isScrollable = true;
  bool disableBottomNavigationBar = false;
  Color? customBackgroundColor;
  LoadedHeaderType headerType = LoadedHeaderType.fixed;

  void Function()? debugFunction;
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

  @override
  void initState() {
    super.initState();
  }

  Widget buildButtomNavBar(Color backgroundColor) {
    if (disableBottomNavigationBar) return const SizedBox();

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
/*
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            border: const Border(top: navBarStyle, left: navBarStyle, right: navBarStyle),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, -10)),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Material(
                color: backgroundColor,
                child: InkWell(
                  onTap: () async {
                    final nav = Navigator.of(context);
                    await checkUser();
                    if (NavigationHistoryObserver().top!.settings.name == AppRoute.home) {
                      setState(() {});
                    } else {
                      await _intentedDelay();
                      nav.popUntil(ModalRoute.withName(AppRoute.home));
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.home, color: getColor('home')),
                        Text('首頁', style: TextStyle(color: getColor('home'), fontSize: 12))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: backgroundColor,
                child: InkWell(
                  onTap: () async {
                    await _tabNavigateTo(AppRoute.game);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.videogame_asset_rounded, color: getColor('game')),
                        Text('遊玩系統', style: TextStyle(color: getColor('game'), fontSize: 12))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: backgroundColor,
                child: InkWell(
                  onTap: () async {
                    await _tabNavigateTo(AppRoute.account);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person, color: getColor('account')),
                        Text('會員中心', style: TextStyle(color: getColor('account'), fontSize: 12))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: backgroundColor,
                child: InkWell(
                  onTap: () async {
                    // if (ModalRoute.of(context)!.settings.name != AppRoute.home) {
                    //   Navigator.of(context).pushNamed(AppRoute.home);
                    // }
                    await _tabNavigateTo(AppRoute.gift);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.redeem_rounded, color: getColor('gift')),
                        Text('禮物盒子', style: TextStyle(color: getColor('gift'), fontSize: 12))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
 */
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
      await _intentionalDelay();

      NavigationHistoryObserver().history.length == 3
          ? nav.pushReplacementNamed(nextRouteName)
          : nav.pushNamed(nextRouteName);
    }
  }

  Future<void> checkUser() async {
    final val = await GlobalSingleton.instance.checkUser(force: true);
    if (val == false) {
      await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        customBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    if (baseViewModel() != null) {
      headerType = baseViewModel()!.isFunctionalHeader
          ? LoadedHeaderType.functional
          : LoadedHeaderType.fixed;
      point = GlobalSingleton.instance.user?.point?.toInt();
    }
    return ChangeNotifierProvider.value(
      value: baseViewModel(),
      builder: (context, _) => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            floatingActionButton: kDebugMode && debugFunction != null
                ? FloatingActionButton(
                    onPressed: debugFunction,
                    child: const Icon(Icons.developer_mode))
                : null,
            backgroundColor: backgroundColor,
            body: AnnotatedRegion(
              value: SystemUiOverlayStyle.light,
              child: SafeArea(
                child: RefreshIndicator(
                  edgeOffset: headerType == LoadedHeaderType.fixed
                      ? _LoadedHeader.kFixedHeaderHeight
                      : _LoadedHeader.kFunctionalHeaderHeight,
                  onRefresh: () async {
                    await GlobalSingleton.instance.checkUser(force: true);
                    setState(() {});
                  },
                  child: isScrollable
                      ? Scrollbar(
                          child: SingleChildScrollView(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 700),
                                child: Column(
                                  children: [
                                    headerType == LoadedHeaderType.fixed
                                        ? const _LoadedHeader()
                                        : _LoadedHeader.functional(
                                            point: point ?? -87),
                                    body(),
                                    const SizedBox(height: 20)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 700),
                            child: Column(
                              children: [
                                headerType == LoadedHeaderType.fixed
                                    ? const _LoadedHeader()
                                    : _LoadedHeader.functional(
                                        point: point ?? -87),
                                Expanded(child: body()),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
            bottomNavigationBar: buildButtomNavBar(backgroundColor),
          ),
        ),
      ),
    );
  }

  Future<void> _intentionalDelay() async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));
    await EasyLoading.dismiss();
  }
}

class _LoadedHeader extends StatelessWidget {
  static const double kFixedHeaderHeight = 40;
  static const double kFunctionalHeaderHeight = 50;
  final LoadedHeaderType _type;
  final String? title;
  final int point;
  const _LoadedHeader({Key? key})
      : _type = LoadedHeaderType.fixed,
        title = null,
        point = 0,
        super(key: key);
  const _LoadedHeader.functional({Key? key, this.point = 0})
      : _type = LoadedHeaderType.functional,
        title = null,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case LoadedHeaderType.fixed:
        return Container(
          height: kFixedHeaderHeight,
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
          height: kFunctionalHeaderHeight,
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

enum LoadedHeaderType {
  fixed,
  functional,
}
