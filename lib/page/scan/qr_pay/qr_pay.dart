import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_view_model.dart';
import 'package:x50pay/r.g.dart';

class QRPayModal extends StatefulWidget {
  final ScrollController scrollController;

  const QRPayModal({
    super.key,
    required this.scrollController,
  });

  @override
  State<QRPayModal> createState() => _QRPayModalState();
}

class _QRPayModalState extends BaseStatefulState<QRPayModal> {
  late Future<bool> checkLogined;
  late final QRPayViewModel viewModel = context.read<QRPayViewModel>();

  void onX50PayPressed() async {
    viewModel.handleX50PayPayment(
      onPaymentFinished: () {
        Navigator.of(context).pop();
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
            );
          },
        );
      },
    );
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
    checkLogined = viewModel.checkSessionValid();
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
                    child: CachedNetworkImage(
                  imageUrl: "https://pay.x50.fun/static/logo.jpg",
                  color: const Color.fromARGB(35, 0, 0, 0),
                  colorBlendMode: BlendMode.srcATop,
                  fit: BoxFit.fitWidth,
                  alignment: const Alignment(0, -0.25),
                )),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [Colors.black, Colors.transparent],
                        transform: GradientRotation(12),
                        stops: [0, 0.6],
                      ),
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
            future: checkLogined,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator.adaptive(),
                ));
              }
              if (snapshot.data == false) {
                return Center(child: Text(serviceErrorText));
              }
              if (!viewModel.hasLogined) {
                return const Center(child: Text('登入 Session 過期，請重新登入。'));
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
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
                              child: Image(
                                  image: R.image.jkopay_logo(), height: 28)),
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
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
