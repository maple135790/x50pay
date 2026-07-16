import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/widgets/persist_app_bar.dart';
import 'package:x50pay/providers/theme_provider.dart';

class DebugScaffold extends StatelessWidget {
  final VoidCallback? debugFunction;
  final Widget child;

  const DebugScaffold({
    super.key,
    required this.debugFunction,
    required this.child,
  });

  bool get shouldShowDebugButton => kDebugMode && debugFunction != null;

  @override
  Widget build(BuildContext context) {
    final themeHelper = AppThemeHelper(context);
    final debugButton = Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: "debug function",
          onPressed: debugFunction,
          child: const Icon(Icons.developer_mode_rounded),
        ),
        FloatingActionButton(
          heroTag: "brightness",
          child: const Icon(Icons.brightness_6_rounded),
          onPressed: () {
            final brightness = themeHelper.isDarkTheme
                ? Brightness.light
                : Brightness.dark;
            context.read<AppThemeProvider>().changeBrightness(brightness);
          },
        ),
      ],
    );

    return AnnotatedRegion(
      value: themeHelper.overlayStyle,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SafeArea(child: PersistentAppBar()),
        ),
        floatingActionButton: shouldShowDebugButton ? debugButton : null,
        body: SingleChildScrollView(
          child: Align(alignment: Alignment.topCenter, child: child),
        ),
      ),
    );
  }
}
