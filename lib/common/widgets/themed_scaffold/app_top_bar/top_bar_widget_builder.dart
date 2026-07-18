import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/providers/user_provider.dart';

class TopBarWidgetBuilder {
  Widget pointInfo(BuildContext context) {
    return Selector<UserProvider, UserModel?>(
      selector: (context, provider) => provider.user,
      builder: (context, user, child) {
        final point = user?.point ?? 0;
        final fPoint = user?.fpoint ?? 0;
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: point.toString()),
              const TextSpan(
                text: "+",
                style: TextStyle(color: Color(0xffb4b4b4)),
              ),
              TextSpan(
                text: fPoint.toInt().toString(),
                style: const TextStyle(color: Color(0xffffec3d)),
              ),
              const TextSpan(text: "P"),
            ],
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(blurRadius: 1, color: Color(0xff1b1b1b)),
              Shadow(blurRadius: 10, color: Color(0xff1b1b1b)),
              Shadow(blurRadius: 21, color: Colors.black45),
            ],
          ),
        );
      },
    );
  }
}
