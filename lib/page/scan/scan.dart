import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/repository/repository.dart';

class ScanQRCode extends StatefulWidget {
  final PermissionStatus permission;
  const ScanQRCode(this.permission, {Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? result, lastEvent;
  bool isBusy = false;
  bool isShowCameraPreview = true;

  void onRechargePressed() async {
    qrViewController?.pauseCamera();
    isShowCameraPreview = false;
    setState(() {});
    context.pushNamed(AppRoutes.ecPay.routeName).then((_) {
      isShowCameraPreview = true;
      qrViewController?.resumeCamera();
      setState(() {});
    });
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
            String msg = await Repository().qrDecryt(event.code!);
            if (msg != 'oof') {
              await controller.pauseCamera();
              await EasyLoading.showInfo(msg,
                  duration: const Duration(milliseconds: 1000));
              await Future.delayed(const Duration(milliseconds: 1300));
              nav.goNamed(AppRoutes.home.routeName);
            }
            result = event;
            setState(() {});
            isBusy = false;
          }
        });
      },
    );
  }

  Widget buildButton() {
    return ElevatedButton(
      onPressed: onRechargePressed,
      style: Themes.pale(),
      child: const Text('信用卡 / ATM 線上加值'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 9,
          child: isShowCameraPreview ? buildQrView() : const SizedBox.expand(),
        ),
        Flexible(
          flex: 1,
          child: Center(child: buildButton()),
        )
      ],
    );
  }
}
