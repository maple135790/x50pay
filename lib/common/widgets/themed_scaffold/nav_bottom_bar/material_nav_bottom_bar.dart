import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
import 'package:x50pay/common/widgets/themed_scaffold/nav_bottom_bar/menu_item.dart';
import 'package:x50pay/generated/l10n.dart';

class MaterialNavBottomBar extends StatelessWidget {
  const MaterialNavBottomBar({super.key});

  static const height = 88.0;

  @override
  Widget build(BuildContext context) {
    Widget buildItem(MenuItem menu, {required bool isSelected}) {
      final i18n = S.of(context);
      final color = isSelected ? const Color(0xfff4106b) : Colors.white;
      final shadowColor = isSelected ? Colors.white38 : Colors.black45;

      final label = switch (menu) {
        MenuItem.game => i18n.navGame,
        MenuItem.settings => i18n.navSettings,
        MenuItem.home => 'Me',
        MenuItem.gift => i18n.navGift,
        MenuItem.collab => i18n.navCollab,
      };
      final shadows = [
        Shadow(blurRadius: 0.8, color: shadowColor),
        Shadow(blurRadius: 10, color: shadowColor),
        Shadow(blurRadius: 21, color: shadowColor),
      ];

      return GestureDetector(
        onTap: () {
          // 目標 route 和當前 route 相同時，pop 到原始位置
          if (GoRouterState.of(context).uri.path == menu.route.path) {
            final router = GoRouter.of(context);
            while (router.canPop()) {
              router.pop();
            }
            return;
          }
          context.goNamed(menu.route.routeName);
        },
        child: MaterialGlass.withShadow(
          isEnabled: isSelected,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.5),
          color: Colors.white38,
          borderRadius: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                menu.icon,
                color: color,
                size: 28,
                shadows: [Shadow(color: shadowColor, blurRadius: 8)],
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: color,
                  shadows: shadows,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: MaterialGlass.withShadow(
        isBlurEnabled: true,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        color: const Color.fromARGB(59, 167, 167, 167),
        borderRadius: 100,
        child: ValueListenableBuilder(
          valueListenable: GoRouter.of(context).routeInformationProvider,
          builder: (context, infoProvider, child) {
            final path = infoProvider.uri.path;
            final current = MenuItem.values.firstWhere(
              (e) => path.contains(e.route.path),
            );
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: MenuItem.values.map((menu) {
                return Expanded(
                  child: buildItem(menu, isSelected: menu == current),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
