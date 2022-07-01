import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MyNavigatorObserver extends NavigatorObserver {
  static List<Route<dynamic>?> routeStack = [];
  List<String?> routeNameStack = [];

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    routeStack.add(route);
    routeNameStack.add(route?.settings.name);
    if (kDebugMode) print('routeStack:  $routeNameStack');
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    routeStack.removeLast();
    routeNameStack.removeLast();
    if (kDebugMode) print('routeStack:  $routeNameStack');
  }

  @override
  void didRemove(Route? route, Route? previousRoute) {
    routeStack.removeLast();
    routeNameStack.removeLast();
    if (kDebugMode) print('routeStack:  $routeNameStack');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    routeStack
      ..removeLast()
      ..add(newRoute);
    routeNameStack
      ..removeLast()
      ..add(newRoute?.settings.name);
    if (kDebugMode) print('routeStack:  $routeNameStack');
  }
}
