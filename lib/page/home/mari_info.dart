import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/page/home/progress_bar.dart';

class MariInfo extends StatefulWidget {
  /// 真璃養成點數資訊
  ///
  /// 包含等級、養成點數、養成點數進度條、養成點數商城按鈕等
  const MariInfo({super.key});

  @override
  State<MariInfo> createState() => _MariInfoState();
}

class _MariInfoState extends BaseStatefulState<MariInfo> {
  static const avatarHeight = 270.0;

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

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15),
        const SizedBox(width: 5),
        Expanded(
          child: Wrap(
            runAlignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11.5),
              ),
              Text(
                value,
                softWrap: false,
                style: const TextStyle(fontSize: 11.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget handleMariImageError(
    BuildContext context,
    Object error,
    StackTrace? st,
  ) {
    log("", error: error, stackTrace: st);
    return const Tooltip(
      message: "資料錯誤",
      child: SizedBox(
        height: avatarHeight,
        child: Icon(Icons.warning_amber_rounded),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalSingleton.instance.entryNotifier,
      builder: (context, entry, child) {
        if (entry == null) return const Center(child: Text('未取得Entry 資料'));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: LayoutBuilder(
            builder: (context, constraint) => ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(children: [
                Positioned(
                    bottom: -25,
                    right: -40,
                    child: Icon(
                      Icons.compost_rounded,
                      size: 140,
                      color: iconColor.withOpacity(0.1),
                    )),
                Container(
                  width: constraint.maxWidth,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: borderColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Stack(
                            fit: StackFit.passthrough,
                            children: [
                              FadeInImage(
                                key: ValueKey(entry.ava),
                                image: MemoryImage(entry.ava),
                                placeholder: MemoryImage(kTransparentImage),
                                imageErrorBuilder: handleMariImageError,
                                fadeInDuration:
                                    const Duration(milliseconds: 150),
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                                height: avatarHeight,
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
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          scaffoldBackgroundColor),
                                      side: WidgetStatePropertyAll(BorderSide(
                                        color: borderColor,
                                        width: 1.5,
                                      )),
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
                            Wrap(
                              runAlignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                                            color: Color(0xff808080),
                                            fontSize: 30)),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                                if (entry.gr2ShouldShowBouns)
                                  Tooltip(
                                    preferBelow: false,
                                    triggerMode: TooltipTriggerMode.tap,
                                    message: isVip ? '月票：剩餘的加成次數' : '剩餘的加成次數',
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
                                              Text(entry.gr2BounsLimit,
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                              const SizedBox(width: 3)
                                            ])),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 10),
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
                                    child: Text.rich(
                                      TextSpan(
                                        style: const TextStyle(fontSize: 11.5),
                                        children: [
                                          const WidgetSpan(
                                              child: Icon(Icons.redeem_rounded,
                                                  size: 15)),
                                          const WidgetSpan(
                                              child: SizedBox(width: 5)),
                                          TextSpan(
                                              text: i18n
                                                  .gr2Limit(entry.gr2Limit)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: infoItem(
                                      icon: Icons.favorite_rounded,
                                      title: i18n.nextLv,
                                      value: entry.gr2Next + i18n.heart,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: infoItem(
                                      icon: Icons.calendar_today_rounded,
                                      title:
                                          "${i18n.continuous(entry.gr2Day).split(" : ").first} : ",
                                      value: i18n
                                          .continuous(entry.gr2Day)
                                          .split(" : ")
                                          .last,
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.5),
                                      child: infoItem(
                                        icon: Icons.how_to_vote_rounded,
                                        title:
                                            "${i18n.gatcha(entry.gr2VDay).split(" : ").first} : ",
                                        value: i18n
                                            .gatcha(entry.gr2VDay)
                                            .split(" : ")
                                            .last,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.5),
                                    child: infoItem(
                                      icon: Icons.sync_rounded,
                                      title: i18n.gr2ResetDate,
                                      value: entry.gr2Date,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      onPressed: onGradeBoxPressed,
                                      style: ButtonStyle(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        padding: WidgetStateProperty.all(
                                            const EdgeInsets.symmetric(
                                                horizontal: 20)),
                                        textStyle: WidgetStateProperty.all(
                                            const TextStyle(fontSize: 13)),
                                        visualDensity:
                                            VisualDensity.comfortable,
                                        splashFactory: NoSplash.splashFactory,
                                        shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        foregroundColor:
                                            WidgetStateProperty.all(
                                                const Color(0xfff5222d)),
                                        backgroundColor:
                                            WidgetStateProperty.resolveWith(
                                                (states) {
                                          return isDarkTheme
                                              ? const Color(0x22f7f7f7)
                                              : const Color(0x88e1e1e1);
                                        }),
                                      ),
                                      child: Text(
                                        i18n.gr2HeartBox,
                                        textScaler:
                                            const TextScaler.linear(0.85),
                                      ),
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
