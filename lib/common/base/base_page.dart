import 'package:country_flags/country_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/providers/language_provider.dart';
import 'package:x50pay/providers/theme_provider.dart';
import 'package:x50pay/r.g.dart';

mixin BasePage<T extends StatefulWidget> on BaseStatefulState<T> {
  BaseViewModel? baseViewModel();
  Widget body();
  bool isShowFooter = false;
  void Function()? debugFunction;

  @override
  Widget build(BuildContext context) {
    if (baseViewModel() != null) {
      isShowFooter = baseViewModel()!.isShowFooter;
    }

    return ChangeNotifierProvider.value(
      value: baseViewModel(),
      builder: (context, _) => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          floatingActionButton: kDebugMode && debugFunction != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                        onPressed: debugFunction,
                        child: const Icon(Icons.developer_mode)),
                    FloatingActionButton(
                      child: const Icon(Icons.brightness_6_rounded),
                      onPressed: () {
                        Theme.of(context).brightness == Brightness.dark
                            ? context
                                .read<AppThemeProvider>()
                                .changeBrightness(Brightness.light)
                            : context
                                .read<AppThemeProvider>()
                                .changeBrightness(Brightness.dark);
                      },
                    )
                  ],
                )
              : null,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      _Header(),
                      body(),
                      isShowFooter
                          ? const Padding(
                              padding: EdgeInsets.all(30), child: _Footer())
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header();

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends BaseStatefulState<_Header> {
  Widget buildDebugStatus() {
    String serviceStatus =
        GlobalSingleton.instance.isServiceOnline ? 'ONLINE' : 'OFFLINE';
    Color statusColor = serviceStatus == 'ONLINE' ? Colors.green : Colors.grey;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(GlobalSingleton.instance.appVersion,
              textScaler: const TextScaler.linear(0.95),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.color
                    ?.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              )),
          Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: statusColor.withOpacity(0.5),
              ),
              const SizedBox(width: 2.5),
              Text(
                'Service $serviceStatus',
                textScaler: const TextScaler.linear(0.95),
                style: TextStyle(
                  color: statusColor.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void onLanguagePressed(Locale currentLocale) async {
    final changedLocale = await showDialog<Locale>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).x50PayLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            S.delegate.supportedLocales.length,
            (index) => RadioListTile<Locale>(
              controlAffinity: ListTileControlAffinity.trailing,
              value: S.delegate.supportedLocales[index],
              visualDensity: VisualDensity.compact,
              title: Row(
                children: [
                  CountryFlag.fromCountryCode(
                    S.delegate.supportedLocales[index].countryCode ?? '',
                    height: 25,
                    width: 25,
                  ),
                  const SizedBox(width: 10),
                  Text(S.delegate.supportedLocales[index].displayText),
                ],
              ),
              groupValue: currentLocale,
              onChanged: (value) {
                context.pop(value);
              },
            ),
            growable: false,
          ),
        ),
      ),
    );
    if (changedLocale == null) return;
    if (!mounted) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      context.read<LanguageProvider>().setUserPrefLocale(changedLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value:
          isDarkTheme ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Stack(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border:
                    Border(bottom: BorderSide(color: borderColor, width: 1))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Center(
                    child: CircleAvatar(
                        backgroundImage: R.image.header_icon_rsz(),
                        backgroundColor: Colors.black,
                        radius: 14),
                  ),
                  Expanded(
                    flex: 1,
                    child: Consumer<LanguageProvider>(
                      builder: (context, vm, child) => Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            onLanguagePressed(vm.currentLocale);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 6.75,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkTheme
                                      ? CustomColorThemes.appbarBoxColorDark
                                      : CustomColorThemes.appbarBoxColorLight,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CountryFlag.fromCountryCode(
                                      vm.currentLocale.countryCode ?? '',
                                      height: 15,
                                      width: 15,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      vm.currentLocale.displayText,
                                      textScaler: const TextScaler.linear(0.85),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (kDebugMode) buildDebugStatus(),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
            text: TextSpan(
                text: 'Copyright © ',
                style: const TextStyle(color: Color(0xff919191)),
                children: [
              TextSpan(
                  text: 'X50 Music Game Station',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      final Uri emailLaunchUri =
                          Uri(scheme: 'mailto', path: 'pay@x50.fun');
                      launchUrl(emailLaunchUri,
                          mode: LaunchMode.externalApplication);
                    })
            ])),
        const SizedBox(height: 10),
        RichText(
            text: TextSpan(
                text: '如使用本平台視為同意',
                style: const TextStyle(color: Color(0xff919191)),
                children: [
              TextSpan(
                  text: '平台使用條款',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      context.pushNamed(AppRoutes.license.routeName);
                    })
            ]))
      ],
    );
  }
}

enum HeaderType {
  normal,
  float,
}
