import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/buyMPass/buy_mpass.dart';
import 'package:x50pay/page/home/dress_room/dress_room_popup.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/page/home/progress_bar.dart';
import 'package:x50pay/r.g.dart';

part "grade_box_popup.dart";

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
      key: ValueKey(viewModel.entry),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
        if (snapshot.data == false) {
          EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
          return const SizedBox(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
        } else {
          return _HomeLoaded(GlobalSingleton.instance.user!, viewModel);
        }
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
  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      child: Row(
        children: [
          Expanded(child: Divider(color: Color(0xff3e3e3e))),
          Text(' 官方資訊 '),
          Expanded(child: Divider(color: Color(0xff3e3e3e))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await confirmPopup();
        return shouldPop!;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          _TopInfo(user: user),
          _TicketInfo(user: user),
          _MariInfo(isVip: user.vip!, viewModel: widget.viewModel),
          divider(),
          _EventInfo(widget.viewModel.entry!.evlist),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: GestureDetector(
                  onTap: () {
                    launchUrlString('https://www.youtube.com/channel/UCEbHRn4kPMzODDgsMwGhYVQ',
                        mode: LaunchMode.externalNonBrowserApplication);
                  },
                  child:
                      ClipRRect(borderRadius: BorderRadius.circular(5), child: Image(image: R.image.vts())))),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: GestureDetector(
                  onTap: () {
                    launchUrlString('https://www.youtube.com/c/X50MusicGameStation-onAir',
                        mode: LaunchMode.externalNonBrowserApplication);
                  },
                  child:
                      ClipRRect(borderRadius: BorderRadius.circular(5), child: Image(image: R.image.top())))),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Future<bool?> confirmPopup() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('確認離開 ?', style: TextStyle(color: Color(0xfffafafa))),
          actions: [
            TextButton(
              style: Themes.severe(isV4: true),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('是'),
            ),
            TextButton(
              style: Themes.pale(),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('否'),
            ),
          ],
        );
      },
    );
  }
}

class _TicketInfo extends StatelessWidget {
  final UserModel user;

  const _TicketInfo({Key? key, required this.user}) : super(key: key);

  String vipExpDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(user.vipdate!.date);
    return '${date.month}/${date.day} ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
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
                      Navigator.of(context).pushNamed(AppRoute.buyMPass);
                      // Navigator.of(context).push(
                      //     NoTransitionRouter(const BuyMPass(), s: const RouteSettings(name: AppRoute.home)));
                    },
                    child: const Icon(Icons.confirmation_number, color: Color(0xff237804), size: 50)),
                const SizedBox(width: 16),
                const VerticalDivider(thickness: 0, width: 0, color: Color(0xff3e3e3e)),
                const SizedBox(width: 15),
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
                      const TextSpan(text: '月票 : '),
                      const WidgetSpan(child: SizedBox(width: 5)),
                      TextSpan(
                          text: user.vip! ? '已購買' : '未購買',
                          style: TextStyle(color: user.vip! == false ? Colors.red : null))
                    ])),
                    const SizedBox(height: 5),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(text: '期限 : '),
                      const WidgetSpan(child: SizedBox(width: 5)),
                      TextSpan(text: user.vip! ? vipExpDate() : '點左側票卷圖樣立刻購買')
                    ])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _MariInfo extends StatefulWidget {
  final HomeViewModel viewModel;
  final bool isVip;
  const _MariInfo({Key? key, required this.viewModel, required this.isVip}) : super(key: key);

  @override
  State<_MariInfo> createState() => _MariInfoState();
}

