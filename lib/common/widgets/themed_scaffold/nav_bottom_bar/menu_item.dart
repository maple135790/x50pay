import 'package:flutter/material.dart';
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
