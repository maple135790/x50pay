part of "../../common/base/base_loaded.dart";

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({Key? key}) : super(key: key);

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends BaseStatefulState<ScanQRCode> with BaseLoaded {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewController;
  Barcode? result, lastEvent;
  bool isBusy = false;

  @override
  Color? get customBackgroundColor => Colors.white;

  @override
  BaseViewModel? baseViewModel() => BaseViewModel();

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
  Widget body() {
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
                const Text('排隊/加值請掃描QRCode', style: TextStyle(color: Color(0xff5a5a5a))),
                kDebugMode ? Text(result?.code ?? 'null') : const SizedBox(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(53, 28, 53, 0),
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffd3d3d3), width: 1)),
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
                            final nav = Navigator.of(context);
                            String msg = await Repository().qrDecryt(event.code!);
                            if (msg != 'oof') {
                              await controller.pauseCamera();
                              await EasyLoading.showInfo(msg, duration: const Duration(milliseconds: 1000));
                              await Future.delayed(const Duration(milliseconds: 1000));
                              nav.popUntil(ModalRoute.withName(AppRoute.home));
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.credit_card), SizedBox(width: 10), Text('信用卡/ATM 線上加值')],
            ),
          ),
        ],
      ),
    );
  }
}
