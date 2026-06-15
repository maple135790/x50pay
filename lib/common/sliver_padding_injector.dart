import 'package:flutter/material.dart';

class SliverPaddingAutoInjector extends StatelessWidget {
  final List<Widget> slivers;
  final EdgeInsetsGeometry? padding;
  final Axis scrollDirection;

  const SliverPaddingAutoInjector({
    super.key,
    required this.slivers,
    this.padding,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    // 1. 將多個 slivers 組合在一起
    Widget sliverGroup = SliverMainAxisGroup(slivers: slivers);
    EdgeInsetsGeometry? effectivePadding = padding;

    if (padding == null) {
      final mediaQuery = MediaQuery.maybeOf(context);
      if (mediaQuery != null) {
        final EdgeInsets mediaQueryHorizontalPadding = mediaQuery.padding
            .copyWith(top: 0.0, bottom: 0.0);
        final EdgeInsets mediaQueryVerticalPadding = mediaQuery.padding
            .copyWith(left: 0.0, right: 0.0);

        effectivePadding = scrollDirection == Axis.vertical
            ? mediaQueryVerticalPadding
            : mediaQueryHorizontalPadding;

        sliverGroup = MediaQuery(
          data: mediaQuery.copyWith(
            padding: scrollDirection == Axis.vertical
                ? mediaQueryHorizontalPadding
                : mediaQueryVerticalPadding,
          ),
          child: sliverGroup,
        );
      }
    }

    if (effectivePadding != null) {
      sliverGroup = SliverPadding(
        padding: effectivePadding,
        sliver: sliverGroup,
      );
    }

    return sliverGroup;
  }
}
