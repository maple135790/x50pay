// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:navigation_history_observer/navigation_history_observer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:x50pay/common/app_route.dart';
// import 'package:x50pay/common/base/base_loaded.dart';
// import 'package:x50pay/common/global_singleton.dart';
// import 'package:x50pay/common/theme/theme.dart';
// import 'package:x50pay/page/account/account.dart';
// import 'package:x50pay/page/collab/collab.dart';
// import 'package:x50pay/page/game/game.dart';
// import 'package:x50pay/page/giftSystem/gift_system.dart';
// import 'package:x50pay/page/home/home.dart';
// import 'package:x50pay/page/pages.dart';
// import 'package:x50pay/r.g.dart';

// class Root extends StatefulWidget {
//   const Root({super.key});

//   @override
//   State<Root> createState() => _RootState();
// }

// class _RootState extends State<Root> {
//   final pageController = PageController(keepPage: true, initialPage: 2);
//   int selectedMenuIndex = 2;
//   void Function()? debugFunction;
//   late final String? currentRouteName = ModalRoute.of(context)?.settings.name;
//   late ValueNotifier<int> menuIndexNotifier =
//       ValueNotifier(menus.indexWhere((menu) {
//     if (currentRouteName == '/buyMPass') return menu.routeName == AppRoute.home;
//     return menu.routeName == currentRouteName;
//   }));

//   final menus = [
//     (icon: Icons.sports_esports, label: '投幣', routeName: AppRoute.game),
//     (icon: Icons.settings, label: '設定', routeName: AppRoute.account),
//     (icon: Icons.home_rounded, label: 'Me', routeName: AppRoute.home),
//     (icon: Icons.redeem_rounded, label: '禮物', routeName: AppRoute.gift),
//     (icon: Icons.handshake_rounded, label: '合作', routeName: AppRoute.collab),
//   ];

//   final tabs = [
//     const Tab(icon: Icon(Icons.sports_esports), text: '投幣'),
//     const Tab(icon: Icon(Icons.settings), text: '設定'),
//     const Tab(icon: Icon(Icons.home_rounded), text: 'Me'),
//     const Tab(icon: Icon(Icons.redeem_rounded), text: '禮物'),
//     const Tab(icon: Icon(Icons.handshake_rounded), text: '合作'),
//   ];
//   final pages = [
//     const Game(),
//     const Account(),
//     const Home(),
//     const GiftSystem(),
//     const Collab(),
//   ];

//   Widget buildButtomNavBar(int selectedIndex) {
//     const transistionDuration = Duration(milliseconds: 250);
//     return Container(
//       decoration: const BoxDecoration(
//           border: Border(top: BorderSide(width: 1, color: Color(0xff3e3e3e)))),
//       child: NavigationBar(
//         selectedIndex: selectedIndex,
//         labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
//         onDestinationSelected: (index) async {
//           menuIndexNotifier.value = index;
//           // log('change menu: ${menus[index].label}', name: 'buildButtomNavBar');
//           // if (menus[index].routeName.isEmpty) {
//           //   Fluttertoast.showToast(msg: 'dev');
//           //   return;
//           // }
//           // selectedMenuIndex = index;
//           // await _tabNavigateTo(menus[index].routeName);
//           pageController.jumpToPage(index);
//         },
//         destinations: menus
//             .map((menu) => NavigationDestination(
//                   icon: Icon(menu.icon, color: const Color(0xffb4b4b4)),
//                   label: menu.label,
//                   selectedIcon: Icon(menu.icon, color: const Color(0xfffafafa)),
//                 ))
//             .toList(),
//       ),
//     );
//   }

//   Future _tabNavigateTo(String nextRouteName) async {
//     final nav = Navigator.of(context);
//     final val = await GlobalSingleton.instance.checkUser(force: true);
//     log('nextRoute: $nextRouteName', name: '_tabNavigateTo');
//     for (var route in NavigationHistoryObserver().history) {
//       log('name: ${route.settings.name}', name: '_tabNavigateTo');
//     }
//     if (val == false) {
//       await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
//     } else {
//       log('top: ${NavigationHistoryObserver().top!.settings.name}',
//           name: '_tabNavigateTo');

//       NavigationHistoryObserver().history.length == 3
//           ? nav.pushReplacementNamed(nextRouteName)
//           : nav.pushNamed(nextRouteName);
//     }
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   bool onScroll(Notification notification) {
//     log('scroll ${pageController.position.pixels}');
//     // log('after: ${scroll.metrics.extentAfter.toStringAsFixed(2)}',
//     //     name: 'onScroll');
//     // log('before: ${scroll.metrics.extentBefore.toStringAsFixed(2)}',
//     //     name: 'onScroll');
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: menuIndexNotifier,
//         builder: (context, selectedIndex, _) {
//           return Scaffold(
//             appBar: _LoadedAppBar(menuIndexNotifier),
//             floatingActionButton: kDebugMode && debugFunction != null
//                 ? FloatingActionButton(
//                     onPressed: debugFunction,
//                     child: const Icon(Icons.developer_mode))
//                 : null,
//             body: NotificationListener(
//                 onNotification: onScroll,
//                 child: PageView.builder(
//                   controller: pageController,
//                   itemCount: pages.length,
//                   onPageChanged: (value) {
//                     log('changed: $value', name: 'onPageChanged');
//                     menuIndexNotifier.value = value;
//                   },
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) => pages[index],
//                 )),
//             bottomNavigationBar: buildButtomNavBar(selectedIndex),
//           );
//         });
//   }
// }

