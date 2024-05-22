import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_view_model.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';

/// 掃描QRCode 頁面
class ScanQRCode extends StatefulWidget {
  final PermissionStatus permission;
  const ScanQRCode(this.permission, {super.key});

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends BaseStatefulState<ScanQRCode>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final controller = MobileScannerController(
      // required options for the scanner
      );

  late AnimationController animationController;
  final isShowCameraPreviewNotifier = ValueNotifier(true);
  bool isBusy = false;

  void onTopUpPressed() async {
    controller.stop();
    isShowCameraPreviewNotifier.value = false;
    setState(() {});
    context.pushNamed(AppRoutes.ecPay.routeName).then((_) {
      isShowCameraPreviewNotifier.value = true;
      controller.start();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 300),
    );
    animationController.drive(CurveTween(curve: Curves.fastLinearToSlowEaseIn));
    controller.start();
  }

  @override
  void dispose() {
    GlobalSingleton.instance.isInCameraPage = false;
    animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  void handleQRPay(String url, MobileScannerController controller) async {
    EasyLoading.show(status: '檢查');
    final args = url.replaceAll('https://pay.x50.fun/mid/', '').split('/');
    final repo = Repository();

    final viewModel = QRPayViewModel(
      mid: args[0],
      cid: args[1],
      repository: repo,
      settingRepo: SettingRepository(),
      onPaymentDone: () {
        controller.start();
      },
      onCabSelect: (qrPayData) {
        showDialog(
          context: context,
          builder: (context) {
            return CabSelect.fromQRPay(
              qrPayData: qrPayData,
              onCreated: () {
                EasyLoading.dismiss();
              },
              onDestroy: () {
                controller.start();
              },
            );
          },
        );
      },
    );
    final redirection = await viewModel.checkThirdPartyPaymentRedirect();

    switch (redirection.type) {
      case QRPayTPPRedirectType.x50Pay:
        break;
      case QRPayTPPRedirectType.none:
        EasyLoading.dismiss();
        showQRPayModal(controller, viewModel);
        break;
      case QRPayTPPRedirectType.jkoPay:
        launchUrlString(
          redirection.url,
          mode: LaunchMode.externalApplication,
        );
        controller.start();
        EasyLoading.dismiss();
        break;
      case QRPayTPPRedirectType.linePay:
      case QRPayTPPRedirectType.unknown:
        throw ('該 QRPayTPPRedirectType 還沒開放');
    }
  }

  void debugQRPay() {
    controller.stop();

    handleQRPay(
      'https://pay.x50.fun/mid/5fcdcf800004a524c8fae000/703765460',
      controller,
    );
  }

  void showQRPayModal(
    MobileScannerController controller,
    QRPayViewModel viewModel,
  ) async {
    // log('https://pay.x50.fun/api/v1/pay/$mid/$cid/0', name: 'showScanPayModal');
    await showModalBottomSheet<bool>(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      showDragHandle: true,
      enableDrag: true,
      transitionAnimationController: animationController,
      backgroundColor: scaffoldBackgroundColor,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          snap: true,
          snapSizes: const [0.5, 0.8],
          expand: false,
          builder: (context, controller) {
            return ChangeNotifierProvider.value(
              value: viewModel,
              builder: (context, child) {
                return QRPayModal(scrollController: controller);
              },
            );
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

    if (isBusy) {
      return;
    } else {
      isBusy = true;
      final nav = GoRouter.of(context);
      isShowCameraPreviewNotifier.value = false;

      // QRPay
      if (value.startsWith('https://pay.x50.fun/mid/')) {
        await controller.stop();
        setState(() {});
        handleQRPay(value, controller);
      } else {
        // 平板排隊
        final msg = await Repository().qrDecryt(value);
        if (msg != 'oof') {
          setState(() {});
          await EasyLoading.showInfo(msg,
              duration: const Duration(milliseconds: 1000));
          await Future.delayed(const Duration(milliseconds: 1300));
          nav.goNamed(AppRoutes.home.routeName);
        }
      }
      isBusy = false;
      isShowCameraPreviewNotifier.value = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final topUpButton = ElevatedButton(
      onPressed: onTopUpPressed,
      style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
      child: const Text('信用卡 / ATM 線上加值'),
    );

    final qrView = MobileScanner(
      controller: controller,
      fit: BoxFit.contain,
      onDetect: (barcodes) => handleBarcode(barcodes.barcodes.first),
    );

    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: isShowCameraPreviewNotifier,
            builder: (context, isShowPreview, child) => Flexible(
              flex: 9,
              child: isShowPreview ? qrView : const SizedBox.expand(),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(child: topUpButton),
          )
        ],
      ),
    );
  }
}
