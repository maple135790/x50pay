import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
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

  void onTicketInfoPressed(BuildContext context) {
    context.goNamed(
      AppRoutes.settings.routeName,
      queryParameters: {'goTo': "ticketRecord"},
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = S.of(context);

    return ValueListenableBuilder(
        valueListenable: GlobalSingleton.instance.userNotifier,
        builder: (context, user, child) {
          user = user!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: Stack(children: [
              const Positioned(
                  bottom: -35,
                  right: -20,
                  child: Icon(Icons.east_rounded,
                      size: 120, color: Color(0xff343434))),
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
        });
  }
}
