import 'package:flutter/material.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/page/pages.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.login:
        return NoTransitionRouter(const Login(), s: settings);
      case AppRoute.forgotPassword:
        return NoTransitionRouter(const ForgotPassword(), s: settings);
      case AppRoute.license:
        return NoTransitionRouter(const License(), s: settings);
      case AppRoute.signUp:
        return NoTransitionRouter(const SignUp(), s: settings);
      case AppRoute.game:
        return NoTransitionRouter(const Game(), s: settings);
      case AppRoute.account:
        return NoTransitionRouter(const Account(), s: settings);
      case AppRoute.buyMPass:
        return NoTransitionRouter(const BuyMPass(), s: settings);
      case AppRoute.gift:
        return NoTransitionRouter(const GiftSystem(), s: settings);
      case AppRoute.home:
        return NoTransitionRouter(const Home(), s: settings);

      default:
        return MaterialPageRoute(builder: (context) => const NotExist());
    }
  }
}

class NoTransitionRouter extends PageRouteBuilder {
  final Widget page;
  final RouteSettings? s;
  NoTransitionRouter(this.page, {this.s})
      : super(
          settings: s,
          transitionDuration: Duration.zero,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation1,
            Animation<double> animation2,
          ) {
            return page;
          },
        );
}
