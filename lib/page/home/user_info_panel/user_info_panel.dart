import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_initializer.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/widgets/themed_widget_factory.dart';
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

  Widget userIdInfo() {
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(
            child: Icon(Icons.perm_contact_cal_rounded, size: 20),
          ),
          const WidgetSpan(child: SizedBox(width: 5)),
          TextSpan(text: user.uid!),
        ],
      ),
    );
  }

  Widget pointInfo() {
    return Text.rich(
      TextSpan(
        children: [
          const WidgetSpan(child: Icon(Icons.currency_yen_rounded, size: 20)),
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
