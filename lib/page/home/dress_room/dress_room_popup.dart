// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:x50pay/page/home/dress_room/dress_room_view_model.dart';

// typedef Avatar = ({String b64Image, String? id, String badgeText});

// class DressRoomPopup extends StatefulWidget {
//   const DressRoomPopup({super.key});

//   @override
//   State<DressRoomPopup> createState() => _DressRoomPopupState();
// }

// class _DressRoomPopupState extends State<DressRoomPopup> {
//   final viewModel = DressRoomViewModel();
//   late Future<List<Avatar>> initDressRoom;

//   @override
//   void initState() {
//     super.initState();
//     initDressRoom = viewModel.init();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//       contentPadding: EdgeInsets.zero,
//       scrollable: true,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
//               child: Row(children: [
//                 const Text('更換角色/衣裝'),
//                 const Spacer(),
//                 GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Icon(Icons.cancel,
//                         color: Color(0xfffafafa), size: 20))
//               ])),
//           const Divider(height: 0),
//           SizedBox(
//             width: 350,
//             height: 548,
//             child: Padding(
//               padding: const EdgeInsets.all(15),
//               child: FutureBuilder(
//                   future: initDressRoom,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState != ConnectionState.done) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     final avatars = snapshot.data!;
//                     return GridView.builder(
//                       itemCount: avatars.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               childAspectRatio: 106 / 150,
//                               crossAxisSpacing: 18,
//                               mainAxisSpacing: 12),
//                       itemBuilder: (context, index) => DressedAvatar(
//                         id: avatars[index].id,
//                         imageSrc: avatars[index].b64Image,
//                         amount: avatars[index].badgeText,
//                         onTap: viewModel.setAvatar,
//                       ),
//                     );
//                   }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DressedAvatar extends StatefulWidget {
//   final String? id;
//   final String imageSrc;
//   final String amount;
//   final Future<String> Function(String id) onTap;

//   const DressedAvatar(
//       {super.key,
//       required this.id,
//       required this.imageSrc,
//       required this.amount,
//       required this.onTap});

//   @override
//   State<DressedAvatar> createState() => _DressedAvatarState();
// }

// class _DressedAvatarState extends State<DressedAvatar> {
//   bool get isChangable => widget.id != null;

//   void doChangeAvatar() async {
//     final data = await widget.onTap.call(widget.id!);
//     Fluttertoast.showToast(
//         msg: data,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isChangable ? doChangeAvatar : null,
//       child: Container(
//         color: Colors.grey,
//         child: Image.memory(
//           base64Decode(widget.imageSrc),
//           opacity: isChangable ? null : const AlwaysStoppedAnimation(0.5),
//           color: isChangable ? null : Colors.grey,
//           colorBlendMode: isChangable ? null : BlendMode.saturation,
//         ),
//       ),
//     );
//   }
// }
