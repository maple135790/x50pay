import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/common/widgets/themed_bottom_sheet/themed_bottom_sheet.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/dress_room/dress_room.dart';
import 'package:x50pay/page/home/mari_info/mari_info.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/home_refresh_provider.dart';
import 'package:x50pay/route/app_route.dart';

class LiquidGlassMariInfo extends StatelessWidget {
  final MariWidgetBuilder builder;
  const LiquidGlassMariInfo(this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    void onGradeBoxPressed() {
      context.goNamed(AppRoute.gradeBox.routeName);
    }

    void onDressRoomPressed() async {
      final refreshProvider = context.read<HomeRefreshProvider>();
      final isDressChanged = await showThemedModalBottomSheet<bool>(
        context: context,
        useRootNavigator: true,
        title: S.of(context).dressRoomTitle,
        builder: (context) => const DressRoom(),
      );
      if (isDressChanged != true) return;
      refreshProvider.refresh();
    }

    final gradeBoxShopButton = GlassButton.custom(
      height: 35,
      width: 110.5,
      shape: const LiquidRoundedSuperellipse(borderRadius: 50),
      onTap: onGradeBoxPressed,
      child: builder.gradeBoxShopButtonText(i18n: S.of(context)),
    );

    return Selector<EntryProvider, EntryModel?>(
      selector: (context, provider) => provider.entry,
      builder: (context, entry, child) {
        if (entry == null) return const Center(child: Text('未取得Entry 資料'));

        final helper = AppThemeHelper(context);

        final dressRoomButton = GlassButton(
          width: 30,
          height: 30,
          onTap: onDressRoomPressed,
          icon: SvgPicture(
            Svgs.shirtSolid,
            width: 17.875,
            height: 14.3,
            colorFilter: SvgsExtension.colorFilter(const Color(0xffffc0cb)),
          ),
          persistPressOnDrag: false,
        );

        final content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: Stack(
                fit: StackFit.passthrough,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 6, right: 4.5),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: builder.mariImage(entry),
                  ),
                  Positioned(bottom: 15, right: -6, child: dressRoomButton),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    builder.gradeProgressbar(entry),
                    const SizedBox(height: 12),
                    GlassContainer(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                builder.pointProgressBar(entry),
                                builder.fpProgressBar(entry),
                              ],
                            ),
                          ),
                          Positioned.fill(child: builder.cmDoneMask(entry)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: builder.levelText(
                        entry,
                        i18n: S.of(context),
                        gradeBoxShopButton: gradeBoxShopButton,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

        return GlassContainer(
          margin: const EdgeInsets.fromLTRB(20, 12, 20, 2),
          shape: const LiquidRoundedSuperellipse(borderRadius: 15),
          child: Stack(
            children: [
              Positioned(
                bottom: -25,
                right: -40,
                child: Icon(
                  Icons.compost_rounded,
                  size: 140,
                  color: helper.iconColor.withValues(alpha: 0.1),
                ),
              ),
              content,
            ],
          ),
        );
      },
    );
  }
}
