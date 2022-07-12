import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/buyMPass/buy_mpass.dart';
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
  String _vipExpDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(widget.user.vipdate!.date);
    return '${date.month}/${date.day} ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final entry = widget.viewModel.entry!;
    final gradeLv = entry.gr2[0].toString();
    final gr2HowMuch = entry.gr2[1].toInt().toString();
    final gr2Limit = entry.gr2[2].toInt().toString();
    final gr2Next = entry.gr2[3].toString();
    final gr2Day = entry.gr2[4].toString();
    final gr2Date = entry.gr2[5].toString();
    final gr2VDay = entry.gr2[9].toInt().toString();
    final gr2Progress = entry.gr2[0] / 10;
    final ava = entry.gr2[7].toString().split(',').last;

    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: user.userimg != null
                          ? DecorationImage(image: NetworkImage(user.userimg!), fit: BoxFit.fill)
                          : DecorationImage(image: R.image.logo_150_jpg(), fit: BoxFit.fill))),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              const WidgetSpan(child: Icon(Icons.person, color: Color(0xfffafafa), size: 20)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(text: user.name!)
                            ])),
                            const SizedBox(height: 5),
                            RichText(
                                text: TextSpan(children: [
                              const WidgetSpan(
                                  child: Icon(Icons.perm_contact_cal, color: Color(0xfffafafa), size: 20)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(text: user.uid!)
                            ])),
                            const SizedBox(height: 5),
                            RichText(
                                text: TextSpan(children: [
                              const WidgetSpan(
                                  child: Icon(Icons.currency_yen, color: Color(0xfffafafa), size: 20)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(text: user.point!.toInt().toString())
                            ])),
                          ],
                        ),
                        const Spacer(),
                        const VerticalDivider(thickness: 1),
                        IconButton(
                            onPressed: () async {
                              // Navigator.of(context).push(NoTransitionRouter(const ScanQRCodeV2()));
                              await showDialog(context: context, builder: (context) => const ScanQRCode());
                            },
                            icon: const Icon(Icons.qr_code, color: Color(0xfffafafa), size: 45))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Stack(children: [
            const Positioned(
                bottom: -35, right: -20, child: Icon(Icons.east, size: 120, color: Color(0xff343434))),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(NoTransitionRouter(const BuyMPass()));
                        },
                        child: const Icon(Icons.confirmation_number, color: Color(0xff237804), size: 50)),
                    const SizedBox(width: 10),
                    const VerticalDivider(thickness: 1),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(text: '券量 : '),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          TextSpan(text: user.ticketint!.toString()),
                          const TextSpan(text: '張'),
                        ])),
                        const SizedBox(height: 5),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '月票 : ', style: TextStyle(color: user.vip! == false ? Colors.red : null)),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          TextSpan(text: user.vip! ? '已購買' : '未購買')
                        ])),
                        const SizedBox(height: 5),
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(text: '期限 : '),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          TextSpan(text: user.vip! ? _vipExpDate() : '點左側票卷圖樣立刻購買')
                        ])),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Stack(children: [
            const Positioned(
                bottom: -25, right: -40, child: Icon(Icons.compost, size: 140, color: Color(0xff343434))),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.memory(base64Decode(ava),
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      height: 270,
                      cacheHeight: 270),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          const Icon(Icons.favorite, color: Color(0xffc71508)),
                          const SizedBox(width: 5),
                          Text(gradeLv.toString(),
                              style: const TextStyle(color: Color(0xff808080), fontSize: 30)),
                          const SizedBox(width: 5),
                          Container(
                              // padding: const Edge,
                              decoration: BoxDecoration(
                                  color: const Color(0xff2f2f2f), borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(Icons.bolt, color: Color(0xfffafafa), size: 20),
                                    Text('3'),
                                    SizedBox(width: 3)
                                  ]))
                        ]),
                        const SizedBox(height: 5),
                        // ProgressBar
                        FAProgressBar(
                          backgroundColor: const Color(0xff949494),
                          borderRadius: BorderRadius.circular(15),
                          currentValue: gr2Progress <= 20 ? 20 : gr2Progress,
                          size: 25,
                          progressColor: const Color(0xffff9bad),
                          displayTextStyle: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w900, fontFamily: R.fontFamily.notoSansJP),
                          formatValue: (str, t) => '',
                          displayText: ' ♡  ',
                        ),
                        const SizedBox(height: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                  const WidgetSpan(
                                      child: Icon(Icons.redeem, color: Color(0xfffafafa), size: 15)),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  const TextSpan(text: ' 每 '),
                                  TextSpan(text: gr2HowMuch),
                                  const TextSpan(text: ' 道贈 1 張，上限 '),
                                  TextSpan(text: gr2Limit),
                                  const TextSpan(text: ' 張 '),
                                ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                  const WidgetSpan(
                                      child: Icon(Icons.favorite, color: Color(0xfffafafa), size: 15)),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  const TextSpan(text: ' 下一階段: '),
                                  TextSpan(text: gr2Next),
                                  const TextSpan(text: ' 親密度 '),
                                ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                  const WidgetSpan(
                                      child: Icon(Icons.calendar_today, color: Color(0xfffafafa), size: 15)),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  const TextSpan(text: ' 連續登入: '),
                                  TextSpan(text: gr2Day),
                                  const TextSpan(text: ' 天 '),
                                ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                  const WidgetSpan(
                                      child: Icon(Icons.how_to_vote, color: Color(0xfffafafa), size: 15)),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  const TextSpan(text: ' 領抽獎券: '),
                                  const TextSpan(text: ' 再 '),
                                  TextSpan(text: gr2VDay),
                                  const TextSpan(text: ' 親密度 '),
                                ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                  const WidgetSpan(
                                      child: Icon(Icons.sync, color: Color(0xfffafafa), size: 15)),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  const TextSpan(text: ' 重置日期: '),
                                  TextSpan(text: gr2Date),
                                ])),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                    padding:
                                        MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20)),
                                    textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13)),
                                    visualDensity: VisualDensity.comfortable,
                                    splashFactory: NoSplash.splashFactory,
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                    foregroundColor: MaterialStateProperty.all(const Color(0xfff5222d)),
                                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                                      return const Color(0x22f7f7f7);
                                    }),
                                  ),
                                  child: const Text('養成點數商城'),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
        // v2 theme
        // Theme(
        //   data: ThemeData(
        //       textTheme: const TextTheme(
        //           bodyText1: TextStyle(color: Colors.white),
        //           bodyText2: TextStyle(color: Colors.white),
        //           subtitle1: TextStyle(color: Colors.white)),
        //       iconTheme: const IconThemeData(color: Colors.white)),
        //   child: Container(
        //     color: const Color(0xff333333),
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(30),
        //           child: Row(
        //             children: [
        //               Container(
        //                   width: 88,
        //                   height: 88,
        //                   decoration: BoxDecoration(
        //                       shape: BoxShape.circle,
        //                       image: widget.user.userimg != null
        //                           ? DecorationImage(
        //                               image: NetworkImage(widget.user.userimg!), fit: BoxFit.fill)
        //                           : DecorationImage(image: R.image.logo_150_jpg(), fit: BoxFit.fill))),
        //               const SizedBox(width: 10),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        //                     const Icon(Icons.person),
        //                     Text(widget.user.name!, style: const TextStyle(color: Colors.white, fontSize: 20))
        //                   ]),
        //                   const SizedBox(height: 5),
        //                   Row(children: [
        //                     const Icon(Icons.perm_contact_cal),
        //                     RichText(
        //                         text: TextSpan(text: 'ID : ${widget.user.uid!.padLeft(6, '0')}', children: [
        //                       widget.user.phoneactive!
        //                           ? const TextSpan(text: ' (已驗證)')
        //                           : TextSpan(
        //                               text: ' (驗證手機)',
        //                               recognizer: TapGestureRecognizer()
        //                                 ..onTap = () {
        //                                   Navigator.of(context).pushNamed(AppRoute.setting);
        //                                 })
        //                     ])),
        //                   ])
        //                 ],
        //               ),
        //               const Spacer(),
        //               GestureDetector(
        //                   onTap: () {
        //                     Navigator.of(context).push(NoTransitionRouter(const ScanQRCode()));
        //                   },
        //                   child: const Icon(Icons.qr_code, size: 45, color: Color(0xff5a5a5a))),
        //             ],
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 15),
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 flex: 3,
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     Navigator.of(context).pushNamed(AppRoute.buyMPass);
        //                   },
        //                   child: Column(
        //                     children: [
        //                       const Text('月票', style: TextStyle(color: Colors.white, fontSize: 13)),
        //                       widget.user.vip!
        //                           ? const Text('已購買', style: TextStyle(color: Colors.white, fontSize: 20))
        //                           : const Text('購買', style: TextStyle(color: Colors.blue, fontSize: 20)),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               Expanded(
        //                 flex: 4,
        //                 child: GestureDetector(
        //                   onTap: () {},
        //                   child: Column(
        //                     children: [
        //                       const Text('餘點', style: TextStyle(color: Colors.white, fontSize: 13)),
        //                       Text(widget.user.point!.toInt().toString(),
        //                           style: const TextStyle(
        //                               color: Colors.white,
        //                               fontSize: 24,
        //                               height: 1.3,
        //                               fontWeight: FontWeight.w600)),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               Expanded(
        //                 flex: 3,
        //                 child: GestureDetector(
        //                   onTap: () {},
        //                   child: Column(
        //                     children: [
        //                       const Text('遊玩券', style: TextStyle(color: Colors.white, fontSize: 13)),
        //                       Text(widget.user.ticketint!.toString(),
        //                           style: const TextStyle(
        //                               color: Colors.white,
        //                               fontSize: 24,
        //                               height: 1.3,
        //                               fontWeight: FontWeight.w600)),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(15),
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 child: TextButton(
        //                   onPressed: checkRemoteOpen,
        //                   style: Themes.confirm(),
        //                   child: const Text('西門店夜間開門'),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // BodyCard(
        //     paddingOffset: 15,
        //     child: Column(children: [
        //       Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Image(image: R.image.ouo$1(), height: 190, width: 150),
        //           const SizedBox(width: 10),
        //           Expanded(child: _Level(widget.viewModel)),
        //         ],
        //       ),
        //       const SizedBox(height: 30),
        //       _Info(widget.viewModel)
        //     ])),
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
                    text: '87',
                    // text: entry.grade![2] > 999998 ? '-' : entry.grade!.first,
                    style: const TextStyle(color: Color(0xff808080), fontSize: 30))
              ]),
        ),
        const SizedBox(height: 5),
        LinearPercentIndicator(
            padding: EdgeInsets.zero,
            center: Text('少女祈禱中...', style: const TextStyle(color: Colors.white, fontSize: 12)),
            barRadius: const Radius.circular(12),
            percent: 1,
            backgroundColor: const Color(0xffe9e9e9),
            progressColor: const Color(0xffd2691e),
            lineHeight: 25),
        const SizedBox(height: 10),
        Text('賽季已結束，請關注粉專取得最新消息',
            textAlign: TextAlign.center, style: const TextStyle(color: Color(0xff404040), fontSize: 11)),
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