class _MariInfoState extends State<_MariInfo> {
  void dressRoomPopup() {
    showDialog(
      context: context,
      builder: (context) => const DressRoomPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.viewModel.entry!;
    final gradeLv = entry.gr2[0].toString();
    final gr2HowMuch = entry.gr2[1].toInt().toString();
    final gr2Limit = entry.gr2[2].toInt().toString();
    final gr2Next = entry.gr2[3].toString();
    final gr2Day = entry.gr2[4].toString();
    final gr2Date = entry.gr2[5].toString();
    final gr2GradeBoxContent = entry.gr2[6].toString();
    final ava = entry.gr2[7].toString().split(',').last;
    final gr2VDay = entry.gr2[9].toString();
    final gr2Progress = entry.gr2[0] / 15;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Stack(children: [
        const Positioned(
            bottom: -25, right: -40, child: Icon(Icons.compost, size: 140, color: Color(0xff343434))),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 141.6,
                child: Image.memory(base64Decode(ava),
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,
                    filterQuality: FilterQuality.high,
                    gaplessPlayback: true,
                    height: 270,
                    cacheHeight: 270),
              ),
              Column(
                verticalDirection: VerticalDirection.up,
                children: [
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: IconButton(
                      iconSize: 16.5,
                      onPressed: dressRoomPopup,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.checkroom),
                      color: const Color(0xffffc0cb),
                      style: const ButtonStyle(
                        side: MaterialStatePropertyAll(BorderSide(color: Color(0xff3e3e3e))),
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      Image(image: R.image.heart_solid(), color: const Color(0xbfff1100)),
                      const SizedBox(width: 5),
                      Text(gradeLv.toString(),
                          style: const TextStyle(color: Color(0xff808080), fontSize: 30)),
                      const SizedBox(width: 5),
                      Tooltip(
                        preferBelow: false,
                        decoration: BoxDecoration(
                            color: const Color(0x33fefefe), borderRadius: BorderRadius.circular(8)),
                        message: widget.isVip ? '月票：當日前12道加成' : '當日前10道加成',
                        child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff2f2f2f), borderRadius: BorderRadius.circular(5)),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child:
                                        Image(image: R.image.bolt_solid(), height: 10, color: Colors.white),
                                  ),
                                  const Text('3'),
                                  const SizedBox(width: 3)
                                ])),
                      )
                    ]),
                    const SizedBox(height: 5),
                    ProgressBar(currentValue: gr2Progress <= 20 ? 20 : gr2Progress),
                    const SizedBox(height: 12),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                            child: RichText(
                                text: TextSpan(style: const TextStyle(fontSize: 11.5), children: [
                              const WidgetSpan(child: Icon(Icons.redeem, color: Color(0xfffafafa), size: 15)),
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
                                text: TextSpan(style: const TextStyle(fontSize: 11.5), children: [
                              const WidgetSpan(
                                  child: Icon(Icons.favorite, color: Color(0xfffafafa), size: 15)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              const TextSpan(text: ' 下一階: '),
                              TextSpan(text: gr2Next),
                              const TextSpan(text: ' 親密度 '),
                            ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                            child: RichText(
                                text: TextSpan(style: const TextStyle(fontSize: 11.5), children: [
                              const WidgetSpan(
                                  child: Icon(Icons.calendar_today, color: Color(0xfffafafa), size: 15)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              const TextSpan(text: ' 已簽到: '),
                              TextSpan(text: gr2Day),
                              const TextSpan(text: ' 天 '),
                            ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                            child: RichText(
                                text: TextSpan(style: const TextStyle(fontSize: 11.5), children: [
                              const WidgetSpan(
                                  child: Icon(Icons.how_to_vote, color: Color(0xfffafafa), size: 15)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              const TextSpan(text: ' 抽獎券: '),
                              const TextSpan(text: ' 再 '),
                              TextSpan(text: gr2VDay),
                              const TextSpan(text: ' 點 '),
                            ])),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.5),
                            child: RichText(
                                text: TextSpan(style: const TextStyle(fontSize: 11.5), children: [
                              const WidgetSpan(child: Icon(Icons.sync, color: Color(0xfffafafa), size: 15)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              const TextSpan(text: ' 換季日: '),
                              TextSpan(text: gr2Date),
                            ])),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => _GradeBoxPopup(
                                        gradeBox: gr2GradeBoxContent,
                                        onChangeGrade: widget.viewModel.chgGradev2));
                              },
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
    );
  }
}

class _EventInfo extends StatelessWidget {
  final List<Evlist>? evlist;
  const _EventInfo(this.evlist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (evlist == null) return const SizedBox();
    if (evlist!.isEmpty) return const SizedBox();
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Themes.borderColor, width: 1),
              borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle),
        ),
        Positioned(
            left: 35,
            top: 12,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: const Text('優惠時段', style: TextStyle(color: Color(0xfffafafa), fontSize: 13)),
            )),
        const Positioned(
          top: 40,
          left: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('●   WACCA / GC / 女武神 / pop\'n 無提供優惠方案', style: TextStyle(color: Color(0xfffafafa))),
              SizedBox(height: 5),
              Text('●   月票： 全日延長至 19:00 優惠時段', style: TextStyle(color: Color(0xfffafafa))),
            ],
          ),
        )
      ],
    );
  }
}

class _TopInfo extends StatelessWidget {
  const _TopInfo({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: Row(
        children: [
          Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: user.userimg != null
                      ? DecorationImage(
                          image: NetworkImage(
                              user.userimg! + r"&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg"),
                          fit: BoxFit.fill)
                      : DecorationImage(image: R.image.logo_150_jpg(), fit: BoxFit.fill))),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          TextSpan(text: user.point!.toInt().toString()),
                          const TextSpan(text: 'P')
                        ])),
                      ],
                    ),
                    const Spacer(),
                    const VerticalDivider(thickness: 1, width: 0, color: Color(0xff3e3e3e)),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () async {
                        var status = await Permission.camera.status;
                        if (status.isDenied) await Permission.camera.request();
                        if (context.mounted) {
                          showDialog(
                              context: context,
                              builder: (context) => ScanQRCode(status == PermissionStatus.granted));
                        }
                      },
                      child: const Icon(Icons.qr_code, color: Color(0xfffafafa), size: 45),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
