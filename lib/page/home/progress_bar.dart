import 'dart:math' hide log;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:xml/xml.dart';

class ProgressBar extends StatefulWidget {
  final double currentValue;
  final VoidCallback onProgressBarCreated;
  const ProgressBar(
      {super.key,
      required this.currentValue,
      required this.onProgressBarCreated});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with TickerProviderStateMixin {
  late Future<DrawableRoot> getDrawableRoot;
  late Path heartPath;
  late Future<void> loadImageInit;
  late Animation<double> animation;
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FutureBuilder<void>(
        future: loadImageInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(height: 24, width: double.maxFinite);
          }
          return RepaintBoundary(
            child: CustomPaint(
              painter: ProgressBackgroundPainter(dx: animation.value),
              foregroundPainter: ProgressPainter(
                iconPath: heartPath,
                progress: widget.currentValue,
                iconSize: heartPath.getBounds().size,
              ),
              size: const Size(double.maxFinite, 24),
              willChange: true,
            ),
          );
        },
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final Path iconPath;
  final Size iconSize;
  static const imagePadding = 8.5;
  static const progressBarHeight = 24.0;

  const ProgressPainter({
    required this.progress,
    required this.iconPath,
    required this.iconSize,
  });

  // Size get iconSize => iconPath.getBounds().size;

  @override
  void paint(Canvas canvas, Size size) {
    final width =
        min(size.width * ((progress < 8 ? 8 : progress) / 100), size.width);
    final xScale = 12 / iconSize.width * iconSize.aspectRatio;
    final yScale = 12 / iconSize.height;
    final offsetX = width - 12 - imagePadding;
    final offsetY = (progressBarHeight - iconSize.height * yScale) / 2;
    final scalingMatrix =
        Matrix4Transform().scaleBy(x: xScale, y: yScale).m.storage;
    final scaledIconPath =
        iconPath.transform(scalingMatrix).shift(Offset(offsetX, offsetY));
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(Offset.zero & Size(width, progressBarHeight),
            const Radius.circular(24)),
        Paint()..color = const Color(0xffff9bad),
      )
      ..drawPath(
          scaledIconPath,
          Paint()
            ..colorFilter =
                const ColorFilter.mode(Colors.white, BlendMode.srcATop));
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
