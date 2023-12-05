import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/page/home/progress_bar.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

class Home extends StatefulWidget {
  /// 首頁
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends BaseStatefulState<Home> {
  final repo = Repository();
  late final HomeViewModel viewModel;

  var refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(repository: repo)..isFunctionalHeader = false;
  }

  Future<void> onRefresh() async {
    refreshKey = GlobalKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshIndicator(
        displacement: 80,
        onRefresh: onRefresh,
        child: ChangeNotifierProvider.value(
          value: viewModel,
          builder: (context, child) => FutureBuilder(
            future: viewModel.initHome(),
            key: refreshKey,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (viewModel.entry == null) {
                showServiceError();
                return Center(child: Text(serviceErrorText));
              }
              return const Scrollbar(
                child: SingleChildScrollView(
                  child: _HomeLoaded(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeLoaded extends StatefulWidget {
  const _HomeLoaded();

  @override
  State<_HomeLoaded> createState() => _HomeLoadedState();
}

class _HomeLoadedState extends BaseStatefulState<_HomeLoaded> {
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
    return Consumer<HomeViewModel>(
      builder: (context, vm, child) {
        final recentQuests = vm.entry!.questCampaign;
        final event = vm.entry!.evlist;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const _TopInfo(),
            const _TicketInfo(),
            const _MariInfo(),
            if (event != null && event.isNotEmpty) _EventInfo(events: event),
            if (recentQuests != null) divider(i18n.infoNotify),
            if (recentQuests != null) _RecentQuests(quests: recentQuests),
            divider(i18n.officialNotify),
            const _OfficialInfo(),
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }
}

class _OfficialInfo extends StatelessWidget {
  /// 官方資訊區
  ///
  /// 包含官方資訊的圖片，點擊圖片後會跳轉到該活動的頁面
  /// 通常是真璃的 youtube 頻道，及 X50 的 youtube 頻道
  const _OfficialInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    Image(
                      image: R.image.vts(),
                      fit: BoxFit.fill,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            launchUrlString(
                                'https://www.youtube.com/channel/UCEbHRn4kPMzODDgsMwGhYVQ',
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                        ),
                      ),
                    ),
                  ],
                ))),
        Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    Image(
                      image: R.image.top(),
                      fit: BoxFit.fill,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            launchUrlString(
                                'https://www.youtube.com/c/X50MusicGameStation-onAir',
                                mode: LaunchMode.externalNonBrowserApplication);
                          },
                        ),
                      ),
                    ),
                  ],
                )))
      ],
    );
  }
}

class _TicketInfo extends StatelessWidget {
  /// 票券資訊
  ///
  /// 包含券量、月票、月票期限
  const _TicketInfo();

  String vipExpDate(int expDate) {
    final date = DateTime.fromMillisecondsSinceEpoch(expDate);
    return '${date.month}/${date.day} ${date.hour}:${date.minute}';
  }

  void onTicketInfoPressed(BuildContext context) {
    context.goNamed(
      AppRoutes.settings.routeName,
      queryParameters: {'goTo': "ticketRecord"},
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = S.of(context);
    final user = GlobalSingleton.instance.userNotifier.value!;

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
                    },
                    child: const Icon(Icons.confirmation_number_rounded,
                        color: Color(0xff237804), size: 50)),
                const SizedBox(width: 16),
                const VerticalDivider(
                    thickness: 1, width: 0, color: Color(0xff3e3e3e)),
                const SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      onTicketInfoPressed(context);
                    },
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: i18n.ticketBalance),
                            const WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(text: user.ticketint!.toString()),
                            TextSpan(text: i18n.ticketUnit),
                          ])),
                          const SizedBox(height: 5),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: i18n.monthlyPass),
                            const WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(
                              text: user.vip!
                                  ? i18n.mpassValid
                                  : i18n.mpassInvalid,
                            )
                          ])),
                          const SizedBox(height: 5),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(text: i18n.vipDate),
                            const WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(
                                text: user.vip!
                                    ? vipExpDate(user.vipdate!.date)
                                    : i18n.vipExpiredMsg)
                          ])),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class _EventInfo extends StatelessWidget {
  /// 活動資訊
  final List<Evlist> events;

  /// 訊息告知區塊
  const _EventInfo({required this.events});

  @override
  Widget build(BuildContext context) {
    final i18n = S.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 13.5, 15, 6),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          border: Border.all(color: Themes.borderColor),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 標題
            Transform.translate(
              offset: const Offset(9.8, -12),
              child: ColoredBox(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 9.8),
                  child: Text(i18n.msgNotify),
                ),
              ),
            ),
            // 活動列表，不需要使用 Vertical Padding
            ...events.map((evt) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("> ${evt.name} : ${evt.describe}\n"),
                ))
          ],
        ),
      ),
    );
  }
}

