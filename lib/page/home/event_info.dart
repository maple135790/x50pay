import 'package:flutter/material.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/generated/l10n.dart';

class EventInfo extends StatelessWidget {
  /// 活動資訊
  final List<Evlist> events;

  /// 訊息告知區塊
  const EventInfo({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final i18n = S.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 13.5, 15, 6),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkTheme
                ? CustomColorThemes.borderColorDark
                : CustomColorThemes.borderColorLight,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題
            Transform.translate(
              offset: const Offset(9.8, -12),
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.8),
                  child: Text(i18n.msgNotify),
                ),
              ),
            ),
            // 訊息告知區塊不需要使用 Vertical Padding
            ...events.map((evt) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("> ${evt.name} : ${evt.describe}\n"),
                ))
          ],
        ),
      ),
    );
  }
}
