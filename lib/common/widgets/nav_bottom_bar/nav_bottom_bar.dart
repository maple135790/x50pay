import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/widgets/nav_bottom_bar/liquid_glass_nav_bottom_bar.dart';
import 'package:x50pay/common/widgets/nav_bottom_bar/material_nav_bottom_bar.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';
import 'package:x50pay/route/app_route.dart';

enum MenuItem {
  game(icon: Icons.sports_esports_rounded, route: AppRoute.gameCabs),
  settings(icon: Icons.settings_rounded, route: AppRoute.settings),
  home(icon: Icons.home_rounded, route: AppRoute.home),
  gift(icon: Icons.redeem_rounded, route: AppRoute.gift),
  collab(icon: Icons.handshake_rounded, route: AppRoute.collab);

  final IconData icon;
  final AppRoute route;

  const MenuItem({required this.icon, required this.route});
}

class NavBottomBar extends StatelessWidget {
  const NavBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => const LiquidGlassNavBottomBar(),
      materialWidgetBuilder: () => const MaterialNavBottomBar(),
    );
  }
}
