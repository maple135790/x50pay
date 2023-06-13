import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x50pay/r.g.dart';

class ProgressBar extends StatefulWidget {
  final double currentValue;
  const ProgressBar({super.key, required this.currentValue});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with TickerProviderStateMixin {
  late Future<DrawableRoot> getDrawableRoot;
  late ui.Image heartIcon;
  late Future<void> loadImageInit;
  late Animation<double> animation;
  late final Animation<double> curve = CurvedAnimation(parent: controller, curve: Curves.linear);
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
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _loadImage() async {
    ByteData bd = await rootBundle.load(R.image.heart_regular().assetName);
    final Uint8List bytes = Uint8List.view(bd.buffer);
    final codec =
        await ui.instantiateImageCodec(bytes, targetHeight: 12, targetWidth: 12, allowUpscaling: false);
    final image = (await codec.getNextFrame()).image;

    setState(() => heartIcon = image);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadImageInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RepaintBoundary(
            child: CustomPaint(
              painter: ProgressBackgroundPainter(dx: animation.value),
              foregroundPainter: ProgressPainter(progress: widget.currentValue, image: heartIcon),
              size: const Size(double.maxFinite, 24),
              willChange: true,
            ),
          ),
        );
      },
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final ui.Image image;
  final imagePadding = 8;
  final progressBarHeight = 24.0;

  const ProgressPainter({required this.progress, required this.image});
  @override
  void paint(Canvas canvas, Size size) {
    final width = min(size.width * ((progress < 8 ? 8 : progress) / 100), size.width);
    final imageX = width - image.width - imagePadding;
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(Offset.zero & Size(width, progressBarHeight), const Radius.circular(24)),
        Paint()..color = const Color(0xffff9bad),
      )
      ..drawImage(image, Offset(imageX, 6),
          Paint()..colorFilter = const ColorFilter.mode(Colors.white, BlendMode.srcATop));
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
