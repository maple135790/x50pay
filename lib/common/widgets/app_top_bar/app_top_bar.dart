import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/widgets/app_top_bar/liquid_glass_top_bar.dart';
import 'package:x50pay/common/widgets/app_top_bar/material_top_bar.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => const LiquidGlassTopBar(),
      materialWidgetBuilder: () => const MaterialTopBar(),
    );
  }
}
