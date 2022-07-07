import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/common/widgets/body_card.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends BaseStatefulState<Home> with BaseLoaded {
  final viewModel = HomeViewModel()..isFunctionalHeader = false;
  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    return FutureBuilder<bool>(
      future: viewModel.initHome(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox(child: Text('loading'));
        return _HomeLoaded(viewModel.user!, viewModel);
      },
    );
  }
}

class _HomeLoaded extends StatefulWidget {
  final HomeViewModel viewModel;
  final UserModel user;

  const _HomeLoaded(this.user, this.viewModel, {Key? key}) : super(key: key);

  @override
  State<_HomeLoaded> createState() => _HomeLoadedState();
}

class _HomeLoadedState extends State<_HomeLoaded> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: ThemeData(
              textTheme: const TextTheme(
                  bodyText1: TextStyle(color: Colors.white),
                  bodyText2: TextStyle(color: Colors.white),
                  subtitle1: TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white)),
          child: Container(
            color: const Color(0xff333333),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    children: [
                      Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: widget.user.userimg != null
                                  ? DecorationImage(
                                      image: NetworkImage(widget.user.userimg!), fit: BoxFit.fill)
                                  : DecorationImage(image: R.image.logo_150_jpg(), fit: BoxFit.fill))),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            const Icon(Icons.person),
                            Text(widget.user.name!, style: const TextStyle(color: Colors.white, fontSize: 20))
                          ]),
                          const SizedBox(height: 5),
                          Row(children: [
                            const Icon(Icons.perm_contact_cal),
                            RichText(
                                text: TextSpan(text: 'ID : ${widget.user.uid!.padLeft(6, '0')}', children: [
                              widget.user.phoneactive!
                                  ? const TextSpan(text: ' (已驗證)')
                                  : TextSpan(
                                      text: ' (驗證手機)',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context).pushNamed(AppRoute.setting);
                                        })
                            ])),
                          ])
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(NoTransitionRouter(const ScanQRCode()));
                          },
                          child: const Icon(Icons.qr_code, size: 45, color: Color(0xff5a5a5a))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoute.buyMPass);
                          },
                          child: Column(
                            children: [
                              const Text('月票', style: TextStyle(color: Colors.white, fontSize: 13)),
                              widget.user.vip!
                                  ? const Text('已購買', style: TextStyle(color: Colors.white, fontSize: 20))
                                  : const Text('購買', style: TextStyle(color: Colors.blue, fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              const Text('餘點', style: TextStyle(color: Colors.white, fontSize: 13)),
                              Text(widget.user.point!.toInt().toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      height: 1.3,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              const Text('遊玩券', style: TextStyle(color: Colors.white, fontSize: 13)),
                              Text(widget.user.ticketint!.toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      height: 1.3,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: checkRemoteOpen,
                          style: Themes.confirm(),
                          child: const Text('西門店夜間開門'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        BodyCard(
            paddingOffset: 15,
            child: Column(children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(image: R.image.ouo$1(), height: 190, width: 150),
                  const SizedBox(width: 10),
                  Expanded(child: _Level(widget.viewModel)),
                ],
              ),
              const SizedBox(height: 30),
              _Info(widget.viewModel)
            ])),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: GestureDetector(
                onTap: () {
                  launchUrlString('https://www.youtube.com/channel/UCEbHRn4kPMzODDgsMwGhYVQ',
                      mode: LaunchMode.externalNonBrowserApplication);
                },
                child: Image(image: R.image.vts()))),
        Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: GestureDetector(
                onTap: () {
                  launchUrlString('https://www.youtube.com/c/X50MusicGameStation-onAir',
                      mode: LaunchMode.externalNonBrowserApplication);
                },
                child: Image(image: R.image.top()))),
        const SizedBox(height: 25),
      ],
    );
  }

  void checkRemoteOpen() async {
    final location = Location();
    double deg2rad(double deg) => deg * (pi / 180);

    double getDistance(double lat1, double lon1, double lat2, double lon2) {
      var R = 6371; // Radius of the earth in km
      var dLat = deg2rad(lat2 - lat1); // deg2rad below
      var dLon = deg2rad(lon2 - lon1);
      var a = sin(dLat / 2) * sin(dLat / 2) +
          cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
      var c = 2 * atan2(sqrt(a), sqrt(1 - a));
      var d = R * c; // Distance in km
      return d;
    }

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    double myLat = locationData.latitude!;
    double myLng = locationData.longitude!;
    String result = await Repository().remoteOpenDoor(getDistance(25.0455991, 121.5027702, myLat, myLng));
    await EasyLoading.showInfo(result.replaceFirst(',', '\n'));
  }
}

class _Level extends StatelessWidget {
  final HomeViewModel vm;
  const _Level(this.vm, {Key? key}) : super(key: key);

  int getPercent(List grade) {
    return ((int.parse(grade[1]) + int.parse(grade[2])) / int.parse(grade[2]) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    EntryModel entry = vm.entry!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: 'Lv. ',
              style: const TextStyle(color: Color(0xff404040), fontSize: 16),
              children: [
                TextSpan(
                    text: entry.grade![2] > 999998 ? '-' : entry.grade!.first,
                    style: const TextStyle(color: Color(0xff808080), fontSize: 30))
              ]),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
            padding: EdgeInsets.zero,
            center: Text(entry.grade![2] > 999998 ? '少女祈禱中...' : getPercent(entry.grade!).toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12)),
            barRadius: const Radius.circular(12),
            percent: entry.grade![2] > 999998 ? 1.0 : getPercent(entry.grade!) / 100,
            backgroundColor: const Color(0xffe9e9e9),
            progressColor: const Color(0xffd2691e),
            lineHeight: 25),
        const SizedBox(height: 10),
        Text(
            entry.grade![2] > 999998
                ? '賽季已結束，請關注粉專取得最新消息'
                : '再${entry.grade![1]}道即可升級至 Lv.${entry.grade![0] + 1}\n (將於 ${entry.grade![3]} 重置)',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xff404040), fontSize: 11)),
        OutlinedButton(
            onPressed: () {},
            style: Themes.outlinedRed(),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('查看獎勵列表', style: TextStyle(fontSize: 11))])),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final HomeViewModel vm;
  const _Info(this.vm, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EntryModel entry = vm.entry!;
    if (entry.evlist!.isEmpty) return const SizedBox();
    List<Widget> events = [];
    for (Evlist evt in entry.evlist!) {
      events.add(Text('> ${evt.name} : ${evt.describe}',
          style: const TextStyle(color: Color(0xffb59120), fontSize: 14)));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1),
        const SizedBox(height: 10),
        const Text('訊息告知', style: TextStyle(color: Color(0xff8a6e18), fontSize: 16)),
        const SizedBox(height: 10),
        ...events
      ],
    );
  }
}