// enum LoadedHeaderType {
//   fixed,
//   functional,
// }

// class _LoadedAppBar extends StatefulWidget implements PreferredSizeWidget {
//   static const double kFixedHeaderHeight = 50;
//   static const double kFunctionalHeaderHeight = 50;
//   // final LoadedHeaderType _type;
//   final ValueNotifier<int> menuIndexNotifier;

//   const _LoadedAppBar(this.menuIndexNotifier);

//   // const _LoadedAppBar.fixed()
//   //     : _type = LoadedHeaderType.fixed,
//   //       title = null,
//   //       point = 0;
//   // const _LoadedAppBar.functional({this.point = 0})
//   //     : _type = LoadedHeaderType.functional,
//   //       title = null;

//   @override
//   State<_LoadedAppBar> createState() => _LoadedAppBarState();

//   @override
//   Size get preferredSize => Size.fromHeight(kFunctionalHeaderHeight);
// }

// class _LoadedAppBarState extends State<_LoadedAppBar>
//     with TickerProviderStateMixin {
//   Widget buildFixedHeader() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           height: 50,
//           decoration: BoxDecoration(
//               color: Theme.of(context).scaffoldBackgroundColor,
//               border: const Border(
//                   bottom: BorderSide(color: Themes.borderColor, width: 1))),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                     backgroundImage: R.image.header_icon_rsz(),
//                     backgroundColor: Colors.black,
//                     radius: 14),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildFunctionalHeader() {
//     return ConstrainedBox(
//       constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
//       child: AppBar(
//         automaticallyImplyLeading: false,
//         toolbarHeight: widget.preferredSize.height,
//         elevation: 4,
//         surfaceTintColor: Colors.transparent,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         shadowColor: Colors.black54,
//         // backgroundColor: Colors.amber,
//         // shadowColor: Colors.red,

//         // decoration: BoxDecoration(
//         //     color: Theme.of(context).scaffoldBackgroundColor,
//         //     boxShadow: [
//         //       BoxShadow(
//         //           color: Colors.black.withOpacity(0.3),
//         //           spreadRadius: 5,
//         //           blurRadius: 7,
//         //           offset: const Offset(0, 3)),
//         //     ]),
//         title: Align(
//           alignment: Alignment.topRight,
//           child: Container(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 5.5, horizontal: 18),
//               decoration: BoxDecoration(
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.black54,
//                         blurRadius: 15,
//                         spreadRadius: 0.5)
//                   ],
//                   color: const Color(0xff3e3e3e),
//                   borderRadius: BorderRadius.circular(5)),
//               child: Text('$point P',
//                   style: TextStyle(
//                     fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
//                     color: const Color(0xfffafafa),
//                     fontWeight: FontWeight.bold,
//                   ))),
//         ),
//         actions: [
//           InkWell(
//               onTap: () async {
//                 var status = await Permission.camera.status;
//                 if (status.isDenied) await Permission.camera.request();

//                 if (context.mounted) {
//                   showDialog(
//                       context: context,
//                       builder: (context) =>
//                           ScanQRCode(status == PermissionStatus.granted));
//                 }
//               },
//               splashFactory: NoSplash.splashFactory,
//               child: const Icon(Icons.qr_code,
//                   size: 28, color: Color(0xfffafafa))),
//           const SizedBox(width: 15),
//         ],
//         // child: Padding(
//         //   padding: const EdgeInsets.symmetric(vertical: 5),
//         //   child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//         //     const SizedBox(width: 15),
//         //     const Spacer(),
//         //     Container(
//         //         padding:
//         //             const EdgeInsets.symmetric(vertical: 5.5, horizontal: 18),
//         //         decoration: BoxDecoration(
//         //             boxShadow: const [
//         //               BoxShadow(
//         //                   color: Colors.black54,
//         //                   blurRadius: 15,
//         //                   spreadRadius: 0.5)
//         //             ],
//         //             color: const Color(0xff3e3e3e),
//         //             borderRadius: BorderRadius.circular(5)),
//         //         child: Text('$point P',
//         //             style: const TextStyle(
//         //                 color: Color(0xfffafafa), fontWeight: FontWeight.bold))),
//         //     const SizedBox(width: 20),
//         //     Padding(
//         //       padding: const EdgeInsets.all(5),
//         //       child: InkWell(
//         //           onTap: () async {
//         //             var status = await Permission.camera.status;
//         //             if (status.isDenied) await Permission.camera.request();

