import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/extensions/locale_ext.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/language_view_model.dart';
import 'package:x50pay/r.g.dart';

mixin BasePage<T extends StatefulWidget> on BaseStatefulState<T> {
  BaseViewModel? baseViewModel();
  Widget body();
  HeaderType headerType = HeaderType.normal;
  bool isShowFooter = false;
  bool isHeaderBackType = false;
  String? floatHeaderText;
  bool isDarkHeader = false;
  void Function()? debugFunction;

  @override
  Widget build(BuildContext context) {
    if (baseViewModel() != null) {
      headerType =
          baseViewModel()!.isFloatHeader ? HeaderType.float : HeaderType.normal;
      isShowFooter = baseViewModel()!.isShowFooter;
      isHeaderBackType = baseViewModel()!.isHeaderBackType;
      floatHeaderText = baseViewModel()!.floatHeaderText;
    }

    return ChangeNotifierProvider.value(
      value: baseViewModel(),
      builder: (context, _) => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          floatingActionButton: kDebugMode && debugFunction != null
              ? FloatingActionButton(
                  onPressed: debugFunction,
                  child: const Icon(Icons.developer_mode))
              : null,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      headerType == HeaderType.normal
                          ? _Header(isDark: isDarkHeader)
                          : _Header.float(
                              isBackType: isHeaderBackType,
                              title: floatHeaderText,
                              isDark: isDarkHeader),
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
  final HeaderType _type;
  final bool isDark;
  final bool isBackType;
  final String? title;
  const _Header({Key? key, this.isDark = false})
      : _type = HeaderType.normal,
        isBackType = false,
        title = null,
        super(key: key);

  const _Header.float(
      {Key? key, required this.isBackType, this.title, this.isDark = false})
      : _type = HeaderType.float,
        assert(isBackType != false || title != null,
            'floatHeaderText must be set'),
        super(key: key);

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  String get _title => 'X50 Pay - ${widget.title}';
  late final currentLocale = context.read<LanguageViewModel>().currentLocale;

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
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.5),
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

  Widget buildFixedHeader() {
    return Stack(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(
                  bottom: BorderSide(color: Themes.borderColor, width: 1))),
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
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onLanguagePressed,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 6.75,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff2a2a2a),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(currentLocale.displayText)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        buildDebugStatus(),
      ],
    );
  }

  void onLanguagePressed() async {
    final changedLocale = await showDialog<Locale>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text(S.of(context).x50PayLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              S.delegate.supportedLocales.length,
              (index) => RadioListTile<Locale>(
                value: S.delegate.supportedLocales[index],
                title: Text(S.delegate.supportedLocales[index].displayText),
                groupValue: currentLocale,
                onChanged: (value) {
                  context.pop(value);
                },
              ),
              growable: false,
            ),
          ),
        );
      }),
    );
    if (changedLocale == null) return;
    if (!mounted) return;
    EasyLoading.show();
    Future.delayed(const Duration(milliseconds: 800), () {
      EasyLoading.dismiss();
      context.read<LanguageViewModel>().setUserPrefLocale(changedLocale);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget._type) {
      case HeaderType.normal:
        return buildFixedHeader();
      case HeaderType.float:
        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 1,
          color: const Color(0xff1e1e1e),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: widget.isBackType
                  ? [
                      const SizedBox(width: 15),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xffdfdfdf)),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(Icons.chevron_left_outlined,
                                size: 25, color: Color(0xff5a5a5a))),
                      ),
                      const SizedBox(width: 10),
                    ]
                  : [
                      const SizedBox(width: 15),
                      CircleAvatar(
                          backgroundImage: R.image.header_icon_rsz(),
                          backgroundColor: const Color(0xff5a5a5a)),
                      const SizedBox(width: 15),
                      Text(_title),
                    ],
            ),
          ),
        );
    }
  }
}

class _Footer extends StatelessWidget {
  const _Footer({Key? key}) : super(key: key);

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
