import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/custom_box_shadow.dart';
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
      final decoration = isSelected
          ? BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                CustomBoxShadow(color: Colors.black26, blurRadius: 5),
              ],
            )
          : null;
      final clip = isSelected ? Clip.antiAlias : Clip.none;
      final label = switch (menu) {
        MenuItem.game => i18n.navGame,
        MenuItem.settings => i18n.navSettings,
        MenuItem.home => 'Me',
        MenuItem.gift => i18n.navGift,
        MenuItem.collab => i18n.navCollab,
      };
      final shadows = const [
        Shadow(blurRadius: 0.8, color: Colors.black38),
        Shadow(blurRadius: 10, color: Colors.black38),
        Shadow(blurRadius: 21, color: Colors.black38),
      ];
      Widget widget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2,
        children: [
          Icon(menu.icon, color: color, shadows: shadows),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
              color: color,
              shadows: shadows,
            ),
          ),
        ],
      );
      if (isSelected) {
        widget = BackdropFilter(
          filterConfig: ImageFilterConfig.compose(
            outer: const ImageFilterConfig.blur(sigmaX: 1.45, sigmaY: 1.45),
            inner: ImageFilterConfig(ui.ColorFilter.saturation(1.7)),
          ),
          child: widget,
        );
      }

      return GestureDetector(
        onTap: () {
          context.goNamed(menu.route.routeName);
        },
        child: AnimatedContainer(
          duration: Durations.long2,
          clipBehavior: clip,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2.5),
          decoration: decoration,
          child: widget,
        ),
      );
    }

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            CustomBoxShadow(color: Colors.black26, blurRadius: 5),
          ],
        ),
        child: BackdropFilter(
          filterConfig: ImageFilterConfig.compose(
            outer: const ImageFilterConfig.blur(sigmaX: 1.45, sigmaY: 1.45),
            inner: ImageFilterConfig(ui.ColorFilter.saturation(1.7)),
          ),
          child: ValueListenableBuilder(
            valueListenable: GoRouter.of(context).routeInformationProvider,
            builder: (context, infoProvider, child) {
              final path = infoProvider.uri.path;
              final current = MenuItem.values.firstWhere(
                (e) => path.contains(e.route.path),
              );
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: MenuItem.values
                    .map(
                      (menu) => Expanded(
                        child: buildItem(menu, isSelected: menu == current),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
