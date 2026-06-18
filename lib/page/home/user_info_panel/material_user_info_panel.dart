import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/user_info_panel/user_info_panel.dart';

class MaterialUserInfoPanel extends StatelessWidget {
  final InfoWidgetBuilder builder;
  final void Function(GoRouter router) onScannerPressed;
  const MaterialUserInfoPanel(
    this.builder, {
    super.key,
    required this.onScannerPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeHelper = AppThemeHelper(context);
    final isDarkTheme = themeHelper.isDarkTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isDarkTheme
              ? CustomColorThemes.borderColorDark
              : CustomColorThemes.borderColorLight,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                builder.nameInfo(GoRouter.of(context)),
                const SizedBox(height: 5),
                builder.pointInfo(),
                const SizedBox(height: 5),
                builder.ticketInfo(S.of(context)),
              ],
            ),
            const Spacer(),
            VerticalDivider(
              thickness: 1,
              width: 0,
              color: isDarkTheme
                  ? CustomColorThemes.borderColorDark
                  : CustomColorThemes.borderColorLight,
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                onScannerPressed(GoRouter.of(context));
              },
              child: const Icon(Icons.qr_code_rounded, size: 45),
            ),
          ],
        ),
      ),
    );
  }
}
