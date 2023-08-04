import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/common/widgets/scaffold_with_nav_bar.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/account/popups/quiC_pay_pref.dart';
import 'package:x50pay/page/account/popups/quick_pay.dart';
import 'package:x50pay/page/pages.dart';
import 'package:x50pay/r.g.dart';

part 'common/go_route_generator.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<bool> _checkLogin() async {
  final pref = await SharedPreferences.getInstance();
  final sess = pref.getString('session');
  if (sess == null) return false;
  return await GlobalSingleton.instance.checkUser();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final islogin = await _checkLogin();
  log('isServiceOnline: ${GlobalSingleton.instance.isServiceOnline}',
      name: 'main');
  log('islogin: $islogin', name: 'main');
  configLoadingStyle();
  runApp(MyApp(isLogin: islogin));
}

void configLoadingStyle() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..infoWidget = Image(
        image: R.svg.torii(width: 80, height: 80),
        color: const Color(0xfffafafa))
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = const Color(0xff2a2a2a)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..indicatorSize = 80
    ..contentPadding =
        const EdgeInsets.symmetric(vertical: 22.5, horizontal: 15)
    ..indicatorWidget = const _Spinner()
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp({required this.isLogin, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppThemeData().materialTheme,
      builder: EasyLoading.init(),
      routerConfig: goRouteConfig(isLogin),
    );
  }
}

class _Spinner extends StatefulWidget {
  const _Spinner();

  @override
  State<_Spinner> createState() => _SpinnerState();
}

class _SpinnerState extends State<_Spinner> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: RotationTransition(
        turns: _animation,
        child: Image(
            image: R.svg.spinner_solid(width: 42, height: 42),
            color: Colors.white),
      ),
    );
  }
}
