import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:x50pay/common/app_theme_mixin.dart';

class LiquidGlassEventInfo extends StatelessWidget {
  final Iterable<String> messages;

  const LiquidGlassEventInfo(this.messages, {super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = AppThemeHelper(context).iconColor;
    return GlassContainer(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 2),
      shape: const LiquidRoundedRectangle(borderRadius: 15),
      child: Stack(
        children: [
          Positioned(
            right: -28,
            bottom: -35,
            child: Icon(
              Icons.notifications_rounded,
              size: 140,
              color: iconColor.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: messages.map((m) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 1.5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                      Expanded(
                        child: Text(m, style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
