import 'package:flutter/material.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/page/pages.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoute.login:
        return MaterialPageRoute(builder: (context) => const Login());
      case AppRoute.forgotPassword:
        return MaterialPageRoute(builder: (context) => const ForgotPassword());
      case AppRoute.license:
        return MaterialPageRoute(builder: (context) => const License());
      default:
        return MaterialPageRoute(builder: (context) => const NotExist());
    }
  }
}
