import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/home/dress_room/dress_room_popup.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/page/home/progress_bar.dart';
import 'package:x50pay/r.g.dart';

// part "grade_box_popup.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends BaseStatefulState<Home> {
  final viewModel = HomeViewModel()..isFunctionalHeader = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: viewModel.initHome(),
      key: ValueKey(viewModel.entry),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          log('home not done');
          return const SizedBox();
        }
        if (snapshot.data == false) {
          EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
          return const SizedBox(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
        } else {
          return SingleChildScrollView(
              child: _HomeLoaded(GlobalSingleton.instance.user!, viewModel));
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
  Widget divider(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xff3e3e3e))),
          Text(' $title '),
          const Expanded(child: Divider(color: Color(0xff3e3e3e))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final recentQuests = widget.viewModel.entry!.questCampaign;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        _TopInfo(user: user),
        _TicketInfo(user: user),
        _MariInfo(isVip: user.vip!, entryData: widget.viewModel.entry!),
        if (recentQuests != null) divider('最新活動'),
        if (recentQuests != null) _RecentQuests(quests: recentQuests),
        divider('官方資訊'),
        _EventInfo(widget.viewModel.entry!.evlist),
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: GestureDetector(
                onTap: () {
                  launchUrlString(
                      'https://www.youtube.com/channel/UCEbHRn4kPMzODDgsMwGhYVQ',
                      mode: LaunchMode.externalNonBrowserApplication);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(image: R.image.vts())))),
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: GestureDetector(
                onTap: () {
                  launchUrlString(
                      'https://www.youtube.com/c/X50MusicGameStation-onAir',
                      mode: LaunchMode.externalNonBrowserApplication);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(image: R.image.top())))),
        const SizedBox(height: 25),
      ],
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
            bottom: -35,
            right: -20,
            child:
                Icon(Icons.east_rounded, size: 120, color: Color(0xff343434))),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Themes.borderColor)),
          child: IntrinsicHeight(
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      GoRouter.of(context)
                          .pushNamed(AppRoutes.buyMPass.routeName);
                      // Navigator.of(context).pushNamed(AppRoute.buyMPass);
                    },
                    child: const Icon(Icons.confirmation_number_rounded,
                        color: Color(0xff237804), size: 50)),
                const SizedBox(width: 16),
                const VerticalDivider(
                    thickness: 1, width: 0, color: Color(0xff3e3e3e)),
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
                          style: TextStyle(
                              color: user.vip! == false ? Colors.red : null))
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

