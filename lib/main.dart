import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemeData().materialTheme,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: kDebugMode ? AppRoute.login : AppRoute.login,
    );
  }
}
