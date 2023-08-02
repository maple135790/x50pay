import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
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

  Widget buildQrView() {
    return QRView(
      key: qrKey,
      // onPermissionSet: (controller, hasPermissions) {
      //   if (!hasPermissions) {
      //     Permission.camera.request();

      //   }
      // },
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
              await Future.delayed(const Duration(milliseconds: 1000));
              nav.goNamed(AppRoutes.home.routeName);
            }
            setState(() {
              result = event;
            });
            isBusy = false;
          }
        });
      },
    );
  }

  Widget buildButton() {
    return ElevatedButton(
      onPressed: () {},
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
          child: buildQrView(),
        ),
        Flexible(
          flex: 1,
          child: Center(child: buildButton()),
        )
      ],
    );
  }
}

class ScanQRCodeV2 extends StatefulWidget {
  const ScanQRCodeV2({Key? key}) : super(key: key);

  @override
  State<ScanQRCodeV2> createState() => _ScanQRCodeV2State();
}

class _ScanQRCodeV2State extends BaseStatefulState<ScanQRCodeV2> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? result, lastEvent;
  bool isBusy = false;

  @override
  void dispose() {
    qrViewController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrViewController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrViewController!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            color: const Color(0xfff7f7f7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('排隊/加值請掃描QRCode',
                    style: TextStyle(color: Color(0xff5a5a5a))),
                kDebugMode ? Text(result?.code ?? 'null') : const SizedBox(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(53, 28, 53, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xffd3d3d3), width: 1)),
                    width: 250,
                    height: 250,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: (controller) {
                        qrViewController = controller;
                        controller.scannedDataStream.listen((event) async {
                          if (isBusy) {
                            return;
                          } else {
                            isBusy = true;
                            final nav = GoRouter.of(context);
                            String msg =
                                await Repository().qrDecryt(event.code!);
                            if (msg != 'oof') {
                              await controller.pauseCamera();
                              await EasyLoading.showInfo(msg,
                                  duration: const Duration(milliseconds: 1000));
                              await Future.delayed(
                                  const Duration(milliseconds: 1000));
                              nav.goNamed(AppRoutes.home.routeName);
                            }
                            setState(() {
                              result = event;
                            });
                            isBusy = false;
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Divider(color: Color(0xffe9e9e9), thickness: 1),
          const SizedBox(height: 20),
          TextButton(
            style: Themes.confirm(),
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card),
                SizedBox(width: 10),
                Text('信用卡/ATM 線上加值')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