class _RecentQuests extends StatelessWidget {
  /// 活動列表
  final List<QuestCampaign> quests;

  /// 最新活動區塊
  ///
  /// 包含最新活動的圖片，點擊圖片後會跳轉到該活動的頁面
  const _RecentQuests({required this.quests});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: quests
          .map((q) => Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff505050),
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: q.lpic,
                      height: 55,
                      width: MediaQuery.sizeOf(context).width,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.goNamed(AppRoutes.questCampaign.routeName,
                                pathParameters: {'couid': q.couid});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _MariInfo extends StatefulWidget {
  /// 真璃養成點數資訊
  ///
  /// 包含等級、養成點數、養成點數進度條、養成點數商城按鈕等
  const _MariInfo();

  @override
  State<_MariInfo> createState() => _MariInfoState();
}

class _MariInfoState extends BaseStatefulState<_MariInfo> {
  final isVip = GlobalSingleton.instance.userNotifier.value?.vip ?? false;
  final progressBarNotifier = ValueNotifier(false);

  void onProgressBarCreated() async {
    await Future.delayed(const Duration(milliseconds: 150), () {
      progressBarNotifier.value = true;
    });
  }

  void onGradeBoxPressed() {
    context.goNamed(AppRoutes.gradeBox.routeName);
  }

