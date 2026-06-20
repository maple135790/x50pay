import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:x50pay/common/custom_box_shadow.dart';
import 'package:x50pay/page/home/ticket_info/ticket_info.dart';

class MaterialTicketInfo extends StatelessWidget {
  final StampWidgetBuilder builder;

  const MaterialTicketInfo(this.builder, {super.key});

  String vipExpDate(String expDate) {
    final date = DateTime.parse(expDate);
    return '${date.month}/${date.day} ${date.hour}:${date.minute}';
  }

  Color getIconColor(bool isDarkTheme) {
    if (isDarkTheme) {
      return const Color(0xfffafafa).withValues(alpha: 0.1);
    } else {
      return const Color(0xff373737).withValues(alpha: 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stampGrid = GridView.builder(
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
              child: builder.stamp(index),
            ),
          ),
        );
      },
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          CustomBoxShadow(color: Colors.black26, blurRadius: 5),
        ],
      ),
      child: BackdropFilter(
        filterConfig: ImageFilterConfig.compose(
          outer: const ImageFilterConfig.blur(sigmaX: 1.45, sigmaY: 1.45),
          inner: ImageFilterConfig(ui.ColorFilter.saturation(1.7)),
        ),
        child: stampGrid,
      ),
    );
  }
}
