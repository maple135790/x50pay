part of '../main.dart';

GoRoute _route(
  RouteProperty rp,
  Widget Function(BuildContext, GoRouterState)? builder, {
  List<RouteBase>? innerRoutes,
  GoRouterRedirect? redirect,
}) {
  return GoRoute(
    path: rp.path,
    name: rp.routeName,
    routes: innerRoutes ?? [],
    builder: builder,
    redirect: redirect,
  );
}

final debugRoute = AppRoutes.home.path;

RouterConfig<Object> goRouteConfig(bool isLogin) => GoRouter(
      initialLocation:
          !GlobalSingleton.instance.devIsServiceOnline && kDebugMode
              ? debugRoute
              : isLogin
                  ? AppRoutes.home.path
                  : AppRoutes.login.path,
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          routes: [
            GoRoute(
              path: AppRoutes.forgotPassword.path,
              name: AppRoutes.forgotPassword.routeName,
              builder: (context, state) => const ForgotPassword(),
            ),
            GoRoute(
              path: AppRoutes.signUp.path,
              name: AppRoutes.signUp.routeName,
              builder: (context, state) => const SignUp(),
            ),
            GoRoute(
              path: AppRoutes.login.path,
              name: AppRoutes.login.routeName,
              builder: (context, state) => const Login(),
            ),
            _route(AppRoutes.game, (_, state) {
              final shouldRebuild = state.extra as bool?;
              if (shouldRebuild == true) {
                return Game(
                    key: ValueKey(DateTime.now().millisecondsSinceEpoch));
              }
              return const Game();
            }),
            GoRoute(
              path: AppRoutes.scanQRCode.path,
              name: AppRoutes.scanQRCode.routeName,
              builder: (context, state) {
                return ScanQRCode(state.extra as PermissionStatus);
              },
            ),
            _route(AppRoutes.license, (_, __) => const License()),
            _route(AppRoutes.settings, (_, __) => const Account()),
            _route(AppRoutes.home, (_, __) => const Home(), innerRoutes: [
              _route(AppRoutes.buyMPass, (_, state) => const BuyMPass()),
              _route(AppRoutes.questCampaign, (_, state) {
                final shouldRebuild = state.extra as bool?;
                if (shouldRebuild == true) {
                  return QuestCampaign(
                    key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                    campaignId: state.pathParameters['couid']!,
                  );
                }
                return QuestCampaign(
                  campaignId: state.pathParameters['couid']!,
                );
              }),
            ]),
            _route(AppRoutes.gift, (_, __) => const GiftSystem()),
            _route(AppRoutes.collab, (_, __) => const Collab()),
          ],
          builder: (context, state, child) {
            if (AppRoutes.noLoginPages
                .any((p) => p.path == state.uri.toString())) {
              return child;
            }
            return ScaffoldWithNavBar(body: child);
          },
        ),
      ],
    );

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget body;

  const ScaffoldWithNavBar({super.key, required this.body});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  late int selectedIndex = _menus.indexWhere((element) =>
      GoRouterState.of(context).path?.contains(element.route.path) ?? false);

  final _menus = [
    (icon: Icons.sports_esports, label: '投幣', route: AppRoutes.game),
    (icon: Icons.settings, label: '設定', route: AppRoutes.settings),
    (icon: Icons.home_rounded, label: 'Me', route: AppRoutes.home),
    (icon: Icons.redeem_rounded, label: '禮物', route: AppRoutes.gift),
    (icon: Icons.handshake_rounded, label: '合作', route: AppRoutes.collab),
  ];

  Future<bool?> confirmPopup() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('確認離開 ?', style: TextStyle(color: Color(0xfffafafa))),
          actions: [
            TextButton(
              style: Themes.severe(isV4: true),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('是'),
            ),
            TextButton(
              style: Themes.pale(),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('否'),
            ),
          ],
        );
      },
    );
  }

  @override
  initState() {
    super.initState();
    selectedIndex = 2;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await confirmPopup();
        return shouldPop!;
      },
      child: Scaffold(
        appBar: _LoadedAppBar(selectedIndex),
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => const SharedPreferencesDebugPage(),
        //     ),
        //   );
        // }),
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
      ),
    );
  }
}

class _LoadedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int menuIndex;
  const _LoadedAppBar(this.menuIndex);

  @override
  Size get preferredSize => const Size.fromHeight(50);
  // int? get point => GlobalSingleton.instance.user?.point?.toInt();

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
        elevation: 15,
        scrolledUnderElevation: 15,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.black87,
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
              child: ValueListenableBuilder<UserModel?>(
                valueListenable: GlobalSingleton.instance.userNotifier,
                builder: (context, value, child) {
                  final point = value?.point?.toInt() ?? -1;

                  return Text('$point P',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge!.fontSize,
                        color: const Color(0xfffafafa),
                        fontWeight: FontWeight.bold,
                      ));
                },
              )),
        ),
        actions: [
          InkWell(
              onTap: () async {
                var status = await Permission.camera.status;
                if (status.isDenied) await Permission.camera.request();
                if (context.mounted) {
                  context.pushNamed(
                    AppRoutes.scanQRCode.routeName,
                    extra: status,
                  );
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            buildFixedHeader(context),
            AnimatedPositioned(
              height: getFunctionalHeaderHeight(menuIndex),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutExpo,
              top: 0,
              child: buildFunctionalHeader(context),
            ),
          ],
        ),
      ),
    );
  }
}
