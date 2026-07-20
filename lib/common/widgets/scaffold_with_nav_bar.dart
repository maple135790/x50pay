import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/widgets/confirm_exit_dialog.dart';
import 'package:x50pay/common/widgets/themed_scaffold/themed_scaffold.dart';
import 'package:x50pay/route/app_route.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget body;

  const ScaffoldWithNavBar({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    Future<bool?> confirmPopup() {
      return showDialog<bool>(
        context: context,
        builder: (context) {
          return const ConfirmExitDialog();
        },
      );
    }

    Future<bool> handleBackButton() async {
      final routerState = GoRouterState.of(context);
      final router = GoRouter.of(context);
      final currentRouteName = routerState.topRoute?.name;
      final currentfullPath = routerState.fullPath;
      if (currentfullPath == null || currentRouteName == null) return false;

      if (router.canPop()) {
        router.pop();
      } else if (currentRouteName != AppRoute.home.routeName) {
        context.goNamed(AppRoute.home.routeName);
      } else {
        confirmPopup();
      }
      // 攔截所有返回事件
      return true;
    }

    return BackButtonListener(
      onBackButtonPressed: handleBackButton,
      child: ThemedScaffold(body),
    );
  }
}
