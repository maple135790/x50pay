import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:x50pay/common/widgets/themed_scaffold/nav_bottom_bar/menu_item.dart';
import 'package:x50pay/generated/l10n.dart';

class LiquidGlassNavBottomBar extends StatelessWidget {
  const LiquidGlassNavBottomBar({super.key});

  static const height = 64.0;

  @override
  Widget build(BuildContext context) {
    final i18n = S.of(context);
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: GoRouter.of(context).routeInformationProvider,
        builder: (context, infoProvider, child) {
          final path = infoProvider.uri.path;
          final selectedIndex = MenuItem.values.indexWhere(
            (e) => path.contains(e.route.path),
          );
          return GlassTabBar.bottom(
            barHeight: height,
            selectedIconColor: Colors.red,
            onTabSelected: (index) {
              context.goNamed(MenuItem.values[index].route.routeName);
            },
            selectedIndex: selectedIndex,
            tabs: MenuItem.values.mapIndexed((index, item) {
              final isSelected = selectedIndex == index;
              final shadowColor = isSelected ? Colors.white38 : Colors.black45;
              final shadows = [
                Shadow(blurRadius: 0.8, color: shadowColor),
                Shadow(blurRadius: 10, color: shadowColor),
                Shadow(blurRadius: 21, color: shadowColor),
              ];
              return GlassTab(
                icon: Icon(item.icon, shadows: shadows),
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
      ),
    );
  }
}
