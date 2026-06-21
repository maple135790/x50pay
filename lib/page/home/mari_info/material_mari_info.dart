import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/mari_info/mari_info.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/route/app_route.dart';

class MaterialMariInfo extends StatelessWidget {
  final MariWidgetBuilder builder;
  const MaterialMariInfo(this.builder, {super.key});

  @override
  Widget build(BuildContext context) {
    void onGradeBoxPressed() {
      context.goNamed(AppRoute.gradeBox.routeName);
    }

    void onDressRoomPressed() async {
      context.goNamed(AppRoute.dressRoom.routeName);
    }

    final dressRoomButton = MaterialGlass(
      width: 30,
      height: 30,
      shape: .circle,
      color: Colors.white12,
      child: GestureDetector(
        onTap: onDressRoomPressed,
        child: Padding(
          padding: const EdgeInsets.all(6.5),
          child: SvgPicture(
            Svgs.shirtSolid,
            width: 17.875,
            height: 14.3,
            colorFilter: SvgsExtension.colorFilter(const Color(0xffffc0cb)),
          ),
        ),
      ),
    );

    final gradeBoxShopButton = MaterialGlass(
      borderRadius: 100,
      color: Colors.white12,
      child: GestureDetector(
        onTap: onGradeBoxPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.25, vertical: 6),
          child: Text(
            S.of(context).gr2HeartBox,
            style: const TextStyle(color: Color(0xfff5222d), fontSize: 13),
          ),
        ),
      ),
    );

    return Selector<EntryProvider, EntryModel?>(
      selector: (context, provider) => provider.entry,
      builder: (context, entry, child) {
        if (entry == null) return const Center(child: Text('未取得Entry 資料'));

        final helper = AppThemeHelper(context);

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
                    MaterialGlass.withShadow(
                      borderRadius: 15,
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

        return MaterialGlass(
          margin: const EdgeInsets.fromLTRB(20, 12, 20, 2),
          color: Colors.white.withValues(alpha: .05),
          borderRadius: 15,
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
