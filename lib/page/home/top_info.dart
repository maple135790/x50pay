import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/providers/user_provider.dart';

class TopInfo extends StatelessWidget {
  /// 頁面頂部的個人資訊
  ///
  /// 包含頭像、名稱、UID、P點、QRCode掃描按鈕
  const TopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    void onPhoneActivatePressed() {
      context.goNamed(
        AppRoutes.settings.routeName,
        queryParameters: {'goTo': 'phoneChange'},
      );
    }

    void onScannerPressed() async {
      final router = GoRouter.of(context);
      final status = await Permission.camera.status;
      if (status.isDenied) {
        await Permission.camera.request();
      }
      router.pushNamed(AppRoutes.scanQRCode.routeName);
    }

    return Selector<UserProvider, UserModel>(
      selector: (context, provider) => provider.user!,
      builder: (context, user, child) {
        final unActivatedLabel = TextSpan(
          text: ' (未驗證)',
          recognizer: TapGestureRecognizer()..onTap = onPhoneActivatePressed,
        );

        final nameInfo = Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.person_rounded,
                  size: 20,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 5)),
              TextSpan(
                text: user.name!,
                children: [
                  if (!(user.phoneactive ?? false)) unActivatedLabel,
                ],
              ),
            ],
          ),
        );

        final userIdInfo = Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.perm_contact_cal_rounded,
                  size: 20,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 5)),
              TextSpan(text: user.uid!)
            ],
          ),
        );

        final pointInfo = Text.rich(
          TextSpan(
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.currency_yen_rounded,
                  size: 20,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 5)),
              TextSpan(text: user.point!.toInt().toString()),
              const TextSpan(text: ' + '),
              TextSpan(
                text: user.fpoint!.toInt().toString(),
                style: const TextStyle(color: Color(0xffd4b106)),
              ),
              const TextSpan(text: ' P')
            ],
          ),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            children: [
              Material(
                shape: const CircleBorder(),
                elevation: 2.5,
                child: Container(
                  width: 88,
                  height: 88,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                    imageUrl: user.userImageUrl,
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error_outline_rounded,
                      size: 45,
                    ),
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isDarkTheme
                          ? CustomColorThemes.borderColorDark
                          : CustomColorThemes.borderColorLight,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            nameInfo,
                            const SizedBox(height: 5),
                            userIdInfo,
                            const SizedBox(height: 5),
                            pointInfo,
                          ],
                        ),
                        const Spacer(),
                        VerticalDivider(
                          thickness: 1,
                          width: 0,
                          color: isDarkTheme
                              ? CustomColorThemes.borderColorDark
                              : CustomColorThemes.borderColorLight,
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: onScannerPressed,
                          child: const Icon(
                            Icons.qr_code_rounded,
                            size: 45,
                          ),
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
