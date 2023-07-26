import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/navigator_keys.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/collab/collab.dart';
import 'package:x50pay/page/pages.dart';
import 'package:x50pay/r.g.dart';

class AppRouterConfig {
  static GoRoute _route(
    RouteProperty rp,
    Widget Function(BuildContext, GoRouterState)? builder, {
    GlobalKey<NavigatorState>? parentNavKey,
    List<RouteBase>? innerRoutes,
    FutureOr<String?> Function(BuildContext context, GoRouterState state)?
        redirect,
  }) {
    return GoRoute(
      parentNavigatorKey: parentNavKey ?? NavigatorKeys.shell,
      path: rp.path,
      name: rp.routeName,
      routes: innerRoutes ?? [],
      builder: builder,
      redirect: redirect,
    );
  }

  static final RouterConfig<Object> goRouteConfig = GoRouter(
    initialLocation: AppRoutes.home.path,
    navigatorKey: NavigatorKeys.root,
    debugLogDiagnostics: true,
    routes: [
      _route(
        AppRoutes.login,
        (_, __) => const Login(),
        parentNavKey: NavigatorKeys.root,
      ),
      ShellRoute(
        navigatorKey: NavigatorKeys.shell,
        routes: [
          _route(AppRoutes.game, (_, __) => const Game(), innerRoutes: [
            _route(AppRoutes.gameCabs, (_, state) {
              final gameList = state.extra as Gamelist?;
              if (gameList == null) return Home();
              return Account();
            }),
            _route(AppRoutes.gameStore, (_, state) => const Home()),
          ]),
          _route(AppRoutes.settings, (_, __) => const Account()),
          _route(AppRoutes.home, (_, __) => const Home(), innerRoutes: [
            _route(AppRoutes.buyMPass, (_, state) => const BuyMPass()),
          ]),
          _route(AppRoutes.gift, (_, __) => const GiftSystem()),
          _route(AppRoutes.collab, (_, __) => const Collab()),
        ],
        builder: (context, state, child) {
          return ScaffoldWithNavBarSR(body: child);
        },
      ),
      // StatefulShellRoute.indexedStack(
      //   pageBuilder: (context, state, navigationShell) {
      //     return CupertinoPage<void>(
      //         child: ScaffoldWithNavBar(navigationShell: navigationShell));
      //   },
      //   branches: [
      //     StatefulShellBranch(
      //       navigatorKey: NavigatorKeys.game,
      //       routes: [
      //         _route(AppRoutes.game, (_, __) => const Game(), innerRoutes: [
      //           _route(AppRoutes.gameCabs, (_, __) => const Account()),
      //           _route(AppRoutes.gameStore, (_, __) => const Home()),
      //         ])
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       navigatorKey: NavigatorKeys.settings,
      //       routes: [
      //         _route(AppRoutes.settings, (_, __) => const Account()),
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       navigatorKey: NavigatorKeys.home,
      //       routes: [
      //         _route(AppRoutes.home, (_, __) => const Home(), innerRoutes: [
      //           _route(AppRoutes.buyMPass, (_, state) => const BuyMPass()),
      //         ])
      //       ],
      //     ),
      //     StatefulShellBranch(
      //       navigatorKey: NavigatorKeys.gift,
      //       routes: [_route(AppRoutes.gift, (_, __) => const GiftSystem())],
      //     ),
      //     StatefulShellBranch(
      //       navigatorKey: NavigatorKeys.collab,
      //       routes: [_route(AppRoutes.collab, (_, __) => const Collab())],
      //     ),
      //   ],
      // ),
    ],
  );
}

class ScaffoldWithNavBarSR extends StatefulWidget {
  final Widget body;

  const ScaffoldWithNavBarSR({super.key, required this.body});

  @override
  State<ScaffoldWithNavBarSR> createState() => _ScaffoldWithNavBarSRState();
}

class _ScaffoldWithNavBarSRState extends State<ScaffoldWithNavBarSR> {
  late int selectedIndex = _menus.indexWhere((element) =>
      GoRouterState.of(context).path?.contains(element.route.path) ?? false);

  final _menus = [
    (icon: Icons.sports_esports, label: '投幣', route: AppRoutes.game),
    (icon: Icons.settings, label: '設定', route: AppRoutes.settings),
    (icon: Icons.home_rounded, label: 'Me', route: AppRoutes.home),
    (icon: Icons.redeem_rounded, label: '禮物', route: AppRoutes.gift),
    (icon: Icons.handshake_rounded, label: '合作', route: AppRoutes.collab),
  ];
  @override
  initState() {
    super.initState();
    selectedIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    log('hello');
    return Scaffold(
      appBar: _LoadedAppBar(selectedIndex),
      body: widget.body,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border:
                Border(top: BorderSide(width: 1, color: Color(0xff3e3e3e)))),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (index) async {
            selectedIndex = index;
            context.goNamed(_menus[index].route.routeName);
            setState(() {});
          },
          destinations: _menus
              .map((menu) => NavigationDestination(
                    icon: Icon(menu.icon, color: const Color(0xffb4b4b4)),
                    label: menu.label,
                    selectedIcon:
                        Icon(menu.icon, color: const Color(0xfffafafa)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  static const _menus = [
    (icon: Icons.sports_esports, label: '投幣'),
    (icon: Icons.settings, label: '設定'),
    (icon: Icons.home_rounded, label: 'Me'),
    (icon: Icons.redeem_rounded, label: '禮物'),
    (icon: Icons.handshake_rounded, label: '合作'),
  ];

  @override
  Widget build(BuildContext context) {
    log('ScaffoldWithNavBar');
    return Scaffold(
      appBar: _LoadedAppBar(navigationShell.currentIndex),
      body: navigationShell,
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1, color: Color(0xff3e3e3e)),
            ),
          ),
          child: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (index) async {
              return navigationShell.goBranch(index, initialLocation: true);
            },
            destinations: _menus
                .map((menu) => NavigationDestination(
                      icon: Icon(menu.icon, color: const Color(0xffb4b4b4)),
                      label: menu.label,
                      selectedIcon:
                          Icon(menu.icon, color: const Color(0xfffafafa)),
                    ))
                .toList(),
          )),
    );
  }
}

class _LoadedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int menuIndex;
  const _LoadedAppBar(this.menuIndex);

  @override
  Size get preferredSize => const Size.fromHeight(50);
  int? get point => GlobalSingleton.instance.user?.point?.toInt();

  double getFunctionalHeaderHeight(int menuIndex) =>
      menuIndex == 2 ? 0 : preferredSize.height + 2;

  Widget buildFixedHeader(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
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
        ),
      ],
    );
  }

  Widget buildFunctionalHeader(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: preferredSize.height,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.black54,
        title: Align(
          alignment: Alignment.topRight,
          child: Container(
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
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                    color: const Color(0xfffafafa),
                    fontWeight: FontWeight.bold,
                  ))),
        ),
        actions: [
          InkWell(
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
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: SizedBox(
          child: Container(
            color: Colors.blue,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                buildFixedHeader(context),
                AnimatedPositioned(
                  height: getFunctionalHeaderHeight(menuIndex),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOutExpo,
                  top: 0,
                  child: buildFunctionalHeader(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