  void onDressRoomPressed() async {
    context.goNamed(AppRoutes.dressRoom.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, vm, child) {
        final entry = vm.entry!;

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
                          child: Stack(
                            fit: StackFit.passthrough,
                            children: [
                              FadeInImage(
                                image: MemoryImage(entry.ava),
                                placeholder: MemoryImage(kTransparentImage),
                                fadeInDuration:
                                    const Duration(milliseconds: 150),
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                height: 270,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: IconButton(
                                    iconSize: 16.5,
                                    onPressed: onDressRoomPressed,
                                    padding: EdgeInsets.zero,
                                    icon: SvgPicture(
                                      Svgs.shirtSolid,
                                      width: 17.875,
                                      height: 14.3,
                                      colorFilter: SvgsExtension.colorFilter(
                                          const Color(0xffffc0cb)),
                                    ),
                                    color: const Color(0xffffc0cb),
                                    style: const ButtonStyle(
                                      side: MaterialStatePropertyAll(
                                          BorderSide(color: Color(0xff3e3e3e))),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                              SvgPicture(
                                Svgs.heartSoild,
                                width: 17,
                                height: 17,
                                colorFilter: SvgsExtension.colorFilter(
                                    const Color(0xbfff1100)),
                              ),
                              const SizedBox(width: 5),
                              Text(entry.gradeLv,
                                  style: const TextStyle(
                                      color: Color(0xff808080), fontSize: 30)),
                              const SizedBox(width: 5),
                              if (entry.gr2ShouldShowBouns)
                                Tooltip(
                                  preferBelow: false,
                                  triggerMode: TooltipTriggerMode.tap,
                                  decoration: BoxDecoration(
                                      color: const Color(0x33fefefe),
                                      borderRadius: BorderRadius.circular(8)),
                                  message: isVip ? '月票：剩餘的加成次數' : '剩餘的加成次數',
                                  textStyle:
                                      Theme.of(context).textTheme.labelMedium,
                                  verticalOffset: 25,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xff2282e9),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: SvgPicture(
                                                Svgs.boltSoild,
                                                width: 9,
                                                height: 13,
                                                colorFilter:
                                                    SvgsExtension.colorFilter(
                                                        Colors.white),
                                              ),
                                            ),
                                            Text(entry.gr2BounsLimit),
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
                                firstChild: const SizedBox(
                                    height: 24, width: double.maxFinite),
                                secondChild: ProgressBar(
                                  height: 24,
                                  onProgressBarCreated: onProgressBarCreated,
                                  currentValue: entry.gr2Progress,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: ValueListenableBuilder(
                                    valueListenable: progressBarNotifier,
                                    builder: (context, isProgressBarCreated,
                                            child) =>
                                        AnimatedCrossFade(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      alignment: Alignment.center,
                                      crossFadeState: isProgressBarCreated
                                          ? CrossFadeState.showSecond
                                          : CrossFadeState.showFirst,
                                      secondCurve: Curves.easeInOutExpo,
                                      firstChild: const SizedBox(
                                          height: 15, width: double.maxFinite),
                                      secondChild: ProgressBar(
                                        height: 15,
                                        progressText:
                                            '${entry.gr2CountMuch}/${entry.gr2HowMuch}P',
                                        progressColor: const Color(0xffffde9b),
                                        onProgressBarCreated:
                                            onProgressBarCreated,
                                        currentValue: entry.gr2ProgressV5,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 15,
                                  margin: const EdgeInsets.only(left: 9.25),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xffb0cf9e),
                                  ),
                                  child: Text(entry.gr2Timer,
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.black)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: RichText(
                                        text: TextSpan(
                                            style:
                                                const TextStyle(fontSize: 11.5),
                                            children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.redeem_rounded,
                                                  color: Color(0xfffafafa),
                                                  size: 15)),
                                          const WidgetSpan(
                                              child: SizedBox(width: 5)),
                                          TextSpan(
                                              text: i18n
                                                  .gr2Limit(entry.gr2Limit)),
                                        ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: RichText(
                                        text: TextSpan(
                                            style:
                                                const TextStyle(fontSize: 11.5),
                                            children: [
                                          const WidgetSpan(
                                              child: Icon(
                                                  Icons.favorite_rounded,
                                                  color: Color(0xfffafafa),
                                                  size: 15)),
                                          const WidgetSpan(
                                              child: SizedBox(width: 5)),
                                          TextSpan(text: i18n.nextLv),
                                          TextSpan(text: entry.gr2Next),
                                          TextSpan(text: i18n.heart),
                                        ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: RichText(
                                        text: TextSpan(
                                            style:
                                                const TextStyle(fontSize: 11.5),
                                            children: [
                                          const WidgetSpan(
                                              child: Icon(
                                                  Icons.calendar_today_rounded,
                                                  color: Color(0xfffafafa),
                                                  size: 15)),
                                          const WidgetSpan(
                                              child: SizedBox(width: 5)),
                                          TextSpan(
                                              text: i18n
                                                  .continuous(entry.gr2Day)),
                                        ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: RichText(
                                        text: TextSpan(
                                            style:
                                                const TextStyle(fontSize: 11.5),
                                            children: [
                                          const WidgetSpan(
                                              child: Icon(
                                                  Icons.how_to_vote_rounded,
                                                  color: Color(0xfffafafa),
                                                  size: 15)),
                                          const WidgetSpan(
                                              child: SizedBox(width: 5)),
                                          TextSpan(
                                              text: i18n.gatcha(entry.gr2VDay))
                                        ])),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: RichText(
                                        text: TextSpan(
                                            style:
                                                const TextStyle(fontSize: 11.5),
                                            children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.sync_rounded,
                                                  color: Color(0xfffafafa),
                                                  size: 15)),
                                          const WidgetSpan(
                                              child: SizedBox(width: 5)),
                                          TextSpan(text: i18n.gr2ResetDate),
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
                                        visualDensity:
                                            VisualDensity.comfortable,
                                        splashFactory: NoSplash.splashFactory,
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xfff5222d)),
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith(
                                                (states) {
                                          return const Color(0x22f7f7f7);
                                        }),
                                      ),
                                      child: Text(i18n.gr2HeartBox),
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
      },
    );
  }
}

class _TopInfo extends StatelessWidget {
  /// 頁面頂部的個人資訊
  ///
  /// 包含頭像、名稱、UID、P點、QRCode掃描按鈕
  const _TopInfo();

  @override
  Widget build(BuildContext context) {
    final UserModel user = GlobalSingleton.instance.userNotifier.value!;

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
                                                    'goTo': 'phoneChange'
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
                          const TextSpan(text: ' + '),
                          TextSpan(
                              text: user.fpoint!.toInt().toString(),
                              style: const TextStyle(color: Color(0xffd4b106))),
                          const TextSpan(text: ' P')
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
