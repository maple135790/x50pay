import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/base/base_view_model.dart';
import 'package:x50pay/r.g.dart';

mixin BasePage<T extends StatefulWidget> on BaseStatefulState<T> {
  BaseViewModel? baseViewModel();
  Widget body();
  HeaderType headerType = HeaderType.normal;
  bool isShowFooter = false;
  bool isHeaderBackType = false;
  String? floatHeaderText;

  @override
  Widget build(BuildContext context) {
    if (baseViewModel() != null) {
      headerType = baseViewModel()!.isFloatHeader ? HeaderType.float : HeaderType.normal;
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                color: const Color(0xfffafafa),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    children: [
                      headerType == HeaderType.normal
                          ? const _Header()
                          : _Header.float(isBackType: isHeaderBackType, title: floatHeaderText),
                      body(),
                      isShowFooter
                          ? const Padding(padding: EdgeInsets.all(30), child: _Footer())
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

class _Header extends StatelessWidget {
  final HeaderType _type;
  final bool isBackType;
  final String? title;
  const _Header({Key? key})
      : _type = HeaderType.normal,
        isBackType = false,
        title = null,
        super(key: key);

  const _Header.float({Key? key, required this.isBackType, this.title})
      : _type = HeaderType.float,
        assert(isBackType != false || title != null, 'floatHeaderText must be set'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case HeaderType.normal:
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    backgroundImage: R.image.header_icon(), backgroundColor: const Color(0xff5a5a5a)),
                const SizedBox(width: 10),
                const Text('X50 Music Game Station'),
              ],
            ),
          ),
        );
      case HeaderType.float:
        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 1,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: isBackType
                  ? [
                      const SizedBox(width: 15),
                      Container(
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffdfdfdf)),
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child:
                                const Icon(Icons.chevron_left_outlined, size: 25, color: Color(0xff5a5a5a))),
                      ),
                      const SizedBox(width: 10),
                    ]
                  : [
                      const SizedBox(width: 15),
                      CircleAvatar(
                          backgroundImage: R.image.header_icon(), backgroundColor: const Color(0xff5a5a5a)),
                      const SizedBox(width: 10),
                      Text(title == '' ? 'X50 Pay' : 'X50 Pay - $title'),
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
            text: TextSpan(text: 'Copyright © ', style: const TextStyle(color: Color(0xff919191)), children: [
          TextSpan(
              text: 'X50 Music Game Station',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'pay@x50.fun');
                  launchUrl(emailLaunchUri);
                })
        ])),
        const SizedBox(height: 10),
        RichText(
            text: TextSpan(text: '如使用本平台視為同意', style: const TextStyle(color: Color(0xff919191)), children: [
          TextSpan(
              text: '平台使用條款',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushNamed(AppRoute.license);
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
