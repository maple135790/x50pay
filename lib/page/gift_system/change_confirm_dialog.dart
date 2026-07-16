import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';
import 'package:x50pay/route/app_route.dart';

class ChangeConfirmDialog extends StatelessWidget {
  final String gid;

  const ChangeConfirmDialog({super.key, required this.gid});

  @override
  Widget build(BuildContext context) {
    final themeHelper = AppThemeHelper(context);

    void onConfirm() async {
      final nav = GoRouter.of(context);
      if (kReleaseMode) {
        await context.read<MainRepository>().giftExchange(gid);
      }
      await EasyLoading.showSuccess(
        '成功兌換,將會回到首頁',
        duration: const Duration(milliseconds: 800),
      );
      await Future.delayed(const Duration(milliseconds: 800));

      nav.goNamed(AppRoute.home.routeName);
    }

    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_rounded, size: 60),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('請確認已經出示給工作人員看過'),
                SizedBox(height: 16),
                Text(
                  '您確定要兌換禮物嗎？',
                  style: TextStyle(
                    color: Color(0xfffad814),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 0),
          Container(
            color: themeHelper.dialogButtomBarColor,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: CustomButtonThemes.cancel(
                      isDarkMode: themeHelper.isDarkTheme,
                    ),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextButton(
                    onPressed: onConfirm,
                    style: CustomButtonThemes.severe(isV4: true),
                    child: const Text('確認'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
