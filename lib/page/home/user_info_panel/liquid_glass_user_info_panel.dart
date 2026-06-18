import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/user_info_panel/user_info_panel.dart';

class LiquidGlassUserInfoPanel extends StatelessWidget {
  final InfoWidgetBuilder builder;
  final void Function(GoRouter router) onScannerPressed;

  const LiquidGlassUserInfoPanel(
    this.builder, {
    super.key,
    required this.onScannerPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
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
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                onScannerPressed(GoRouter.of(context));
              },
              child: const Icon(
                Icons.qr_code_rounded,
                size: 45,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
