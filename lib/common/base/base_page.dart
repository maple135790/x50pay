import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/widgets/persist_app_bar.dart';
import 'package:x50pay/providers/theme_provider.dart';

mixin BasePage<T extends StatefulWidget> on BaseStatefulState<T> {
  Widget body(BuildContext context);
  void Function()? debugFunction;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
          isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SafeArea(child: PersistentAppBar()),
        ),
        floatingActionButton: kDebugMode && debugFunction != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                      onPressed: debugFunction,
                      child: const Icon(Icons.developer_mode_rounded)),
                  FloatingActionButton(
                    child: const Icon(Icons.brightness_6_rounded),
                    onPressed: () {
                      Theme.of(context).brightness == Brightness.dark
                          ? context
                              .read<AppThemeProvider>()
                              .changeBrightness(Brightness.light)
                          : context
                              .read<AppThemeProvider>()
                              .changeBrightness(Brightness.dark);
                    },
                  )
                ],
              )
            : null,
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: body(context),
          ),
        ),
      ),
    );
  }
}
