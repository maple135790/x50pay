import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';
import 'package:x50pay/page/home/mari_info/liquid_glass_mari_info.dart';
import 'package:x50pay/page/home/mari_info/material_mari_info.dart';

class MariInfo extends StatelessWidget {
  /// 真璃養成點數資訊
  ///
  /// 包含等級、養成點數、養成點數進度條、養成點數商城按鈕等
  const MariInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => const LiquidGlassMariInfo(),
      materialWidgetBuilder: () => const MaterialMariInfo(),
    );
  }
}
