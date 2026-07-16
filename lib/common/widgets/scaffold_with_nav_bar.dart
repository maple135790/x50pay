import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/common/widgets/themed_scaffold/nav_bottom_bar/menu_item.dart';
import 'package:x50pay/common/widgets/themed_scaffold/themed_scaffold.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/route/app_route.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget body;

  const ScaffoldWithNavBar({super.key, required this.body});

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar>
    with AppThemeMixin {
  DateTime lastPopTime = DateTime.fromMillisecondsSinceEpoch(0);
  static const _kMinPopInterval = Duration(milliseconds: 500);
  late int selectedIndex = MenuItem.values.indexWhere(
    (e) => GoRouterState.of(context).path?.contains(e.route.path) ?? false,
  );

  S get i18n => S.of(context);

  Future<bool?> confirmPopup() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.confirmExitAppTitle),
          content: Text(i18n.confirmExitAppContent),
          actions: [
            TextButton(
              style: CustomButtonThemes.severe(isV4: true),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text(i18n.dialogConfirm),
            ),
            TextButton(
              style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(i18n.dialogCancel),
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
    selectedIndex = MenuItem.values.indexWhere((e) {
      return currentLocation.contains(e.route.path.split('/')[1]);
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
      context.goNamed(AppRoute.home.routeName);
      setState(() {});
      return false;
    }
    return true;
  }

  Future<bool> handleBackButton() async {
    final routerState = GoRouterState.of(context);
    final router = GoRouter.of(context);
    final currentRouteName = routerState.topRoute?.name;
    final currentfullPath = routerState.fullPath;
    if (currentfullPath == null || currentRouteName == null) return false;

    log('currentLocation: $currentRouteName');
    log('currentPath: $currentfullPath');
    if (currentRouteName == AppRoute.gameCab.routeName) {
      context.pop();
      setState(() {});
    } else if (currentRouteName == AppRoute.scanQRCode.routeName) {
      context.pop();
      setState(() {});
    } else if (currentfullPath.contains(AppRoute.settings.path)) {
      context.pop();
      setState(() {});
    } else if (currentRouteName != AppRoute.home.routeName) {
      context.goNamed(AppRoute.home.routeName);
      setState(() {});
    } else if (router.canPop()) {
      router.pop();
    } else {
      confirmPopup();
    }
    // 攔截所有返回事件
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: handleBackButton,
      // TODO: 等待GoRouter 修復PopScope issue (flutter #138737)
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (selectedIndex != 2) {
            context.goNamed(AppRoute.home.routeName);
            setState(() {});
          } else {
            confirmPopup();
          }
        },
        child: ThemedScaffold(widget.body),
      ),
    );
  }
}
