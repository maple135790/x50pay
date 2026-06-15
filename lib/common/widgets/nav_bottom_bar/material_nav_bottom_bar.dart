import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/widgets/nav_bottom_bar/nav_bottom_bar.dart';
import 'package:x50pay/generated/l10n.dart';

class MaterialNavBottomBar extends StatelessWidget {
  const MaterialNavBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeHelper = AppThemeHelper(context);
    final i18n = S.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: themeHelper.borderColor),
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: GoRouter.of(context).routeInformationProvider,
        builder: (context, infoProvider, child) {
          final path = infoProvider.uri.path;
          final selectedIndex = MenuItem.values.indexWhere(
            (e) => path.contains(e.route.path),
          );
          return NavigationBar(
            selectedIndex: selectedIndex,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (index) {
              context.goNamed(MenuItem.values[index].route.routeName);
            },
            destinations: MenuItem.values.map((menu) {
              return NavigationDestination(
                icon: Icon(menu.icon),
                label: switch (menu) {
                  MenuItem.game => i18n.navGame,
                  MenuItem.settings => i18n.navSettings,
                  MenuItem.home => 'Me',
                  MenuItem.gift => i18n.navGift,
                  MenuItem.collab => i18n.navCollab,
                },
                selectedIcon: Icon(menu.icon),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
