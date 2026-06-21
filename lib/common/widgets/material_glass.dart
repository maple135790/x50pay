import 'package:flutter/material.dart';
import 'package:x50pay/common/custom_box_shadow.dart';

class MaterialGlass extends StatelessWidget {
  final Widget child;
  final bool _dropShadow;
  final Color? color;
  final Clip clipBehavior;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxShape shape;
  final bool isEnabled;

  const MaterialGlass({
    super.key,
    required this.child,
    this.color,
    this.clipBehavior = Clip.hardEdge,
    this.borderRadius = 0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.isEnabled = true,
  }) : _dropShadow = false;

  const MaterialGlass.withShadow({
    super.key,
    required this.child,
    this.color,
    this.clipBehavior = Clip.hardEdge,
    this.borderRadius = 0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.isEnabled = true,
  }) : _dropShadow = true;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = switch (shape) {
      .rectangle => BorderRadius.circular(borderRadius),
      .circle => null,
    };

    final effectiveColor = isEnabled
        ? color ?? Colors.white.withValues(alpha: .05)
        : null;

    final shadows = <BoxShadow>[];

    if (_dropShadow && isEnabled) {
      shadows.addAll(const [
        CustomBoxShadow(color: Colors.black26, blurRadius: 5),
      ]);
    }

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
        boxShadow: shadows,
        shape: shape,
      ),
      child: child,
    );
  }
}
