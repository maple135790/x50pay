// import 'dart:developer';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import 'package:x50pay/common/app_route.dart';
// import 'package:x50pay/common/base/base.dart';
// import 'package:x50pay/common/global_singleton.dart';
// import 'package:x50pay/common/models/cabinet/cabinet.dart';
// import 'package:x50pay/common/models/gamelist/gamelist.dart';
// import 'package:x50pay/common/models/store/store.dart';
// import 'package:x50pay/common/theme/theme.dart';
// import 'package:x50pay/page/game/cab_detail_view_model.dart';
// import 'package:x50pay/page/game/game_mixin.dart';
// import 'package:x50pay/page/game/game_view_model.dart';

// part 'cab_detail.dart';

// class Game extends StatefulWidget {
//   const Game({Key? key}) : super(key: key);

//   @override
//   State<Game> createState() => _GameState();
// }

// class _GameState extends BaseStatefulState<Game> {
//   final viewModel = GameViewModel();
//   late Future<StoreModel?> _getStoreData;
//   late Future<void> init;

//   @override
//   void didChangeDependencies() async {
//     super.didChangeDependencies();
//     await GlobalSingleton.instance.checkUser(force: false);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getStoreData = viewModel.getStoreData();
//   }

//   @override
//   void dispose() {
//     log('Game disposed', name: 'game');
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: viewModel.hasRecentStore(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const SizedBox();
//         }
//         if (snapshot.data == true) {
//           return loadGamelist();
//         } else {
//           return loadGameStore();
//         }
//       },
//     );
//   }

//   FutureBuilder<StoreModel?> loadGameStore() {
//     return FutureBuilder<StoreModel?>(
//       future: _getStoreData,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState != ConnectionState.done) {
//           return const Text(kDebugMode ? 'loading...' : '');
//         }
//         if (snapshot.data == null) return const Text('failed');

//         return _GameStoreLoaded(snapshot.data!);
//       },
//     );
//   }

//   FutureBuilder<GameList?> loadGamelist() {
//     return FutureBuilder<GameList?>(
//         future: viewModel.getGamelist(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.done) {
//             return const SizedBox();
//           }
//           if (snapshot.data == null) {
//             return const SizedBox(child: Text('failed'));
//           } else {
//             return GameCabs(
//               games: snapshot.data!,
//               storeName: viewModel.storeName!,
//             );
//           }
//         });
//   }
// }

// class _GameStoreLoaded extends StatelessWidget {
//   final StoreModel stores;
//   const _GameStoreLoaded(this.stores, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<Storelist> storeList = stores.storelist!;

//     return SingleChildScrollView(
//       child: Column(
//         children: storeList.map((e) => _StoreItem(e, stores.prefix!)).toList(),
//       ),
//     );
//   }
// }

// class _StoreItem extends StatelessWidget {
//   final Storelist store;
//   final String prefix;
//   const _StoreItem(this.store, this.prefix, {Key? key}) : super(key: key);

//   ImageProvider _getStoreImage(int storeId, {bool isOnline = false}) {
//     return CachedNetworkImageProvider(
//         "https://pay.x50.fun/static/storesimg/$storeId.jpg?v1.2");
//   }

//   void onStoreSelected(GoRouter router) async {
//     await SharedPreferences.getInstance()
//       ..setString('store_name', store.name!)
//       ..setString('store_id', prefix + (store.sid!.toString()));
//     await EasyLoading.showInfo('已切換至${store.name}\n\n少女祈禱中...',
//         duration: const Duration(seconds: 2));
//     await Future.delayed(const Duration(seconds: 2));
//     router.goNamed(
//       AppRoutes.game.routeName,
//       extra: true,
//     );
//     return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//           border: Border.all(color: Themes.borderColor),
//           borderRadius: BorderRadius.circular(5)),
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.5),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(5),
//         child: GestureDetector(
//           onTap: () {
//             final router = GoRouter.of(context);
//             onStoreSelected(router);
//           },
//           child: SizedBox(
//             width: double.infinity,
//             height: 180,
//             child: Stack(
//               children: [
//                 Positioned(
//                     width: 400,
//                     top: -100,
//                     child: Image(
//                       image: _getStoreImage(store.sid!,
//                           isOnline: GlobalSingleton.instance.isServiceOnline),
//                       fit: BoxFit.fitWidth,
//                       colorBlendMode: BlendMode.modulate,
//                     )),
//                 Positioned.fill(
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                           colors: [Colors.transparent, Colors.black54],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           stops: [0.1, 1]),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   left: 15,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(store.name!,
//                           style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               shadows: [
//                                 Shadow(color: Colors.black, blurRadius: 18)
//                               ])),
//                       Row(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             const Icon(Icons.near_me,
//                                 size: 15, color: Color(0xe6ffffff)),
//                             Text('  | ${store.address!}',
//                                 style: const TextStyle(
//                                     color: Color(0xffbcbfbf),
//                                     fontSize: 13,
//                                     shadows: [
//                                       Shadow(
//                                           color: Colors.black, blurRadius: 15)
//                                     ]))
//                           ]),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
