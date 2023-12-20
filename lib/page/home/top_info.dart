import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/theme.dart';

class TopInfo extends StatelessWidget {
  /// 頁面頂部的個人資訊
  ///
  /// 包含頭像、名稱、UID、P點、QRCode掃描按鈕
  const TopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalSingleton.instance.userNotifier,
      builder: (context, user, child) {
        user as UserModel;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 88,
                height: 88,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: CachedNetworkImage(
                  imageUrl: user.userImageUrl,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Themes.borderColor)),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              const WidgetSpan(
                                  child: Icon(Icons.person_rounded,
                                      color: Color(0xfffafafa), size: 20)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(
                                  text: user.name!,
                                  children: user.phoneactive!
                                      ? null
                                      : [
                                          TextSpan(
                                              text: ' (未驗證)',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  context.goNamed(
                                                      AppRoutes
                                                          .settings.routeName,
                                                      queryParameters: {
                                                        'goTo': 'phoneChange'
                                                      });
                                                })
                                        ])
                            ])),
                            const SizedBox(height: 5),
                            RichText(
                                text: TextSpan(children: [
                              const WidgetSpan(
                                  child: Icon(Icons.perm_contact_cal_rounded,
                                      color: Color(0xfffafafa), size: 20)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(text: user.uid!)
                            ])),
                            const SizedBox(height: 5),
                            RichText(
                                text: TextSpan(children: [
                              const WidgetSpan(
                                  child: Icon(Icons.currency_yen_rounded,
                                      color: Color(0xfffafafa), size: 20)),
                              const WidgetSpan(child: SizedBox(width: 5)),
                              TextSpan(text: user.point!.toInt().toString()),
                              const TextSpan(text: ' + '),
                              TextSpan(
                                  text: user.fpoint!.toInt().toString(),
                                  style: const TextStyle(
                                      color: Color(0xffd4b106))),
                              const TextSpan(text: ' P')
                            ])),
                          ],
                        ),
                        const Spacer(),
                        const VerticalDivider(
                            thickness: 1, width: 0, color: Color(0xff3e3e3e)),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () async {
                            var status = await Permission.camera.status;
                            if (status.isDenied) {
                              await Permission.camera.request();
                            }
                            if (context.mounted) {
                              context.pushNamed(
                                AppRoutes.scanQRCode.routeName,
                                extra: status,
                              );
                            }
                          },
                          child: const Icon(Icons.qr_code_rounded,
                              color: Color(0xfffafafa), size: 45),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
