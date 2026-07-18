import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/liquid_glass_top_bar.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/material_top_bar.dart';
import 'package:x50pay/common/widgets/themed_scaffold/app_top_bar/top_bar_widget_builder.dart';
import 'package:x50pay/common/widgets/themed_scaffold/nav_bottom_bar/liquid_glass_nav_bottom_bar.dart';
import 'package:x50pay/common/widgets/themed_scaffold/nav_bottom_bar/material_nav_bottom_bar.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';

class ThemedScaffold extends StatelessWidget {
  final Widget body;
  const ThemedScaffold(this.body, {super.key});

  static double topBarHeight(BuildContext context) {
    final isLiquidGlass = context.read<AppInitializer>().useLiquidGlassMode;
    return isLiquidGlass ? LiquidGlassTopBar.height : MaterialTopBar.height;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final statusBarHeight = padding.top;
    final navigationBarHeight = padding.bottom;
    final topBarWidgetBuilder = TopBarWidgetBuilder();
    final liquidGlassScaffold = GlassScaffold(
      edgeFade: true,
      appBar: LiquidGlassTopBar(topBarWidgetBuilder),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: padding.copyWith(
            top: statusBarHeight + LiquidGlassTopBar.height + 8,
            bottom: navigationBarHeight + LiquidGlassNavBottomBar.height + 8,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: body),
            const Positioned(
              left: 0,
              right: 0,
              height: LiquidGlassTopBar.height,
              child: ColoredBox(color: Colors.black26),
            ),
          ],
        ),
      ),
      bottomBar: const LiquidGlassNavBottomBar(),
    );

    final materialScaffold = Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MaterialTopBar(topBarWidgetBuilder),
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: padding.copyWith(
              top: MaterialTopBar.height,
              bottom: navigationBarHeight + MaterialNavBottomBar.height,
            ),
          ),
          child: body,
        ),
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
