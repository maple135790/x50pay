import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
