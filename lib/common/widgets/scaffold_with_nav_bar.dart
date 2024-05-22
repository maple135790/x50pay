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
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/common/widgets/persist_app_bar.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/language_provider.dart';

typedef MenuItem = ({IconData icon, String label, RouteProperty route});

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

  List<MenuItem> get _menus => [
        (
          icon: Icons.sports_esports_rounded,
          label: i18n.navGame,
          route: AppRoutes.gameCabs,
        ),
        (
          icon: Icons.settings_rounded,
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
          title: const Text('確認離開 ?'),
          actions: [
            TextButton(
              style: CustomButtonThemes.severe(isV4: true),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('是'),
            ),
            TextButton(
              style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
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
    final currentLocation = GoRouterState.of(context).matchedLocation;
    selectedIndex = _menus.indexWhere((element) {
      return currentLocation.contains(element.route.path.split('/')[1]);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = 2;
  }

  bool popDelegate() {
    final popTime = DateTime.now();
    if (popTime.difference(lastPopTime) < _kMinPopInterval) return false;
    if (selectedIndex != 2) {
      selectedIndex = 2;
      lastPopTime = popTime;
      context.goNamed(AppRoutes.home.routeName);
      setState(() {});
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedIndex == 2,
      onPopInvoked: (didPop) {
        if (selectedIndex != 2) {
          context.goNamed(AppRoutes.home.routeName);
          setState(() {});
        } else {
          confirmPopup();
        }
      },
      child: Scaffold(
        appBar: _LoadedAppBar(selectedIndex),
        body: widget.body,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1, color: borderColor),
            ),
          ),
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
                      icon: Icon(menu.icon),
                      label: menu.label,
                      selectedIcon: Icon(menu.icon),
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
  String get currentLocation => GoRouterState.of(context).matchedLocation;

  double get functionalHeaderHeight =>
      widget.menuIndex == 2 ? 0 : widget.preferredSize.height;

  void onQrScanButtonPressed() async {
    final router = GoRouter.of(context);
    var status = await Permission.camera.status;
    if (status.isDenied) await Permission.camera.request();
    if (context.mounted) {
      GlobalSingleton.instance.isInCameraPage = true;
      router.pushNamed(
        AppRoutes.scanQRCode.routeName,
        extra: status,
      );
    }
  }

  void onLanguagePressed(Locale currentLocale) async {
    final langProvider = context.read<LanguageProvider>();
    final changedLocale = await showDialog<Locale>(
      context: context,
      builder: (context) {
        return LanguageSelectDialog(currentLocale);
      },
    );
    if (changedLocale == null) return;
    if (!mounted) return;
    EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 800));
    EasyLoading.dismiss();
    langProvider.setUserPrefLocale(changedLocale);
  }

  @override
  Widget build(BuildContext context) {
    final functionalHeader = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: widget.preferredSize.height,
        elevation: isDarkTheme ? 15 : 4,
        scrolledUnderElevation: isDarkTheme ? 15 : 6.5,
        surfaceTintColor: Colors.transparent,
        backgroundColor: scaffoldBackgroundColor,
        shadowColor: Colors.black,
        title: Align(
          alignment: Alignment.topRight,
          child: Material(
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.5, horizontal: 18),
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? CustomColorThemes.appbarBoxColorDark
                    : CustomColorThemes.appbarBoxColorLight,
              ),
              child: ValueListenableBuilder<UserModel?>(
                valueListenable: GlobalSingleton.instance.userNotifier,
                builder: (context, user, child) {
                  final point = user?.point?.toInt() ?? -1;
                  final fpoint = user?.fpoint?.toInt() ?? -1;

                  return Text.rich(
                    TextSpan(
                      text: '$point + ',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge!.fontSize,
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
                          ),
                        ),
                        TextSpan(
                          text: ' P',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: !GlobalSingleton.instance.isInCameraPage
                ? onQrScanButtonPressed
                : null,
            splashFactory: NoSplash.splashFactory,
            child: Icon(
              Icons.qr_code_rounded,
              size: 28,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );

    final serviceStatus =
        GlobalSingleton.instance.isServiceOnline ? 'ONLINE' : 'OFFLINE';
    final statusColor = serviceStatus == 'ONLINE' ? Colors.green : Colors.grey;

    final debugStatus = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            GlobalSingleton.instance.appVersion,
            textScaler: const TextScaler.linear(0.95),
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.color
                  ?.withOpacity(0.5),
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.circle_rounded,
                size: 8,
                color: statusColor.withOpacity(0.5),
              ),
              const SizedBox(width: 2.5),
              Text(
                'Service $serviceStatus',
                textScaler: const TextScaler.linear(0.95),
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

    return AnnotatedRegion(
      value:
          isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const PersistentAppBar(),
            AnimatedPositioned(
              height: functionalHeaderHeight,
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeInOutExpo,
              top: 0,
              child: functionalHeader,
            ),
            if (kDebugMode) debugStatus,
          ],
        ),
      ),
    );
  }
}

class LanguageSelectDialog extends StatefulWidget {
  final Locale currentLocale;
  const LanguageSelectDialog(this.currentLocale, {super.key});

  @override
  State<LanguageSelectDialog> createState() => _LanguageSelectDialogState();
}

class _LanguageSelectDialogState
    extends BaseStatefulState<LanguageSelectDialog> {
  late var selectedLocale = widget.currentLocale;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(i18n.x50PayLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          S.delegate.supportedLocales.length,
          (index) => RadioListTile<Locale>(
            visualDensity: VisualDensity.compact,
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
            groupValue: selectedLocale,
            onChanged: (value) {
              context.pop(value);
            },
          ),
          growable: false,
        ),
      ),
    );
  }
}
