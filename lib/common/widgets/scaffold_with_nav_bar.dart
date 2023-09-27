import 'package:country_flags/country_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/language_view_model.dart';
import 'package:x50pay/r.g.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget body;

  const ScaffoldWithNavBar({super.key, required this.body});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends BaseStatefulState<ScaffoldWithNavBar> {
  DateTime lastPopTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const _kMinPopInterval = Duration(milliseconds: 500);
  late int selectedIndex = _menus.indexWhere((element) =>
      GoRouterState.of(context).path?.contains(element.route.path) ?? false);

  String currentLocation = '';

  late final _menus = [
    (
      icon: Icons.sports_esports,
      label: i18n.navGame,
      route: AppRoutes.gameStore
    ),
    (
      icon: Icons.settings,
      label: i18n.navSettings,
      route: AppRoutes.settings,
    ),
    (
      icon: Icons.home_rounded,
      label: 'Me',
      route: AppRoutes.home,
    ),
    (
      icon: Icons.redeem_rounded,
      label: i18n.navGift,
      route: AppRoutes.gift,
    ),
    (
      icon: Icons.handshake_rounded,
      label: i18n.navCollab,
      route: AppRoutes.collab
    ),
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
    if (oldWidget.body == widget.body) return;

    // 如果頁面有更換，則重新計算 selectedIndex。
    // 最明顯的例子是用於 [home] 的 養成點數商場頁面。
    selectedIndex = _menus.indexWhere((element) {
      return currentLocation.contains(element.route.path.split('/')[1]);
    });
  }

  @override
  initState() {
    super.initState();
    selectedIndex = 2;
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (currentLocation == AppRoutes.home.path) {
      GlobalSingleton.instance.checkUser(force: true);
    }
    if (context.mounted) {
      setState(() {});
    }
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
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: widget.body,
        ),
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
              currentLocation = _menus[index].route.path;
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

class _LoadedAppBar extends StatefulWidget implements PreferredSizeWidget {
  final int menuIndex;

  const _LoadedAppBar(this.menuIndex);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  State<_LoadedAppBar> createState() => _LoadedAppBarState();
}

class _LoadedAppBarState extends BaseStatefulState<_LoadedAppBar> {
  late final currentLocale = context.read<LanguageViewModel>().currentLocale;
  String get currentLocation => GoRouterState.of(context).matchedLocation;

  double get functionalHeaderHeight =>
      widget.menuIndex == 2 ? 0 : widget.preferredSize.height + 2;

  Widget buildDebugStatus() {
    String serviceStatus =
        GlobalSingleton.instance.isServiceOnline ? 'ONLINE' : 'OFFLINE';
    Color statusColor = serviceStatus == 'ONLINE' ? Colors.green : Colors.grey;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(GlobalSingleton.instance.appVersion,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              )),
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: statusColor.withOpacity(0.5),
              ),
              const SizedBox(width: 2.5),
              Text(
                'Service $serviceStatus',
                style: TextStyle(
                  color: statusColor.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void onLanguagePressed() async {
    final changedLocale = await showDialog<Locale>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(S.of(context).x50PayLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              S.delegate.supportedLocales.length,
              (index) => RadioListTile<Locale>(
                controlAffinity: ListTileControlAffinity.trailing,
                value: S.delegate.supportedLocales[index],
                title: Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      S.delegate.supportedLocales[index].countryCode ?? '',
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(S.delegate.supportedLocales[index].displayText),
                  ],
                ),
                groupValue: currentLocale,
                onChanged: (value) {
                  context.pop(value);
                },
              ),
              growable: false,
            ),
          ),
        );
      }),
    );
    if (changedLocale == null) return;
    if (!mounted) return;
    EasyLoading.show();
    Future.delayed(const Duration(milliseconds: 800), () {
      EasyLoading.dismiss();
      context.read<LanguageViewModel>().setUserPrefLocale(changedLocale);
    });
  }

  Widget buildFixedHeader(BuildContext context) {
    final currentLocale = context.read<LanguageViewModel>().currentLocale;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: scaffoldBackgroundColor,
              border: const Border(
                  bottom: BorderSide(color: Themes.borderColor, width: 1))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: CircleAvatar(
                      backgroundImage: R.image.header_icon_rsz(),
                      backgroundColor: Colors.black,
                      radius: 14),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onLanguagePressed,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 6.75,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff2a2a2a),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CountryFlag.fromCountryCode(
                                  currentLocale.countryCode ?? '',
                                  height: 15,
                                  width: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(currentLocale.displayText),
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
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
        toolbarHeight: widget.preferredSize.height,
        elevation: 15,
        scrolledUnderElevation: 15,
        surfaceTintColor: Colors.transparent,
        backgroundColor: scaffoldBackgroundColor,
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
                builder: (context, user, child) {
                  final point = user?.point?.toInt() ?? -1;
                  final fpoint = user?.fpoint?.toInt() ?? -1;

                  return Text.rich(TextSpan(
                      text: '$point + ',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge!.fontSize,
                        color: const Color(0xfffafafa),
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                            text: '$fpoint',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .fontSize,
                              color: const Color(0xffd4b106),
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                          text: ' P',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .fontSize,
                            color: const Color(0xfffafafa),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]));
                },
              )),
        ),
        actions: [
          InkWell(
              onTap: !GlobalSingleton.instance.isInCameraPage
                  ? () async {
                      var status = await Permission.camera.status;
                      if (status.isDenied) await Permission.camera.request();
                      if (context.mounted) {
                        GlobalSingleton.instance.isInCameraPage = true;
                        context.pushNamed(
                          AppRoutes.scanQRCode.routeName,
                          extra: status,
                        );
                      }
                    }
                  : null,
              splashFactory: NoSplash.splashFactory,
              child: const Icon(Icons.qr_code_rounded,
                  size: 28, color: Color(0xfffafafa))),
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
            if (kDebugMode) buildDebugStatus(),
          ],
        ),
      ),
    );
  }
}
