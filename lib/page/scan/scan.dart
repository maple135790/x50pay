import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/scan/qr_pay/cab_payment_result.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_view_model.dart';
import 'package:x50pay/repository/repository.dart';

typedef MachineData = ({String mid, String cid});

/// 掃描QRCode 頁面
class ScanQRCode extends StatefulWidget {
  const ScanQRCode({super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode>
    with AppThemeMixin, TickerProviderStateMixin, WidgetsBindingObserver {
  final controller = MobileScannerController(autoStart: false);

  late final Animation<double> blinkAnimation;
  late AnimationController qrPayModalTransistionController;
  late AnimationController scannerBlinkController;
  final isShowCameraPreviewNotifier = ValueNotifier(true);
  bool isBusy = false;

  void onTopUpPressed() async {
    controller.stop();
    isShowCameraPreviewNotifier.value = false;
    setState(() {});
    await context.pushNamed(AppRoutes.ecPay.routeName).then((_) {});
    isShowCameraPreviewNotifier.value = true;
    controller.start();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    GlobalSingleton.instance.isInCameraPage = true;

    qrPayModalTransistionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 300),
    );
    scannerBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 225),
      reverseDuration: const Duration(milliseconds: 160),
      lowerBound: 0.4,
    );

    qrPayModalTransistionController.drive(
      CurveTween(curve: Curves.fastLinearToSlowEaseIn),
    );
    scannerBlinkController.repeat(reverse: true);
    blinkAnimation = CurvedAnimation(
      parent: scannerBlinkController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
    controller.start();
  }

  @override
  void dispose() {
    log('dispose', name: 'ScanQRCode');
    GlobalSingleton.instance.isInCameraPage = false;
    qrPayModalTransistionController.dispose();
    controller.dispose();
    super.dispose();
  }

  void handleQRPay(String url) async {
    EasyLoading.show(status: '檢查');
    final args = url.replaceAll('https://pay.x50.fun/mid/', '').split('/');

    final viewModel = context.read<QRPayService>();
    final redirection = await viewModel.checkThirdPartyPaymentRedirect(
      mid: args[0],
      cid: args[1],
    );
    final machineData = (mid: args[0], cid: args[1]);
    switch (redirection.type) {
      case QRPayTPPRedirectType.x50Pay:
        await _handleX50PayRedirectResult(redirection.cabPaymentResult);
        break;
      case QRPayTPPRedirectType.none:
        EasyLoading.dismiss();
        showQRPayModal(machineData);
        break;
      case QRPayTPPRedirectType.jkoPay:
        launchUrlString(redirection.url, mode: LaunchMode.externalApplication);
        controller.start();
        EasyLoading.dismiss();
        break;
      case QRPayTPPRedirectType.linePay:
      case QRPayTPPRedirectType.unknown:
        throw ('該 QRPayTPPRedirectType 還沒開放');
    }
  }

  Future<void> _handleX50PayRedirectResult(CabPaymentResult? result) async {
    switch (result) {
      case CabPaymentCompleted():
        controller.start();
      case CabPaymentNeedsSelection(:final qrPayData):
        EasyLoading.dismiss();
        await showDialog(
          context: context,
          builder: (context) => CabSelect.fromQRPay(qrPayData: qrPayData),
        );
        controller.start();
      case null:
        EasyLoading.dismiss();
        controller.start();
    }
  }

