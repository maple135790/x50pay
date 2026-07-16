import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/change_background_bottom_sheet/liquid_glass_change_background_bottom_sheet.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/change_background_bottom_sheet/material_change_background_bottom_sheet.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';

class ChangeBackgroundBottomSheet extends StatelessWidget {
  const ChangeBackgroundBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () =>
          const LiquidGlassChangeBackgroundBottomSheet(),
      materialWidgetBuilder: () => const MaterialChangeBackgroundBottomSheet(),
    );
  }
}
