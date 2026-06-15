import 'dart:developer';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/common/widgets/persist_app_bar.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/app_info_provider.dart';
import 'package:x50pay/providers/environment_provider.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/route/app_route.dart';

class MaterialTopBar extends StatelessWidget implements PreferredSizeWidget {
  const MaterialTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeHelper = AppThemeHelper(context);
    final isDarkTheme = themeHelper.isDarkTheme;
    final scaffoldBackgroundColor = themeHelper.scaffoldBackgroundColor;

    void onQrScanButtonPressed() async {
      final router = GoRouter.of(context);
      var status = await Permission.camera.status;
      if (status.isDenied) await Permission.camera.request();
      router.pushNamed(AppRoute.scanQRCode.routeName);
    }

    final currentLocation = GoRouterState.of(context).matchedLocation;

    final functionalHeaderHeight = currentLocation == AppRoute.home.path
        ? 0.0
        : preferredSize.height;

    final functionalHeader = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: preferredSize.height,
        elevation: isDarkTheme ? 15 : 4,
        scrolledUnderElevation: isDarkTheme ? 15 : 6.5,
        surfaceTintColor: Colors.transparent,
        backgroundColor: scaffoldBackgroundColor,
        shadowColor: Colors.black,
        title: Align(
          alignment: Alignment.topRight,
          child: Material(
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 5.5,
                horizontal: 18,
              ),
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? CustomColorThemes.appbarBoxColorDark
                    : CustomColorThemes.appbarBoxColorLight,
              ),
              child: Selector<UserProvider, UserModel?>(
                selector: (context, provider) => provider.user,
                builder: (context, user, child) {
                  if (user == null) return const SizedBox();

                  final point = user.point?.toInt() ?? -1;
                  final fpoint = user.fpoint?.toInt() ?? -1;

                  return Text.rich(
                    TextSpan(
                      text: '$point + ',
                      style: TextStyle(
                        fontSize: Theme.of(
                          context,
                        ).textTheme.labelLarge!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '$fpoint',
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.labelLarge!.fontSize,
                            color: const Color(0xffd4b106),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' P',
                          style: TextStyle(
                            fontSize: Theme.of(
                              context,
                            ).textTheme.labelLarge!.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: GoRouter.of(context).routeInformationProvider,
            builder: (context, infoProvider, child) {
              log('!!!${infoProvider.uri.path}', name: 'DEBUG');
              final isInScanPage =
                  infoProvider.uri.path == AppRoute.scanQRCode.path;
              return InkWell(
                onTap: !isInScanPage ? onQrScanButtonPressed : null,
                splashFactory: NoSplash.splashFactory,
                child: Icon(
                  Icons.qr_code_rounded,
                  size: 28,
                  color: Theme.of(context).iconTheme.color,
                ),
              );
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
    Widget? debugStatus;
    if (kDebugMode) {
      debugStatus = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<AppInfoProvider, String>(
              selector: (context, provider) => provider.appVersion,
              builder: (context, appVersion, child) {
                return Text(
                  appVersion,
                  textScaler: const TextScaler.linear(0.95),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).textTheme.labelMedium?.color?.withValues(alpha: 0.5),
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            Selector<EnvironmentProvider, bool>(
              selector: (context, provider) => provider.isServiceOnline,
              builder: (context, isServiceOnline, child) {
                final serviceStatus = isServiceOnline ? 'ONLINE' : 'OFFLINE';
                final statusColor = isServiceOnline
                    ? Colors.green
                    : Colors.grey;

                return Row(
                  children: [
                    Icon(
                      Icons.circle_rounded,
                      size: 8,
                      color: statusColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 2.5),
                    Text(
                      'Service $serviceStatus',
                      textScaler: const TextScaler.linear(0.95),
                      style: TextStyle(
                        color: statusColor.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    }

    return AnnotatedRegion(
      value: isDarkTheme
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const PersistentAppBar(),
            AnimatedPositioned(
              height: functionalHeaderHeight,
              duration: const Duration(milliseconds: 550),
              curve: Curves.easeInOutExpo,
              top: 0,
              child: functionalHeader,
            ),
            ?debugStatus,
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class LanguageSelectDialog extends StatefulWidget {
  final Locale currentLocale;
  const LanguageSelectDialog(this.currentLocale, {super.key});

  @override
  State<LanguageSelectDialog> createState() => _LanguageSelectDialogState();
}

class _LanguageSelectDialogState extends State<LanguageSelectDialog> {
  late var selectedLocale = widget.currentLocale;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).x50PayLanguage),
      content: RadioGroup(
        groupValue: selectedLocale,
        onChanged: (value) {
          context.pop(value);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            S.delegate.supportedLocales.length,
            (index) => RadioListTile<Locale>(
              visualDensity: VisualDensity.compact,
              controlAffinity: ListTileControlAffinity.trailing,
              value: S.delegate.supportedLocales[index],
              title: Row(
                children: [
                  CountryFlag.fromCountryCode(
                    S.delegate.supportedLocales[index].countryCode ?? '',
                    theme: const ImageTheme(height: 15, width: 15),
                  ),
                  const SizedBox(width: 10),
                  Text(S.delegate.supportedLocales[index].displayText),
                ],
              ),
            ),
            growable: false,
          ),
        ),
      ),
    );
  }
}
