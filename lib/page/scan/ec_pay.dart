import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EcPay extends StatefulWidget {
  const EcPay({super.key});

  @override
  State<EcPay> createState() => _EcPayState();
}

class _EcPayState extends State<EcPay> {
  Widget paymentTile({required String point, required String price}) {
    return GestureDetector(
      onTap: () {
        launchUrlString(
          'https://pay.x50.fun/ecpay/gen/$price',
          mode: LaunchMode.externalApplication,
        );
      },
      child: Container(
        height: 94,
        width: double.maxFinite,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 35),
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color(0xff505050),
              strokeAlign: BorderSide.strokeAlignOutside),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            const Positioned(
              height: 90,
              bottom: 0,
              right: -45,
              child: Icon(
                Icons.payment_rounded,
                size: 140,
                color: Colors.white10,
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$point P",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.w500)),
                    Text('$price NTD  (可信用卡 / ATM付款)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Text('信用卡 / ATM 線上加值', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 15),
        paymentTile(point: "291", price: "300"),
        paymentTile(point: "485", price: "500"),
        paymentTile(point: "970", price: "1000"),
        const Text('1. 如付款成功無加值成功請聯絡粉絲專頁\n2. 付款由 ECPay 金流進行',
            textAlign: TextAlign.left)
      ],
    );
  }
}
