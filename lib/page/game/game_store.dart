// part of "game.dart";

// class GameStore extends StatelessWidget {
//   final StoreModel stores;
//   const GameStore({super.key, required this.stores});

//   @override
//   Widget build(BuildContext context) {
//     final List<Storelist> storeList = stores.storelist!;

//     return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: storeList.length,
//       shrinkWrap: true,
//       itemBuilder: (context, index) =>
//           _StoreItem(storeList[index], stores.prefix!),
//     );
//   }
// }

// class _StoreItem extends StatelessWidget {
//   final Storelist store;
//   final String prefix;
//   const _StoreItem(this.store, this.prefix, {Key? key}) : super(key: key);

//   ImageProvider _getStoreImage(int storeId, {bool isOnline = false}) {
//     late _X50Store store;

//     if (isOnline) {
//       return NetworkImage(
//           "https://pay.x50.fun/static/storesimg/$storeId.jpg?v1.2");
//     }
//     for (var s in _X50Store.values) {
//       if (s.sid == storeId) {
//         store = s;
//         break;
//       }
//     }

//     switch (store) {
//       case _X50Store.ximen1:
//         return R.image.a37656_jpg();
//       case _X50Store.shilin:
//         return R.image.a37657_jpg();
//       case _X50Store.ximen2:
//         return R.image.a37658_jpg();
//     }
//   }

//   void onStoreSelected(GoRouter router) async {
//     await SharedPreferences.getInstance()
//       ..setString('store_name', store.name!)
//       ..setString('store_id', prefix + (store.sid!.toString()));
//     await EasyLoading.showInfo('已切換至${store.name}\n\n少女祈禱中...',
//         duration: const Duration(seconds: 2));
//     await Future.delayed(const Duration(seconds: 2));
//     final gameList = await GameViewModel().getGamelist();
//     router.goNamed(
//       AppRoutes.gameCabs.routeName,
//       pathParameters: {'storeName': store.name!},
//       extra: gameList,
//     );
//     // Navigator.of(context).pushReplacement(
//     // CupertinoPageRoute(builder: (context) => const Game()));
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
//                           isOnline:
//                               GlobalSingleton.instance.devIsServiceOnline),
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
