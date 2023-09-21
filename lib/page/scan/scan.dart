import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_view_model.dart';
import 'package:x50pay/repository/repository.dart';

/// 掃描QRCode 頁面
class ScanQRCode extends StatefulWidget {
  final PermissionStatus permission;
  const ScanQRCode(this.permission, {Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends BaseStatefulState<ScanQRCode>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final isShowCameraPreviewNotifier = ValueNotifier(true);
  QRViewController? qrViewController;
  Barcode? result, lastEvent;
  bool isBusy = false;

  void onRechargePressed() async {
    qrViewController?.pauseCamera();
    isShowCameraPreviewNotifier.value = false;
    setState(() {});
    context.pushNamed(AppRoutes.ecPay.routeName).then((_) {
      isShowCameraPreviewNotifier.value = true;
      qrViewController?.resumeCamera();
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
  }

  @override
  void dispose() {
    GlobalSingleton.instance.isInCameraPage = false;
    qrViewController?.dispose();
    animationController.dispose();
    super.dispose();
  }

  void handleQRPay(String url, QRViewController controller) async {
    EasyLoading.show(status: '檢查');
    final args = url.replaceAll('https://pay.x50.fun/mid/', '').split('/');

    final viewModel = QRPayViewModel(
      mid: args[0],
      cid: args[1],
      onPaymentDone: () {
        controller.resumeCamera();
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
                controller.resumeCamera();
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
        controller.resumeCamera();
        EasyLoading.dismiss();
        break;
      case QRPayTPPRedirectType.linePay:
      case QRPayTPPRedirectType.unknown:
        throw ('該 QRPayTPPRedirectType 還沒開放');
    }
  }

  Widget buildQrView() {
    return QRView(
      key: qrKey,
      overlay: QrScannerOverlayShape(
        overlayColor: Colors.black54,
        borderColor: Colors.white,
        borderWidth: 12,
      ),
      onQRViewCreated: (controller) {
        qrViewController = controller;

        controller.scannedDataStream.listen((event) async {
          log("event: ${event.code}\nformat: ${event.format}");
          if (isBusy) {
            return;
          } else {
            isBusy = true;
            final nav = GoRouter.of(context);
            isShowCameraPreviewNotifier.value = false;

            // QRPay
            if (event.code!.startsWith('https://pay.x50.fun/mid/')) {
              await controller.pauseCamera();
              setState(() {});
              handleQRPay(event.code!, controller);
            } else {
              // 平板排隊
              String msg = await Repository().qrDecryt(event.code!);
              if (msg != 'oof') {
                setState(() {});
                await EasyLoading.showInfo(msg,
                    duration: const Duration(milliseconds: 1000));
                await Future.delayed(const Duration(milliseconds: 1300));
                nav.goNamed(AppRoutes.home.routeName);
              }
            }
            result = event;
            setState(() {});
            isBusy = false;
            isShowCameraPreviewNotifier.value = true;
          }
        });
      },
    );
  }

  void debugQRPay() {
    qrViewController!.pauseCamera();

    handleQRPay(
      'https://pay.x50.fun/mid/5fcdcf800004a524c8fae000/703765460',
      qrViewController!,
    );
  }

  Widget buildButton() {
    return ElevatedButton(
      onPressed: onRechargePressed,
      style: Themes.pale(),
      child: const Text('信用卡 / ATM 線上加值'),
    );
  }

  void showQRPayModal(
    QRViewController controller,
    QRPayViewModel viewModel,
  ) {
    // log('https://pay.x50.fun/api/v1/pay/$mid/$cid/0', name: 'showScanPayModal');
    showModalBottomSheet<bool>(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        showDragHandle: true,
        enableDrag: true,
        transitionAnimationController: animationController,
        backgroundColor: scaffoldBackgroundColor,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.8,
              snap: true,
              snapSizes: const [0.5, 0.8],
              expand: false,
              builder: (context, controller) {
                return ChangeNotifierProvider.value(
                  value: viewModel,
                  builder: (context, child) => QRPayModal(
                    scrollController: controller,
                  ),
                );
              },
            )).then((_) {
      controller.resumeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: debugQRPay),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: isShowCameraPreviewNotifier,
            builder: (context, isShowPreview, child) => Flexible(
              flex: 9,
              child: isShowPreview ? buildQrView() : const SizedBox.expand(),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(child: buildButton()),
          )
        ],
      ),
    );
  }
}
