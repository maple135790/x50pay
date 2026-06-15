import 'package:flutter/widgets.dart';
import 'package:x50pay/common/app_initializer.dart';

class ThemedWidgetFactory {
  ThemedWidgetFactory._();
  
  static T create<T extends Widget>(
    AppInitializer initializer, {
    required T Function() liquidGlassWidgetBuilder,
    required T Function() materialWidgetBuilder,
  }) {
    if (initializer.useLiquidGlassMode) {
      return liquidGlassWidgetBuilder();
    }
    return materialWidgetBuilder();
  }
}
