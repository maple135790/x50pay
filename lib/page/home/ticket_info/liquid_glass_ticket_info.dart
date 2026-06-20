
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:x50pay/page/home/ticket_info/ticket_info.dart';

class LiquidGlassTicketInfo extends StatelessWidget {
  final StampWidgetBuilder widgetBuilder;

  const LiquidGlassTicketInfo(this.widgetBuilder, {super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      useOwnLayer: true,
      settings: const LiquidGlassSettings(
        blur: 2,
        saturation: 2.5,
        glassColor: Colors.white12,
      ),
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 72 / 56,
        ),

        itemCount: 15,
        itemBuilder: (context, index) {
          final isFirstRow = index < 5;
          final isFirstCol = index % 5 == 0;
          final border = Border(
            top: isFirstRow
                ? BorderSide.none
                : const BorderSide(color: Colors.white24),
            left: isFirstCol
                ? BorderSide.none
                : const BorderSide(color: Colors.white24),
          );

          return Container(
            height: 42,
            decoration: BoxDecoration(border: border),
            child: Center(
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white10,
                ),
                child: widgetBuilder.stamp(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
