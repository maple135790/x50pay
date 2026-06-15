import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:x50pay/common/widgets/nav_bottom_bar/nav_bottom_bar.dart';
import 'package:x50pay/generated/l10n.dart';

class LiquidGlassNavBottomBar extends StatelessWidget {
  const LiquidGlassNavBottomBar({super.key});

  static const height = 64.0;

  @override
  Widget build(BuildContext context) {
    final i18n = S.of(context);
    return ValueListenableBuilder(
      valueListenable: GoRouter.of(context).routeInformationProvider,
      builder: (context, infoProvider, child) {
        final path = infoProvider.uri.path;
        final selectedIndex = MenuItem.values.indexWhere(
          (e) => path.contains(e.route.path),
        );
        return GlassBottomBar(
          barHeight: height,
          selectedIconColor: Colors.red,
          onTabSelected: (index) {
            context.goNamed(MenuItem.values[index].route.routeName);
          },
          selectedIndex: selectedIndex,
          tabs: MenuItem.values.map((item) {
            return GlassBottomBarTab(
              icon: Icon(item.icon),
              label: switch (item) {
                MenuItem.game => i18n.navGame,
                MenuItem.settings => i18n.navSettings,
                MenuItem.home => 'Me',
                MenuItem.gift => i18n.navGift,
                MenuItem.collab => i18n.navCollab,
              },
            );
          }).toList(),
        );
      },
    );
  }
}
