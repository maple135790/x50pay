import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/user_info_panel/liquid_glass_user_info_panel.dart';
import 'package:x50pay/page/home/user_info_panel/material_user_info_panel.dart';
import 'package:x50pay/route/app_route.dart';

class UserInfoPanel extends StatelessWidget {
  final UserModel user;
  const UserInfoPanel(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    void onScannerPressed(GoRouter router) async {
      final status = await Permission.camera.status;
      if (status.isDenied) {
        await Permission.camera.request();
      }
      router.pushNamed(AppRoute.scanQRCode.routeName);
    }

    final widgetBuilder = InfoWidgetBuilder(user);
    return ThemedWidgetFactory.create(
      context.read<AppInitializer>(),
      liquidGlassWidgetBuilder: () => LiquidGlassUserInfoPanel(
        widgetBuilder,
        onScannerPressed: onScannerPressed,
      ),
      materialWidgetBuilder: () => MaterialUserInfoPanel(
        widgetBuilder,
        onScannerPressed: onScannerPressed,
      ),
    );
  }
}

class InfoWidgetBuilder {
  final UserModel user;
  const InfoWidgetBuilder(this.user);

  // TODO: 新增月票購買 bottomSheet
  void _onBuyTicket() {}

  Widget nameInfo(GoRouter router) {
    void onPhoneActivatePressed(GoRouter router) {
      router.goNamed(
        AppRoute.settings.routeName,
        queryParameters: {'goTo': 'phoneChange'},
      );
    }

    final unactivated = TextSpan(
      text: ' (未驗證)',
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          onPhoneActivatePressed(router);
        },
    );

    final isPhoneActive = user.phoneactive ?? false;
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(child: Icon(Icons.person_rounded, size: 20)),
          const WidgetSpan(child: SizedBox(width: 5)),
          TextSpan(
            text: user.name!,
            children: !isPhoneActive ? [unactivated] : null,
          ),
        ],
      ),
    );
  }

  Widget ticketInfo(S i18n) {
    final rawDate = user.vipdate?.rawDate;
    final vipDate = rawDate == null ? null : DateTime.tryParse(rawDate);
    const linkColor = Color(0xff8887ff);
    final vipStatus = (user.vip ?? false)
        ? [
            TextSpan(text: i18n.vipOwned),
            TextSpan(text: "${vipDate?.month}/${vipDate?.day}"),
          ]
        : [
            TextSpan(text: i18n.vipMsgBuy1),
            TextSpan(
              text: i18n.vipMsgBuy2,
              style: const TextStyle(color: linkColor),
              recognizer: TapGestureRecognizer()..onTap = _onBuyTicket,
              children: const [
                WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(
                      Icons.open_in_new_rounded,
                      color: linkColor,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ];
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(child: Icon(Icons.local_activity_rounded, size: 20)),
          const WidgetSpan(child: SizedBox(width: 5)),
          TextSpan(text: user.ticketint!.toString()),
          ...vipStatus,
        ],
      ),
    );
  }

  Widget pointInfo() {
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(child: Icon(Icons.wallet_rounded, size: 20)),
          const WidgetSpan(child: SizedBox(width: 5)),
          TextSpan(text: user.point!.toInt().toString()),
          const TextSpan(text: ' + '),
          TextSpan(
            text: user.fpoint!.toInt().toString(),
            style: const TextStyle(color: Color(0xffd4b106)),
          ),
          const TextSpan(text: ' P'),
        ],
      ),
    );
  }
}
