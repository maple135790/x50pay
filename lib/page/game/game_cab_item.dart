import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/models/gamelist/gamelist.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/mixins/game_mixin.dart';
import 'package:x50pay/providers/coin_insertion_provider.dart';

class GameCabItem extends StatelessWidget with GameMixin {
  final VoidCallback onCoinInserted;
  final VoidCallback onItemPressed;
  final Machine machine;
  final String storeName;

  const GameCabItem(
    this.machine, {
    super.key,
    required this.storeName,
    required this.onCoinInserted,
    required this.onItemPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final i18n = S.of(context);
    final isWeekend =
        DateTime.now().weekday == 6 || DateTime.now().weekday == 7;
    final time = machine.mode![0].length == 4 && machine.mode![0][3] == true
        ? i18n.gameDiscountHour
        : i18n.gameNormalHour;
    final addition = machine.vipb == true
        ? " [${i18n.gameMPass}]"
        : time == i18n.gameNormalHour
            ? ''
            : isWeekend
                ? " [${i18n.gameWeekends}]"
                : " [${i18n.gameWeekday}]";

    onItemPressed.call();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return Material(
            elevation: isDarkTheme ? 5 : 10,
            borderRadius: BorderRadius.circular(5),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isDarkTheme
                        ? CustomColorThemes.borderColorDark
                        : CustomColorThemes.borderColorLight,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )),
              height: 155,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: CachedNetworkImage(
                      imageUrl: getGameCabImage(machine.id!),
                      color: const Color.fromARGB(35, 0, 0, 0),
                      colorBlendMode: BlendMode.srcATop,
                      fit: BoxFit.fitWidth,
                      alignment: const Alignment(0, -0.25),
                    )),
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            colors: [Colors.black, Colors.transparent],
                            transform: GradientRotation(12),
                            stops: [0, 0.6],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 10,
                      child: SizedBox(
                        width: width - 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "[$storeName] ${machine.lable!}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 18)
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule_rounded,
                                  size: 13,
                                  color: Color(0xe6ffffff),
                                ),
                                Text(
                                  '  $time$addition',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black, blurRadius: 15)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final coinProvider =
                                context.read<CoinInsertionProvider>();
                            await GoRouter.of(context).pushNamed<bool>(
                              AppRoutes.gameCab.routeName,
                              pathParameters: {'mid': machine.id!},
                            );

                            final isInsertToken = coinProvider.isCoinInserted;
                            log('isInsertToken: $isInsertToken',
                                name: 'GameCabItem');
                            if (isInsertToken == true) {
                              onCoinInserted.call();
                              coinProvider.isCoinInserted = false;
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
