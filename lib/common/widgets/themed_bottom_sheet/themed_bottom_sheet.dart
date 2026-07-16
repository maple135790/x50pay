import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/widgets/themed_bottom_sheet/liquid_glass_bottom_sheet.dart';
import 'package:x50pay/common/widgets/themed_bottom_sheet/material_glass_bottom_sheet.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';

class ThemedBottomSheet extends StatelessWidget {
  final String title;
  final WidgetBuilder builder;
  const ThemedBottomSheet(this.title, this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () =>
          LiquidGlassBottomSheet(title, builder: builder),
      materialWidgetBuilder: () =>
          MaterialGlassBottomSheet(title, builder: builder),
    );
  }
}

Future<T?> showThemedModalBottomSheet<T>({
  required BuildContext context,
  required String title,
  required WidgetBuilder builder,
  double scrollControlDisabledMaxHeightRatio = 0.85,
  bool isDismissible = true,
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible,
    useSafeArea: true,
    scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    useRootNavigator: useRootNavigator,
    builder: (context) {
      return ThemedBottomSheet(title, builder);
    },
  );
}
