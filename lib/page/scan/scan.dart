import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/scan/scan_pay_view_model.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

/// 掃描QRCode 頁面
class ScanQRCode extends StatefulWidget {
  final PermissionStatus permission;
  const ScanQRCode(this.permission, {Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> with TickerProviderStateMixin {
  late AnimationController animationController;
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
            await controller.pauseCamera();
            // ScanPay
            if (event.code!.startsWith('https://pay.x50.fun/mid/')) {
              String url = event.code!;
              List<String> args =
                  url.replaceAll('https://pay.x50.fun/mid/', '').split('/');
              showScanPayModal(controller, args[0], args[1]);
            } else {
              // 平板排隊
              String msg = await Repository().qrDecryt(event.code!);
              if (msg != 'oof') {
                await EasyLoading.showInfo(msg,
                    duration: const Duration(milliseconds: 1000));
                await Future.delayed(const Duration(milliseconds: 1300));
                nav.goNamed(AppRoutes.home.routeName);
              }
            }
            result = event;
            setState(() {});
            isBusy = false;
          }
        });
      },
    );
  }

  void debugScanPay() {
    qrViewController!.pauseCamera();
    showScanPayModal(
        qrViewController!, '632905b31eb45d31f0a1185d', '703765460');
  }

  Widget buildButton() {
    return ElevatedButton(
      onPressed: onRechargePressed,
      style: Themes.pale(),
      child: const Text('信用卡 / ATM 線上加值'),
    );
  }

  void showScanPayModal(QRViewController controller, String mid, String cid) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        showDragHandle: true,
        enableDrag: true,
        transitionAnimationController: animationController,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (context) => DraggableScrollableSheet(
              maxChildSize: 0.85,
              minChildSize: 0.25,
              initialChildSize: 0.48,
              snap: true,
              snapSizes: [0.25, 0.48, 0.85],
              expand: false,
              builder: (context, controller) {
                return ScanPayModal(
                    scrollController: controller, mid: mid, cid: cid);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: debugScanPay),
      body: Column(
        children: [
          Flexible(
            flex: 9,
            child:
                isShowCameraPreview ? buildQrView() : const SizedBox.expand(),
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

class ScanPayModal extends StatefulWidget {
  final ScrollController scrollController;
  final String mid;
  final String cid;
  const ScanPayModal({
    super.key,
    required this.scrollController,
    required this.mid,
    required this.cid,
  });

  @override
  State<ScanPayModal> createState() => _ScanPayModalState();
}

class _ScanPayModalState extends BaseStatefulState<ScanPayModal> {
  late Future<bool> init;
  late final viewModel = ScanPayViewModel(widget.mid, widget.cid);

  void onX50PayPressed() async {
    final pref = await SharedPreferences.getInstance();
    final session = pref.getString('session');
    if (session == null || session.isEmpty) {
      log('', name: 'onX50PayPressed', error: 'session is null');
      return;
    }
    log('session: $session', name: 'onX50PayPressed');
    log('url: ${viewModel.x50PayUrl}', name: 'onX50PayPressed');
    final doc = await Repository().getNFCPayDocument(viewModel.x50PayUrl);
    log(doc);
  }

  void onLinePayPressed() {
    launchUrlString(
      viewModel.linePayUrl,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  void onJKOPayPressed() {
    launchUrlString(
      viewModel.jkoPayUrl,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  }

  @override
  void initState() {
    super.initState();
    init = viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image(
                        image: R.image.login_banner_jpg(),
                        fit: BoxFit.fitWidth)),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.2, 1]),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 15,
                  left: 15,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('選擇付款方式',
                            style: TextStyle(shadows: [
                              Shadow(color: Colors.black, blurRadius: 25)
                            ], fontSize: 17, color: Color(0xe6ffffff))),
                        SizedBox(height: 5),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.schedule,
                                  size: 12, color: Colors.white),
                              Text(' 歡迎使用 X50MGS 多元付款平台',
                                  style: TextStyle(
                                      fontSize: 13, color: Color(0xe6ffffff)))
                            ]),
                      ]),
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: init,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (snapshot.data == false) {
                return Center(child: Text(serviceErrorText));
              }
              return Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xff3e3e3e))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: onX50PayPressed,
                      style: Themes.severe(isV4: true),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wallet_rounded),
                          Image(
                              image: R.svg.p_solid(width: 21, height: 15),
                              color: Colors.white),
                          const SizedBox(width: 7.5),
                          const Text('X50Pay'),
                        ],
                      ),
                    ),
                    const Divider(color: Color(0xff3e3e3e), height: 30),
                    TextButton(
                      onPressed: onJKOPayPressed,
                      style: Themes.pale(),
                      child: Center(
                          child:
                              Image(image: R.image.jkopay_logo(), height: 28)),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: viewModel.isLinePayAvailable
                          ? onLinePayPressed
                          : null,
                      style: Themes.pale(),
                      child: Center(
                        child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.black54, BlendMode.srcATop),
                            child: Image(
                                image: R.image.linepay_logo(), height: 20)),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
