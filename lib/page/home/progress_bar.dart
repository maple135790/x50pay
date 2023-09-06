import 'dart:math' hide log;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

typedef ProgressIcon = ({Path iconPath, Size iconSize});

class ProgressBar extends StatefulWidget {
  final double currentValue;
  final VoidCallback onProgressBarCreated;
  final String? progressText;
  final double height;
  final Color? progressColor;

  const ProgressBar(
      {super.key,
      required this.currentValue,
      required this.height,
      this.progressColor,
      this.progressText,
      required this.onProgressBarCreated});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  late Future<DrawableRoot> getDrawableRoot;
  late double barHeight = widget.height;
  late Path heartPath;
  late Future<void> loadImageInit;
  late Animation<double> animation;
  late ProgressIcon defaultHeartIcon;
  late final Animation<double> curve =
      CurvedAnimation(parent: controller, curve: Curves.linear);
  late final AnimationController controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: false);
  final backgroundOffsetTween = Tween<double>(begin: 0, end: 40);

  @override
  void initState() {
    super.initState();
    loadImageInit = _loadImage();
    animation = backgroundOffsetTween.animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        }
      });
    controller.forward();
    widget.onProgressBarCreated.call();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    final doc = XmlDocument.parse(
        await rootBundle.loadString('assets/images/home/heart-regular.svg'));
    final svgPath =
        doc.rootElement.getElement('path')!.getAttribute('d')!.toString();
    heartPath = parseSvgPathData(svgPath);
    defaultHeartIcon =
        (iconPath: heartPath, iconSize: heartPath.getBounds().size);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadImageInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(height: barHeight, width: double.maxFinite);
        }
        return RepaintBoundary(
          child: CustomPaint(
            painter: ProgressBackgroundPainter(dx: animation.value),
            foregroundPainter: ProgressPainter(
              progress: widget.currentValue,
              icon: widget.progressText == null ? defaultHeartIcon : null,
              barHeight: barHeight,
              text: widget.progressText,
              progressColor: widget.progressColor,
            ),
            size: Size(double.maxFinite, barHeight),
            willChange: true,
          ),
        );
      },
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final double barHeight;
  final Color? progressColor;
  final String? text;
  final ProgressIcon? icon;

  static const leadingPadding = 8.5;
  static const defaultIconWidth = 12;

  const ProgressPainter({
    required this.progress,
    required this.barHeight,
    this.progressColor,
    this.text,
    this.icon,
  });

  bool get isUseIcon => icon != null;

  Path _getScaledIconPath(double progressWidth) {
    assert(icon != null);
    final iconSize = icon!.iconSize;
    final iconPath = icon!.iconPath;

    final xScale = defaultIconWidth / iconSize.width * iconSize.aspectRatio;
    final yScale = defaultIconWidth / iconSize.height;
    final offsetX = progressWidth - defaultIconWidth - leadingPadding;
    final offsetY = (barHeight - iconSize.height * yScale) / 2;
    final scalingMatrix =
        Matrix4Transform().scaleBy(x: xScale, y: yScale).m.storage;
    return iconPath.transform(scalingMatrix).shift(Offset(offsetX, offsetY));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final progressBarColor = progressColor ?? const Color(0xffff9bad);
    final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Color(0xffff5070), fontSize: 10),
        ));
    if (!isUseIcon) textPainter.layout();
    final progressWidth = isUseIcon
        ? max(defaultIconWidth + leadingPadding * 2,
            min((size.width * ((progress) / 100)), size.width))
        : max(textPainter.width + leadingPadding * 2,
            min((size.width * ((progress) / 100)), size.width));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & Size(progressWidth, barHeight),
          const Radius.circular(24)),
      Paint()..color = progressBarColor,
    );
    if (isUseIcon) {
      canvas.drawPath(
          _getScaledIconPath(progressWidth),
          Paint()
            ..colorFilter =
                const ColorFilter.mode(Colors.white, BlendMode.srcATop));
    } else {
      textPainter.paint(
        canvas,
        Offset(progressWidth - textPainter.width - leadingPadding,
            ((size.height - textPainter.height) / 2)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ProgressBackgroundPainter extends CustomPainter {
  final double dx;

  const ProgressBackgroundPainter({required this.dx});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(24)),
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0 + dx, 0),
          Offset(40 + dx, 40),
          const [
            Color(0xff9e9e9e),
            Color(0xff949494),
            Color(0xff949494),
            Color(0xff9e9e9e),
            Color(0xff9e9e9e),
            Color(0xff949494),
            Color(0xff949494),
          ],
          [0.25, 0, 0.5, 0, 0.75, 0, 1],
          TileMode.repeated,
        ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
