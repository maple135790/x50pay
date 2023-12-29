import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/generated/l10n.dart';

class TicketInfo extends StatelessWidget {
  /// 票券資訊
  ///
  /// 包含券量、月票、月票期限
  const TicketInfo({super.key});

  String vipExpDate(int expDate) {
    final date = DateTime.fromMillisecondsSinceEpoch(expDate);
    return '${date.month}/${date.day} ${date.hour}:${date.minute}';
  }

  void onTicketInfoPressed(GoRouter router) {
    router.goNamed(
      AppRoutes.settings.routeName,
      queryParameters: {'goTo': "ticketRecord"},
    );
  }

  void onMPassPressed(GoRouter router) {
    router.pushNamed(AppRoutes.buyMPass.routeName);
  }

  Color getIconColor(bool isDarkTheme) {
    if (isDarkTheme) {
      return const Color(0xfffafafa).withOpacity(0.1);
    } else {
      return const Color(0xff373737).withOpacity(0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final i18n = S.of(context);

    return ValueListenableBuilder(
        valueListenable: GlobalSingleton.instance.userNotifier,
        builder: (context, user, child) {
          user = user!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Stack(children: [
              Positioned(
                  bottom: -35,
                  right: -20,
                  child: Icon(
                    Icons.east_rounded,
                    size: 120,
                    color: getIconColor(isDarkTheme),
                  )),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isDarkTheme
                          ? CustomColorThemes.borderColorDark
                          : CustomColorThemes.borderColorLight,
                    )),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            onMPassPressed(GoRouter.of(context));
                          },
                          child: Icon(
                            Icons.confirmation_number_rounded,
                            color: const Color(0xff237804).withOpacity(0.7),
                            size: 50,
                          )),
                      const SizedBox(width: 16),
                      VerticalDivider(
                        thickness: 1,
                        width: 0,
                        color: isDarkTheme
                            ? CustomColorThemes.borderColorDark
                            : CustomColorThemes.borderColorLight,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            onTicketInfoPressed(GoRouter.of(context));
                          },
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(children: [
                                  TextSpan(text: i18n.ticketBalance),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  TextSpan(text: user.ticketint!.toString()),
                                  TextSpan(text: i18n.ticketUnit),
                                ])),
                                const SizedBox(height: 5),
                                Text.rich(TextSpan(children: [
                                  TextSpan(text: i18n.monthlyPass),
                                  const WidgetSpan(child: SizedBox(width: 5)),
                                  TextSpan(
                                    text: user.vip!
                                        ? i18n.mpassValid
                                        : i18n.mpassInvalid,
                                  )
                                ])),
                                const SizedBox(height: 5),
                                Text.rich(TextSpan(children: [
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
        });
  }
}
