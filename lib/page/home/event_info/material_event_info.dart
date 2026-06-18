import 'package:flutter/material.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/theme/color_theme.dart';

class MaterialEventInfo extends StatelessWidget {
  final Iterable<String> messages;

  const MaterialEventInfo(this.messages, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.brightnessOf(context) == Brightness.dark;
    final iconColor = AppThemeHelper(context).iconColor;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkTheme
              ? CustomColorThemes.borderColorDark
              : CustomColorThemes.borderColorLight,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
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
