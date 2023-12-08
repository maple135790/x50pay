import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/home/dress_room/dress_room_view_model.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/repository/repository.dart';

typedef Avatar = ({String b64Image, String? id, String badgeText});

class DressRoom extends StatefulWidget {
  const DressRoom({super.key});

  @override
  State<DressRoom> createState() => _DressRoomState();
}

class _DressRoomState extends BaseStatefulState<DressRoom> {
  final repo = Repository();
  late final viewModel = DressRoomViewModel(repository: repo);
  String? selectedAvater;
  late Future<List<Avatar>> initDressRoom;

  @override
  void initState() {
    super.initState();
    initDressRoom = viewModel.getAvatars();
  }

  void onDressPressed(String? id) {
    if (id == null) return;
    if (selectedAvater == id) {
      selectedAvater = null;
    } else {
      selectedAvater = id;
    }
    setState(() {});
  }

  void onConfirm() async {
    assert(selectedAvater != null,
        'selectedAvater should be selected before confirm');
    final nav = GoRouter.of(context);
    final data = await viewModel.setAvatar(selectedAvater!);
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    nav.goNamed(AppRoutes.home.routeName, extra: true);
  }

  @override
  Widget build(BuildContext context) {
    return PageDialog.ios(
        title: i18n.dressRoomTitle,
        onConfirm: selectedAvater != null ? onConfirm : null,
        content: (showButtonBar) {
          return FutureBuilder(
              future: initDressRoom,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final avatars = snapshot.data!;
                showButtonBar(true);
                return Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: avatars.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 106 / 150,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 12),
                      itemBuilder: (context, index) {
                        final avatar = avatars[index];
                        final selected = selectedAvater != null &&
                            selectedAvater == avatar.id;

                        return GestureDetector(
                          onTap: () {
                            onDressPressed(avatar.id);
                          },
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOutQuad,
                                  foregroundDecoration: BoxDecoration(
                                    color: selected ? Colors.black38 : null,
                                  ),
                                  child: DressedAvatar(
                                    id: avatar.id,
                                    imageSrc: avatar.b64Image,
                                    amount: avatar.badgeText,
                                  ),
                                ),
                              ),
                              if (selected) checkMark()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              });
        });
  }

  Positioned checkMark() {
    return Positioned(
      top: 3.5,
      left: 3.5,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_circle_rounded,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class DressedAvatar extends StatefulWidget {
  final String? id;
  final String imageSrc;
  final String amount;

  const DressedAvatar(
      {super.key,
      required this.id,
      required this.imageSrc,
      required this.amount});

  @override
  State<DressedAvatar> createState() => _DressedAvatarState();
}

class _DressedAvatarState extends State<DressedAvatar> {
  bool get isChangable => widget.id != null;
  late Uint8List imageBytes;

  @override
  void initState() {
    super.initState();
    imageBytes = base64Decode(widget.imageSrc);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Image.memory(
              imageBytes,
              opacity: isChangable ? null : const AlwaysStoppedAnimation(0.5),
              color: isChangable ? null : Colors.grey,
              colorBlendMode: isChangable ? null : BlendMode.saturation,
            ),
          ),
        ),
        Positioned(
            bottom: 7.5,
            right: 7.5,
            child: SizedBox(
                child: Chip(
              visualDensity: VisualDensity.compact,
              label: Text(widget.amount,
                  style: const TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
            )))
      ],
    );
  }
}
