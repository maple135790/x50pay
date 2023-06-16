import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/r.g.dart';

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

Future<bool> _checkLogin() async {
  final pref = await SharedPreferences.getInstance();
  final sess = pref.getString('session');
  if (sess == null) return false;
  return await GlobalSingleton.instance.checkUser();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLogined = await _checkLogin();
  configLoadingStyle();
  runApp(MyApp(isLogined));
}

void configLoadingStyle() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..infoWidget = Image(
        image: R.svg.torii(width: 80, height: 80),
        color: const Color(0xfffafafa))
    ..maskType = EasyLoadingMaskType.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.amber
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..indicatorSize = 80
    ..indicatorWidget = const _Spinner()
    // ..userInteractions = false
    ..dismissOnTap = true;
  // ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  const MyApp(this.isLogin, {super.key});

  @override
  Widget build(BuildContext context) {
    String debugRoute = AppRoute.login;

    return MaterialApp(
      title: 'Flutter Demo',
      scaffoldMessengerKey: scaffoldKey,
      theme: AppThemeData().materialTheme,
      builder: EasyLoading.init(),
      navigatorObservers: [NavigationHistoryObserver()],
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: kDebugMode || GlobalSingleton.instance.isOnline
          ? debugRoute
          : isLogin
              ? AppRoute.home
              : AppRoute.login,
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
