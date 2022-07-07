import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

part "../../page/scan/scan.dart";

mixin BaseLoaded<T extends StatefulWidget> on BaseStatefulState<T> {
  List<String> routeStack = [];
  BaseViewModel? baseViewModel();
  String? subPageOf;
  bool disableBottomNavigationBar = false;
  Widget body();
  LoadedHeaderType headerType = LoadedHeaderType.normal;
  Color? customBackgroundColor;
  int? point;

  @override
  void initState() {
    super.initState();
    routeStack.add(AppRoute.home);
  }

  Future _tabNavigateTo(String nextRouteName) async {
    if (NavigationHistoryObserver().top!.settings.name == nextRouteName) {
      setState(() {});
    } else {
      final nav = Navigator.of(context);
      await _intentedDelay();
      NavigationHistoryObserver().history.length == 3
          ? nav.pushReplacementNamed(nextRouteName)
          : nav.pushNamed(nextRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentPage = subPageOf ??= ModalRoute.of(context)?.settings.name?.split('/').last;
    if (baseViewModel() != null) {
      headerType =
          baseViewModel()!.isFunctionalHeader ? LoadedHeaderType.functional : LoadedHeaderType.normal;
      point = GlobalSingleton.instance.user?.point?.toInt();
      if (kDebugMode) {
        // print("user.toString()   ${GlobalSingleton.instance.user.toString()}");
      }
    }
    return ChangeNotifierProvider.value(
      value: baseViewModel(),
      builder: (context, _) => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: Scaffold(
            body: Scrollbar(
              child: SingleChildScrollView(
                  child: Container(
                      color: customBackgroundColor ?? const Color(0xfffafafa),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Column(
                          children: [
                            headerType == LoadedHeaderType.normal
                                ? const _LoadedHeader()
                                : _LoadedHeader.functional(point: point ?? -87),
                            body(),
                            const SizedBox(height: 20)
                          ],
                        ),
                      ))),
            ),
            bottomNavigationBar: !disableBottomNavigationBar
                ? Container(
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffe9e9e9), width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Material(
                            color: currentPage == 'home' ? const Color(0xfff0f0f0) : Colors.white,
                            child: InkWell(
                              onTap: () async {
                                if (NavigationHistoryObserver().top!.settings.name == AppRoute.home) {
                                  setState(() {});
                                } else {
                                  final nav = Navigator.of(context);
                                  await _intentedDelay();
                                  nav.popUntil(ModalRoute.withName(AppRoute.home));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.home, color: Color(0xff404040)),
                                    SizedBox(height: 5),
                                    Text('首頁', style: TextStyle(color: Color(0xff404040), fontSize: 10))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: currentPage == 'game' ? const Color(0xfff0f0f0) : Colors.white,
                            child: InkWell(
                              onTap: () async {
                                await _tabNavigateTo(AppRoute.game);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.sports_esports, color: Color(0xff404040)),
                                    SizedBox(height: 5),
                                    Text('遊玩系統', style: TextStyle(color: Color(0xff404040), fontSize: 10))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: currentPage == 'account' ? const Color(0xfff0f0f0) : Colors.white,
                            child: InkWell(
                              onTap: () async {
                                await _tabNavigateTo(AppRoute.account);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.person, color: Color(0xff404040)),
                                    SizedBox(height: 5),
                                    Text('會員中心', style: TextStyle(color: Color(0xff404040), fontSize: 10))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: currentPage == 'gift' ? const Color(0xfff0f0f0) : Colors.white,
                            child: InkWell(
                              onTap: () {
                                if (ModalRoute.of(context)!.settings.name != AppRoute.home) {
                                  Navigator.of(context).pushNamed(AppRoute.home);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.redeem_rounded, color: Color(0xff404040)),
                                    SizedBox(height: 5),
                                    Text('禮物盒子', style: TextStyle(color: Color(0xff404040), fontSize: 10))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Future<void> _intentedDelay() async {
    await EasyLoading.show();
    await Future.delayed(const Duration(milliseconds: 200));
    await EasyLoading.dismiss();
  }
}

class _LoadedHeader extends StatelessWidget {
  final LoadedHeaderType _type;
  final String? title;
  final int point;
  const _LoadedHeader({Key? key})
      : _type = LoadedHeaderType.normal,
        title = null,
        point = 0,
        super(key: key);
  const _LoadedHeader.functional({Key? key, this.point = 0})
      : _type = LoadedHeaderType.functional,
        title = null,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case LoadedHeaderType.normal:
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
      case LoadedHeaderType.functional:
        return Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(width: 15),
              Container(
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.chevron_left_outlined, size: 25, color: Color(0xff5a5a5a))),
              ),
              const Spacer(),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.5, horizontal: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: const Color(0xfff4f4f4)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('$point P',
                      style: const TextStyle(color: Color(0xff5a5a5a), fontWeight: FontWeight.bold))),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(NoTransitionRouter(const ScanQRCode()));
                  },
                  icon: const Icon(Icons.qr_code, size: 28),
                  color: const Color(0xff7b7b7b)),
            ]),
          ),
        );
    }
  }
}

enum LoadedHeaderType {
  normal,
  functional,
}