//         //             if (context.mounted) {
//         //               showDialog(
//         //                   context: context,
//         //                   builder: (context) =>
//         //                       ScanQRCode(status == PermissionStatus.granted));
//         //             }
//         //           },
//         //           splashFactory: NoSplash.splashFactory,
//         //           child: const Icon(Icons.qr_code,
//         //               size: 28, color: Color(0xfffafafa))),
//         //     ),
//         //     const SizedBox(width: 15),
//         //   ]),
//         // ),
//       ),
//     );
//   }

//   int? get point => GlobalSingleton.instance.user?.point?.toInt();

//   double getFunctionalHeaderHeight(int menuIndex) =>
//       menuIndex == 2 ? 0 : widget.preferredSize.height + 2;
//   // double getFunctionalHeaderPos(int menuIndex)=>

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion(
//       value: SystemUiOverlayStyle.light,
//       child: ValueListenableBuilder(
//         valueListenable: widget.menuIndexNotifier,
//         child: buildFixedHeader(),
//         builder: (context, menuIndex, child) {
//           return SafeArea(
//             child: SizedBox(
//               child: Container(
//                 color: Colors.blue,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     child!,
//                     AnimatedPositioned(
//                       height: getFunctionalHeaderHeight(menuIndex),
//                       duration: const Duration(milliseconds: 200),
//                       curve: Curves.easeInOutExpo,
//                       // top: getFunctionalHeaderPos(menuIndex),
//                       top: 0,
//                       child: buildFunctionalHeader(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//     // switch (widget._type) {
//     //   case LoadedHeaderType.fixed:
//     //     return Container(
//     //       decoration: BoxDecoration(
//     //           color: Theme.of(context).scaffoldBackgroundColor,
//     //           border: const Border(
//     //               bottom: BorderSide(color: Themes.borderColor, width: 1))),
//     //       child: Padding(
//     //         padding: const EdgeInsets.symmetric(vertical: 5),
//     //         child: Row(
//     //           mainAxisAlignment: MainAxisAlignment.center,
//     //           children: [
//     //             CircleAvatar(
//     //                 backgroundImage: R.image.header_icon_rsz(),
//     //                 backgroundColor: Colors.black,
//     //                 radius: 14),
//     //           ],
//     //         ),
//     //       ),
//     //     );
//     //   case LoadedHeaderType.functional:
//     //     return Container(
//     //       decoration: BoxDecoration(
//     //           color: Theme.of(context).scaffoldBackgroundColor,
//     //           boxShadow: [
//     //             BoxShadow(
//     //                 color: Colors.black.withOpacity(0.3),
//     //                 spreadRadius: 5,
//     //                 blurRadius: 7,
//     //                 offset: const Offset(0, 3)),
//     //           ]),
//     //       child: Padding(
//     //         padding: const EdgeInsets.symmetric(vertical: 5),
//     //         child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//     //           const SizedBox(width: 15),
//     //           // Padding(
//     //           //   padding: const EdgeInsets.all(5),
//     //           //   child: InkWell(
//     //           //       onTap: () {
//     //           //         Navigator.of(context).pop();
//     //           //       },
//     //           //       splashFactory: NoSplash.splashFactory,
//     //           //       child: const Icon(Icons.chevron_left_outlined, size: 25, color: Color(0xfffafafa))),
//     //           // ),
//     //           const Spacer(),
//     //           Container(
//     //               padding:
//     //                   const EdgeInsets.symmetric(vertical: 5.5, horizontal: 18),
//     //               decoration: BoxDecoration(
//     //                   boxShadow: const [
//     //                     BoxShadow(
//     //                         color: Colors.black54,
//     //                         blurRadius: 15,
//     //                         spreadRadius: 0.5)
//     //                   ],
//     //                   color: const Color(0xff3e3e3e),
//     //                   borderRadius: BorderRadius.circular(5)),
//     //               child: Text('$point P',
//     //                   style: const TextStyle(
//     //                       color: Color(0xfffafafa),
//     //                       fontWeight: FontWeight.bold))),
//     //           const SizedBox(width: 20),
//     //           Padding(
//     //             padding: const EdgeInsets.all(5),
//     //             child: InkWell(
//     //                 onTap: () async {
//     //                   var status = await Permission.camera.status;
//     //                   if (status.isDenied) await Permission.camera.request();

//     //                   if (context.mounted) {
//     //                     showDialog(
//     //                         context: context,
//     //                         builder: (context) =>
//     //                             ScanQRCode(status == PermissionStatus.granted));
//     //                   }
//     //                 },
//     //                 splashFactory: NoSplash.splashFactory,
//     //                 child: const Icon(Icons.qr_code,
//     //                     size: 28, color: Color(0xfffafafa))),
//     //           ),
//     //           const SizedBox(width: 15),
//     //         ]),
//     //       ),
//     //     );
//     // }
//   }
// }
