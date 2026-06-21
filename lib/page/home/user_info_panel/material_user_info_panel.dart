import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
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
    final widget = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              shadows: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return MaterialGlass.withShadow(
      padding: const EdgeInsets.all(16),
      borderRadius: 15,
      child: widget,
    );
  }
}
