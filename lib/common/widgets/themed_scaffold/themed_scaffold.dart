import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/liquid_glass_top_bar.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/material_top_bar.dart';
import 'package:x50pay/common/widgets/themed_scaffold/nav_bottom_bar/liquid_glass_nav_bottom_bar.dart';
import 'package:x50pay/common/widgets/themed_scaffold/nav_bottom_bar/material_nav_bottom_bar.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';

class ThemedScaffold extends StatelessWidget {
  final Widget body;
  const ThemedScaffold(this.body, {super.key});

  @override
  Widget build(BuildContext context) {
    final liquidGlassScaffold = GlassScaffold(
      edgeFade: true,
      appBar: const LiquidGlassTopBar(),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: MediaQuery.paddingOf(context).copyWith(
            top:
                MediaQuery.paddingOf(context).top +
                LiquidGlassTopBar.height +
                8,
            bottom:
                MediaQuery.paddingOf(context).bottom +
                LiquidGlassNavBottomBar.height,
          ),
        ),
        child: body,
      ),
      bottomBar: const LiquidGlassNavBottomBar(),
    );

    final materialScaffold = Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const MaterialTopBar(),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: MediaQuery.paddingOf(context).copyWith(
            top: MediaQuery.paddingOf(context).top + kToolbarHeight,
            bottom:
                MediaQuery.paddingOf(context).bottom +
                MaterialNavBottomBar.height,
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: const MaterialNavBottomBar(),
    );

    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => liquidGlassScaffold,
      materialWidgetBuilder: () => materialScaffold,
    );
  }
}
