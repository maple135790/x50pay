import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/user_provider.dart';

class TicketInfo extends StatelessWidget {
  /// 票券資訊
  ///
  /// 包含券量、月票、月票期限
  const TicketInfo({super.key});

  String vipExpDate(String expDate) {
    final date = DateTime.parse(expDate);
    return '${date.month}/${date.day} ${date.hour}:${date.minute}';
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final i18n = S.of(context);

    void onTicketInfoPressed() {
      context.goNamed(
        AppRoutes.settings.routeName,
        queryParameters: {'goTo': "ticketRecord"},
      );
    }

    void onMPassPressed() {
      context.pushNamed(AppRoutes.buyMPass.routeName);
    }

    return Selector<UserProvider, UserModel>(
      selector: (context, provider) => provider.user!,
      builder: (context, user, child) {
        late final String vipMessage;
        late final String vipStatus;
        if (user.vip!) {
          vipMessage = vipExpDate(user.vipdate!.rawDate);
          vipStatus = i18n.mpassValid;
        } else {
          vipMessage = i18n.vipExpiredMsg;
          vipStatus = i18n.mpassInvalid;
        }

        final holdingTicketsInfo = Text.rich(
          TextSpan(
            children: [
              TextSpan(text: i18n.ticketBalance),
              const WidgetSpan(
                child: SizedBox(width: 5),
              ),
              TextSpan(text: user.ticketint!.toString()),
              TextSpan(text: i18n.ticketUnit),
            ],
          ),
        );

        final vipStatusInfo = Text.rich(
          TextSpan(
            children: [
              TextSpan(text: i18n.monthlyPass),
              const WidgetSpan(child: SizedBox(width: 5)),
              TextSpan(text: vipStatus),
            ],
          ),
        );

        final vipDateInfo = Text.rich(
          TextSpan(
            children: [
              TextSpan(text: i18n.vipDate),
              const WidgetSpan(child: SizedBox(width: 5)),
              TextSpan(text: vipMessage),
            ],
          ),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Stack(
            children: [
              Positioned(
                bottom: -35,
                right: -20,
                child: Icon(
                  Icons.east_rounded,
                  size: 120,
                  color: getIconColor(isDarkTheme),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isDarkTheme
                        ? CustomColorThemes.borderColorDark
                        : CustomColorThemes.borderColorLight,
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onMPassPressed,
                        child: const Icon(
                          Icons.confirmation_number_rounded,
                          color: Color(0xff237804),
                          size: 50,
                        ),
                      ),
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
                          onTap: onTicketInfoPressed,
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                holdingTicketsInfo,
                                const SizedBox(height: 5),
                                vipStatusInfo,
                                const SizedBox(height: 5),
                                vipDateInfo,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