  void showQRPayModal(MachineData machineData) async {
    // log('https://pay.x50.fun/api/v1/pay/$mid/$cid/0', name: 'showScanPayModal');
    await showModalBottomSheet<bool>(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      showDragHandle: true,
      enableDrag: true,
      transitionAnimationController: qrPayModalTransistionController,
      backgroundColor: scaffoldBackgroundColor,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          snap: true,
          snapSizes: const [0.5, 0.8],
          expand: false,
          builder: (context, controller) {
            return QRPayModal(scrollController: controller, machineData);
          },
        );
      },
    );

    controller.start();
  }

  void handleBarcode(Barcode barcode) async {
    final value = barcode.rawValue;
    log("barcode: $value format: ${barcode.format}", name: 'handleBarcode');
    log("format: ${barcode.format}", name: 'handleBarcode');
    if (value == null) return;

    if (isBusy) return;

    isBusy = true;
    final nav = GoRouter.of(context);
    isShowCameraPreviewNotifier.value = false;

    // QRPay
    if (value.startsWith('https://pay.x50.fun/mid/')) {
      await controller.stop();
      setState(() {});
      handleQRPay(value);
    } else {
      // 平板排隊
      final msg = await context.read<Repository>().qrDecryt(value);
      if (msg != 'oof') {
        setState(() {});
        await EasyLoading.showInfo(
          msg,
          duration: const Duration(milliseconds: 1000),
        );
        await Future.delayed(const Duration(milliseconds: 1300));
        nav.goNamed(AppRoutes.home.routeName);
      }
    }
    isBusy = false;
    isShowCameraPreviewNotifier.value = true;
    setState(() {});
  }

  Widget qrViewErrorBuilder(
    BuildContext context,
    MobileScannerException error,
  ) {
    log('', name: 'MobileScanner', error: error);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning_amber_rounded),
          const SizedBox(height: 8),
          const Text('發生錯誤，請重試'),
          Text(
            error.errorCode.name,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topUpButton = ElevatedButton(
      onPressed: onTopUpPressed,
      style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
      child: const Text('信用卡 / ATM 線上加值'),
    );

    final qrView = LayoutBuilder(
      builder: (context, constraints) {
        final scanWindow = Rect.fromCenter(
          center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
          width: constraints.maxWidth * 0.65,
          height: constraints.maxWidth * 0.65,
        );

        return Stack(
          children: [
            MobileScanner(
              controller: controller,
              fit: BoxFit.contain,
              scanWindow: scanWindow,
              errorBuilder: qrViewErrorBuilder,
              placeholderBuilder: (context) {
                return const SizedBox.expand();
              },
              onDetect: (barcodes) => handleBarcode(barcodes.barcodes.first),
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, controller, child) {
                if (!controller.isRunning) return const SizedBox();
                return CustomPaint(painter: ScannerOverlayPainter(scanWindow));
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, controller, child) {
                if (!controller.isRunning) return const SizedBox();
                return FadeTransition(
                  opacity: blinkAnimation,
                  child: CustomPaint(painter: ScannerBorderPainter(scanWindow)),
                );
              },
            ),
          ],
        );
      },
    );

    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: isShowCameraPreviewNotifier,
            builder: (context, isShowPreview, child) {
              return Flexible(
                flex: 9,
                child: isShowPreview ? qrView : const SizedBox.expand(),
              );
            },
          ),
          Flexible(flex: 1, child: Center(child: topUpButton)),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;

  ScannerOverlayPainter(this.scanWindow);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final rrCutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35);

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      rrCutoutPath,
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ScannerBorderPainter extends CustomPainter {
  final Rect scanWindow;

  ScannerBorderPainter(this.scanWindow);

  @override
  void paint(Canvas canvas, Size size) {
    const borderWidth = 5.5;
    const skipX = 0.2 * 0.5;
    const skipY = 0.2 * 0.5;
    final borderWindow = scanWindow.deflate(borderWidth / 2);
    final windowWidth = borderWindow.width;
    final windowHeight = borderWindow.height;

    final cornerBorderPath = Path()
      ..moveTo(borderWindow.topLeft.dx, borderWindow.topLeft.dy)
      ..relativeLineTo(windowWidth * skipX, 0)
      ..moveTo(borderWindow.topLeft.dx, borderWindow.topLeft.dy)
      ..relativeLineTo(0, windowHeight * skipY)
      ..moveTo(borderWindow.topRight.dx, borderWindow.topRight.dy)
      ..relativeLineTo(-(windowWidth * skipX), 0)
      ..moveTo(borderWindow.topRight.dx, borderWindow.topRight.dy)
      ..relativeLineTo(0, windowHeight * skipY)
      ..moveTo(borderWindow.bottomLeft.dx, borderWindow.bottomLeft.dy)
      ..relativeLineTo(windowWidth * skipX, 0)
      ..moveTo(borderWindow.bottomLeft.dx, borderWindow.bottomLeft.dy)
      ..relativeLineTo(0, -(windowHeight * skipY))
      ..moveTo(borderWindow.bottomRight.dx, borderWindow.bottomRight.dy)
      ..relativeLineTo(-(windowWidth * skipX), 0)
      ..moveTo(borderWindow.bottomRight.dx, borderWindow.bottomRight.dy)
      ..relativeLineTo(0, -(windowHeight * skipY))
      ..close();

    final cornerBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeMiterLimit = 10
      ..strokeWidth = borderWidth
      ..blendMode = BlendMode.srcOver;

    canvas.drawPath(cornerBorderPath, cornerBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