class _RecentQuests extends StatelessWidget {
  final List<QuestCampaign> quests;
  const _RecentQuests({required this.quests});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: quests
          .map((q) => GestureDetector(
                onTap: () {
                  context.goNamed(AppRoutes.questCampaign.routeName,
                      pathParameters: {'couid': q.couid});
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff505050)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: q.lpic,
                    fit: BoxFit.fitWidth,
                    height: 55,
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _MariInfo extends StatefulWidget {
  final bool isVip;
  final EntryModel entryData;

  const _MariInfo({
    required this.isVip,
    required this.entryData,
  });

  @override
  State<_MariInfo> createState() => _MariInfoState();
}

class _MariInfoState extends State<_MariInfo> {
  late final entry = widget.entryData;
  final progressBarNotifier = ValueNotifier(false);

  void onProgressBarCreated() async {
    await Future.delayed(const Duration(milliseconds: 150), () {
      progressBarNotifier.value = true;
    });
  }

  void onGradeBoxPressed() {
    context.goNamed(AppRoutes.gradeBox.routeName);
  }

  void onDressRoomPressed() {
    showDialog(
      context: context,
      builder: (context) => const DressRoomPopup(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraint) => ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Stack(children: [
            const Positioned(
                bottom: -25,
                right: -40,
                child: Icon(Icons.compost_rounded,
                    size: 140, color: Color(0xff343434))),
            Container(
              width: constraint.maxWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Themes.borderColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.maxFinite,
                      child: FadeInImage(
                        image: MemoryImage(entry.ava),
                        placeholder: MemoryImage(kTransparentImage),
                        fadeInDuration: const Duration(milliseconds: 150),
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        height: 270,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: IconButton(
                        iconSize: 16.5,
                        onPressed: onDressRoomPressed,
                        padding: EdgeInsets.zero,
                        icon: ImageIcon(
                            R.svg.shirt_solid(width: 16.25, height: 13)),
                        color: const Color(0xffffc0cb),
                        style: const ButtonStyle(
                          side: MaterialStatePropertyAll(
                              BorderSide(color: Color(0xff3e3e3e))),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Image(
                              width: 17,
                              height: 17,
                              image: R.svg.heart_solid(width: 17, height: 17),
                              color: const Color(0xbfff1100)),
                          const SizedBox(width: 5),
                          Text(entry.gradeLv,
                              style: const TextStyle(
                                  color: Color(0xff808080), fontSize: 30)),
                          const SizedBox(width: 5),
                          Tooltip(
                            preferBelow: false,
                            decoration: BoxDecoration(
                                color: const Color(0x33fefefe),
                                borderRadius: BorderRadius.circular(8)),
                            message: widget.isVip ? '月票：當日前12道加成' : '當日前10道加成',
                            child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff2282e9),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Image(
                                            image: R.svg.bolt_solid(
                                                width: 9, height: 13),
                                            width: 9,
                                            height: 13,
                                            color: Colors.white),
                                      ),
                                      Text(entry.gr2BounsLeft),
                                      const SizedBox(width: 3)
                                    ])),
                          )
                        ]),
                        const SizedBox(height: 5),
                        ValueListenableBuilder(
                          valueListenable: progressBarNotifier,
                          builder: (context, isProgressBarCreated, child) =>
                              AnimatedCrossFade(
                            duration: const Duration(milliseconds: 150),
                            alignment: Alignment.center,
                            crossFadeState: isProgressBarCreated
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            secondCurve: Curves.easeInOutExpo,
                            firstChild: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child:
                                  SizedBox(height: 24, width: double.maxFinite),
                            ),
                            secondChild: ProgressBar(
                              onProgressBarCreated: onProgressBarCreated,
                              currentValue: entry.gr2Progress <= 20
                                  ? 20
                                  : entry.gr2Progress,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(fontSize: 11.5),
                                        children: [
                                      const WidgetSpan(
                                          child: Icon(Icons.redeem_rounded,
                                              color: Color(0xfffafafa),
                                              size: 15)),
                                      const WidgetSpan(
                                          child: SizedBox(width: 5)),
                                      const TextSpan(text: ' 每 '),
                                      TextSpan(text: entry.gr2HowMuch),
                                      const TextSpan(text: ' 道贈 1 張，上限 '),
                                      TextSpan(text: entry.gr2Limit),
                                      const TextSpan(text: ' 張 '),
                                    ])),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(fontSize: 11.5),
                                        children: [
                                      const WidgetSpan(
                                          child: Icon(Icons.favorite_rounded,
                                              color: Color(0xfffafafa),
                                              size: 15)),
                                      const WidgetSpan(
                                          child: SizedBox(width: 5)),
                                      const TextSpan(text: ' 下一階: '),
                                      TextSpan(text: entry.gr2Next),
                                      const TextSpan(text: ' 親密度 '),
                                    ])),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(fontSize: 11.5),
                                        children: [
                                      const WidgetSpan(
                                          child: Icon(
                                              Icons.calendar_today_rounded,
                                              color: Color(0xfffafafa),
                                              size: 15)),
                                      const WidgetSpan(
                                          child: SizedBox(width: 5)),
                                      const TextSpan(text: ' 已簽到: '),
                                      TextSpan(text: entry.gr2Day),
                                    ])),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(fontSize: 11.5),
                                        children: [
                                      const WidgetSpan(
                                          child: Icon(Icons.how_to_vote_rounded,
                                              color: Color(0xfffafafa),
                                              size: 15)),
                                      const WidgetSpan(
                                          child: SizedBox(width: 5)),
                                      const TextSpan(text: ' 抽獎券: '),
                                      const TextSpan(text: ' 再 '),
                                      TextSpan(text: entry.gr2VDay),
                                      const TextSpan(text: ' 點 '),
                                    ])),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.5),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(fontSize: 11.5),
                                        children: [
                                      const WidgetSpan(
                                          child: Icon(Icons.sync_rounded,
                                              color: Color(0xfffafafa),
                                              size: 15)),
                                      const WidgetSpan(
                                          child: SizedBox(width: 5)),
                                      const TextSpan(text: ' 換季日: '),
                                      TextSpan(text: entry.gr2Date),
                                    ])),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: onGradeBoxPressed,
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            horizontal: 20)),
                                    textStyle: MaterialStateProperty.all(
                                        const TextStyle(fontSize: 13)),
                                    visualDensity: VisualDensity.comfortable,
                                    splashFactory: NoSplash.splashFactory,
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    foregroundColor: MaterialStateProperty.all(
                                        const Color(0xfff5222d)),
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                            (states) {
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
      ),
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
              child: const Text('優惠時段',
                  style: TextStyle(color: Color(0xfffafafa), fontSize: 13)),
            )),
        const Positioned(
          top: 40,
          left: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('●   WACCA / GC / 女武神 / pop\'n 無提供優惠方案',
                  style: TextStyle(color: Color(0xfffafafa))),
              SizedBox(height: 5),
              Text('●   月票： 全日延長至 19:00 優惠時段',
                  style: TextStyle(color: Color(0xfffafafa))),
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
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
              imageUrl: user.userImageUrl,
              alignment: Alignment.center,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Themes.borderColor)),
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
                          const WidgetSpan(
                              child: Icon(Icons.person_rounded,
                                  color: Color(0xfffafafa), size: 20)),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          TextSpan(
                              text: user.name!,
                              children: user.phoneactive!
                                  ? null
                                  : [
                                      TextSpan(
                                          text: ' (未驗證)',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context.goNamed(
                                                  AppRoutes.settings.routeName,
                                                  queryParameters: {
                                                    'goPhone': 'true'
                                                  });
                                            })
                                    ])
                        ])),
                        const SizedBox(height: 5),
                        RichText(
                            text: TextSpan(children: [
                          const WidgetSpan(
                              child: Icon(Icons.perm_contact_cal_rounded,
                                  color: Color(0xfffafafa), size: 20)),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          TextSpan(text: user.uid!)
                        ])),
                        const SizedBox(height: 5),
                        RichText(
                            text: TextSpan(children: [
                          const WidgetSpan(
                              child: Icon(Icons.currency_yen_rounded,
                                  color: Color(0xfffafafa), size: 20)),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          TextSpan(text: user.point!.toInt().toString()),
                          const TextSpan(text: 'P')
                        ])),
                      ],
                    ),
                    const Spacer(),
                    const VerticalDivider(
                        thickness: 1, width: 0, color: Color(0xff3e3e3e)),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () async {
                        var status = await Permission.camera.status;
                        if (status.isDenied) await Permission.camera.request();
                        if (context.mounted) {
                          context.pushNamed(
                            AppRoutes.scanQRCode.routeName,
                            extra: status,
                          );
                        }
                      },
                      child: const Icon(Icons.qr_code_rounded,
                          color: Color(0xfffafafa), size: 45),
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
