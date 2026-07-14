import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class LiquidGlassBottomSheet extends StatelessWidget {
  final String title;
  final WidgetBuilder builder;

  const LiquidGlassBottomSheet(this.title, {super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return GlassSheet(
      isScrollable: false,
      showDragIndicator: false,
      enableSaturationGlow: false,
      enableInteractionGlow: false,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      settings: const LiquidGlassSettings(
        blur: 10,
        thickness: 10,
        glassColor: Color.fromRGBO(255, 255, 255, 0.12),
        lightAngle: 0.75 * math.pi,
        lightIntensity: 0.7,
        ambientStrength: 0.4,
        saturation: 1.2,
        refractiveIndex: 0.15,
        chromaticAberration: 0.0,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: Column(
          spacing: 8,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 17, fontWeight: .w600),
                ),
                GlassIconButton(
                  icon: const CloseButtonIcon(),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            ),
            Expanded(child: builder(context)),
          ],
        ),
      ),
    );
  }
}
