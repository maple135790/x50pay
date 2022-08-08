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
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

part "../../page/scan/scan.dart";

mixin BaseLoaded<T extends StatefulWidget> on BaseStatefulState<T> {
  BaseViewModel? baseViewModel();
  String? subPageOf;
  bool disableBottomNavigationBar = false;
  Widget body();
  LoadedHeaderType headerType = LoadedHeaderType.normal;
  bool isScrollable = true;
  void Function()? debugFunction;
  Color? customBackgroundColor;
  int? point;

  @override
  void initState() {
    super.initState();
  }

  Future _tabNavigateTo(String nextRouteName) async {
    final nav = Navigator.of(context);
    final val = await GlobalSingleton.instance.checkUser(force: true);
    if (val == false) {
      await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
    } else {
      if (NavigationHistoryObserver().top!.settings.name == nextRouteName) {
        setState(() {});
      } else {
        await _intentedDelay();
        NavigationHistoryObserver().history.length == 3
            ? nav.pushReplacementNamed(nextRouteName)
            : nav.pushNamed(nextRouteName);
      }
    }
  }

  Future<void> checkUser() async {
    final val = await GlobalSingleton.instance.checkUser(force: true);
    if (val == false) {
      await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = customBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor;
    String? currentPage = subPageOf ??= ModalRoute.of(context)?.settings.name?.split('/').last;
    Color pressedColor(String tabName) {
      if (currentPage == tabName) return const Color(0xfffafafa);
      return const Color(0xffb4b4b4);
    }

    if (baseViewModel() != null) {
      headerType =
          baseViewModel()!.isFunctionalHeader ? LoadedHeaderType.functional : LoadedHeaderType.normal;
      point = GlobalSingleton.instance.user?.point?.toInt();
    }
    return ChangeNotifierProvider.value(
      value: baseViewModel(),
      builder: (context, _) => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          floatingActionButton: kDebugMode && debugFunction != null
              ? FloatingActionButton(onPressed: debugFunction, child: const Icon(Icons.developer_mode))
              : null,
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await GlobalSingleton.instance.checkUser(force: true);
                setState(() {});
              },
              child: isScrollable
                  ? Scrollbar(
                      child: SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.topCenter,
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
                          ),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Column(
                          children: [
                            headerType == LoadedHeaderType.normal
                                ? const _LoadedHeader()
                                : _LoadedHeader.functional(point: point ?? -87),
                            Expanded(child: body()),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
          bottomNavigationBar: !disableBottomNavigationBar
              ? Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: const Color(0xff3e3e3e), width: 1), boxShadow: [
                    BoxShadow(
                        color: Colors.black87.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 7,
                        offset: const Offset(0, 3)),
                  ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Material(
                          color: backgroundColor,
                          child: InkWell(
                            onTap: () async {
                              final nav = Navigator.of(context);
                              await checkUser();
                              if (NavigationHistoryObserver().top!.settings.name == AppRoute.home) {
                                setState(() {});
                              } else {
                                await _intentedDelay();
                                nav.popUntil(ModalRoute.withName(AppRoute.home));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.home, color: pressedColor('home')),
                                  Text('首頁', style: TextStyle(color: pressedColor('home'), fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: backgroundColor,
                          child: InkWell(
                            onTap: () async {
                              await _tabNavigateTo(AppRoute.game);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.videogame_asset_rounded, color: pressedColor('game')),
                                  Text('遊玩系統', style: TextStyle(color: pressedColor('game'), fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: backgroundColor,
                          child: InkWell(
                            onTap: () async {
                              await _tabNavigateTo(AppRoute.account);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, color: pressedColor('account')),
                                  Text('會員中心', style: TextStyle(color: pressedColor('account'), fontSize: 12))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: backgroundColor,
                          child: InkWell(
                            onTap: () async {
                              // if (ModalRoute.of(context)!.settings.name != AppRoute.home) {
                              //   Navigator.of(context).pushNamed(AppRoute.home);
                              // }
                              await _tabNavigateTo(AppRoute.gift);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.redeem_rounded, color: pressedColor('gift')),
                                  Text('禮物盒子', style: TextStyle(color: pressedColor('gift'), fontSize: 12))
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
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                    backgroundImage: R.image.header_icon_rsz(), backgroundColor: Colors.black, radius: 14),
                const SizedBox(width: 10),
                const Text('X50Pay'),
              ],
            ),
          ),
        );
      case LoadedHeaderType.functional:
        return Container(
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.3),
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
                    child: const Icon(Icons.chevron_left_outlined, size: 25, color: Color(0xfffafafa))),
              ),
              const Spacer(),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.5, horizontal: 18),
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15, spreadRadius: 0.5)],
                      color: const Color(0xff3e3e3e),
                      // border: Border.all(width: 1, color: const Color(0xff3e3e3e)),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('$point P',
                      style: const TextStyle(color: Color(0xfffafafa), fontWeight: FontWeight.bold))),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () {
                    // Navigator.of(context).push(NoTransitionRouter(const ScanQRCodeV2()));
                  },
                  icon: const Icon(Icons.qr_code, size: 28),
                  color: const Color(0xfffafafa)),
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
