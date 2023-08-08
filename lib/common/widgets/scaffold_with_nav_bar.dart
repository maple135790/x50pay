import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/r.g.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget body;

  const ScaffoldWithNavBar({super.key, required this.body});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  DateTime lastPopTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const _kMinPopInterval = Duration(milliseconds: 500);
  late int selectedIndex = _menus.indexWhere((element) =>
      GoRouterState.of(context).path?.contains(element.route.path) ?? false);

  final _menus = [
    (icon: Icons.sports_esports, label: '投幣', route: AppRoutes.gameStore),
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
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.body != widget.body) {
      selectedIndex = _menus.indexWhere((element) => GoRouterState.of(context)
          .matchedLocation
          .contains(element.route.path));
      setState(() {});
    }
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
        final popTime = DateTime.now();
        if (popTime.difference(lastPopTime) < _kMinPopInterval) return false;
        if (selectedIndex != 2) {
          selectedIndex = 2;
          lastPopTime = popTime;
          context.goNamed(AppRoutes.home.routeName);
          setState(() {});
          return false;
        }
        final shouldPop = await confirmPopup();
        lastPopTime = popTime;
        return shouldPop!;
      },
      child: Scaffold(
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
      ),
    );
  }
}

class _LoadedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int menuIndex;
  const _LoadedAppBar(this.menuIndex);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  double get functionalHeaderHeight =>
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
              height: functionalHeaderHeight,
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
