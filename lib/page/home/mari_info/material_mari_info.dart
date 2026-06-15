import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/progress_bar.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/route/app_route.dart';

class MaterialMariInfo extends StatefulWidget {
  const MaterialMariInfo({super.key});

  @override
  State<MaterialMariInfo> createState() => _MaterialMariInfoState();
}

class _MaterialMariInfoState extends State<MaterialMariInfo>
    with AppThemeMixin {
  S get i18n => S.of(context);

  static const avatarHeight = 270.0;

  final glassBackgoundColor = const Color(0xffbbbbbc).withValues(alpha: .05);

  final progressBarNotifier = ValueNotifier(false);

  void onProgressBarCreated() async {
    await Future.delayed(const Duration(milliseconds: 150), () {
      progressBarNotifier.value = true;
    });
  }

  void onGradeBoxPressed() {
    context.goNamed(AppRoute.gradeBox.routeName);
  }

  void onDressRoomPressed() async {
    context.goNamed(AppRoute.dressRoom.routeName);
  }

  Widget infoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15),
          const SizedBox(width: 5),
          Expanded(
            child: Wrap(
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 11.5)),
                Text(
                  value,
                  softWrap: false,
                  style: const TextStyle(fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget handleMariImageError(
    BuildContext context,
    Object error,
    StackTrace? st,
  ) {
    log("", error: error, stackTrace: st, name: "MariInfo");
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
    final isVip = context.select<UserProvider, bool>((provider) {
      return provider.user?.vip ?? false;
    });

    final gradeIcon = SvgPicture(
      Svgs.heartSoild,
      width: 17,
      height: 17,
      colorFilter: SvgsExtension.colorFilter(const Color(0xbfff1100)),
    );

    return Selector<EntryProvider, EntryModel?>(
      selector: (context, provider) => provider.entry,
      builder: (context, entry, child) {
        if (entry == null) return const Center(child: Text('未取得Entry 資料'));

        final mariImage = FadeInImage(
          key: ValueKey(entry.ava),
          image: MemoryImage(entry.ava),
          placeholder: MemoryImage(kTransparentImage),
          imageErrorBuilder: handleMariImageError,
          fadeInDuration: const Duration(milliseconds: 150),
          fit: BoxFit.contain,
          alignment: Alignment.center,
          height: avatarHeight,
        );

        final dressRoomButton = SizedBox(
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
              colorFilter: SvgsExtension.colorFilter(const Color(0xffffc0cb)),
            ),
            color: const Color(0xffffc0cb),
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(scaffoldBackgroundColor),
              side: WidgetStatePropertyAll(
                BorderSide(color: borderColor, width: 1.5),
              ),
            ),
          ),
        );

        final gradeInfo = Text(
          entry.gradeLv,
          style: const TextStyle(color: Color(0xff808080), fontSize: 30),
        );

        final vipBonusInfo = Tooltip(
          preferBelow: false,
          triggerMode: TooltipTriggerMode.tap,
          message: isVip ? '月票：剩餘的加成次數' : '剩餘的加成次數',
          verticalOffset: 25,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff2282e9),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture(
                    Svgs.boltSoild,
                    width: 9,
                    height: 13,
                    colorFilter: SvgsExtension.colorFilter(Colors.white),
                  ),
                ),
                Text(
                  entry.gr2BounsLimit,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 3),
              ],
            ),
          ),
        );

        final gradeProgressBar = ValueListenableBuilder(
          valueListenable: progressBarNotifier,
          builder: (context, isProgressBarCreated, child) => AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            crossFadeState: isProgressBarCreated
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            secondCurve: Curves.easeInOutExpo,
            firstChild: const SizedBox(height: 24, width: double.maxFinite),
            secondChild: ProgressBar(
              height: 24,
              onProgressBarCreated: onProgressBarCreated,
              currentValue: entry.gr2Progress,
            ),
          ),
        );

        final bonusProgressBar = ValueListenableBuilder(
          valueListenable: progressBarNotifier,
          builder: (context, isProgressBarCreated, child) => AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.center,
            crossFadeState: isProgressBarCreated
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            secondCurve: Curves.easeInOutExpo,
            firstChild: const SizedBox(height: 15, width: double.maxFinite),
            secondChild: ProgressBar(
              height: 15,
              progressText: '${entry.gr2CountMuch}/${entry.gr2HowMuch}P',
              progressColor: const Color(0xffffde9b),
              onProgressBarCreated: onProgressBarCreated,
              currentValue: entry.gr2ProgressV5,
            ),
          ),
        );

        final bounsCounter = Container(
          height: 15,
          margin: const EdgeInsets.only(left: 9.25),
          padding: const EdgeInsets.symmetric(horizontal: 7.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xffb0cf9e),
          ),
          child: Text(
            entry.gr2Timer,
            style: const TextStyle(fontSize: 10, color: Colors.black),
          ),
        );

        final bounsInfo = Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 11.5),
              children: [
                const WidgetSpan(child: Icon(Icons.redeem_rounded, size: 15)),
                const WidgetSpan(child: SizedBox(width: 5)),
                TextSpan(text: i18n.gr2Limit(entry.gr2Limit)),
              ],
            ),
          ),
        );

        final gradeBoxShopButton = ColoredBox(
          color: glassBackgoundColor,
          child: GestureDetector(
            onTap: onGradeBoxPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.25,
                vertical: 6,
              ),
              child: Text(
                i18n.gr2HeartBox,
                style: const TextStyle(color: Color(0xfff5222d), fontSize: 13),
              ),
            ),
          ),
        );

        final gachaTitle = i18n.gacha(entry.gr2VDay).split(" : ").first;
        final gachaValue = i18n.gacha(entry.gr2VDay).split(" : ").last;
        final loginDayTitle = i18n.continuous(entry.gr2Day).split(" : ").first;
        final loginDayValue = i18n.continuous(entry.gr2Day).split(" : ").last;

        final content = Row(
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
                    mariImage,
                    Positioned(bottom: 0, right: 0, child: dressRoomButton),
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
                          gradeIcon,
                          const SizedBox(width: 5),
                          gradeInfo,
                          const SizedBox(width: 5),
                        ],
                      ),
                      if (entry.gr2ShouldShowBouns) vipBonusInfo,
                    ],
                  ),
                  const SizedBox(height: 10),
                  gradeProgressBar,
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: bonusProgressBar),
                      bounsCounter,
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        bounsInfo,
                        infoItem(
                          icon: Icons.favorite_rounded,
                          title: i18n.nextLv,
                          value: "${entry.gr2Next} ${i18n.heart}",
                        ),
                        infoItem(
                          icon: Icons.calendar_today_rounded,
                          title: "$loginDayTitle : ",
                          value: loginDayValue,
                        ),
                        infoItem(
                          icon: Icons.how_to_vote_rounded,
                          title: "$gachaTitle : ",
                          value: gachaValue,
                        ),
                        infoItem(
                          icon: Icons.sync_rounded,
                          title: i18n.gr2ResetDate,
                          value: entry.gr2Date,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: gradeBoxShopButton,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 2),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -25,
                      right: -40,
                      child: Icon(
                        Icons.compost_rounded,
                        size: 140,
                        color: iconColor.withValues(alpha: 0.1),
                      ),
                    ),
                    Container(
                      width: constraint.maxWidth,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: glassBackgoundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: content,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
