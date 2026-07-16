import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/models/avatar/avatar.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
import 'package:x50pay/page/home/dress_room/dress_room.dart';
import 'package:x50pay/page/home/dress_room/dress_room_view_model.dart';

class DressRoomLoaded extends StatelessWidget {
  final List<Avatar> avatars;
  const DressRoomLoaded(this.avatars, {super.key});

  @override
  Widget build(BuildContext context) {
    void onDressPressed(Avatar? avatar) {
      if (avatar == null || !avatar.isOwned) return;
      context.read<DressRoomViewModel>().selectedId = avatar.id;
    }

    void onConfirm() async {
      final selectedId = context.read<DressRoomViewModel>().selectedId;
      assert(
        selectedId != null,
        'selectedAvater should be selected before confirm',
      );
      if (selectedId == null) return;
      final nav = Navigator.of(context);
      final isSuccess = await context.read<DressRoomViewModel>().setAvatar();

      if (isSuccess) {
        nav.pop(true);
      } else {
        Fluttertoast.showToast(msg: "請稍後再試");
      }
    }

    final checkmark = Container(
      margin: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check_circle_rounded, color: Colors.blue),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: avatars.length,
            gridDelegate: DressRoom.gridDelegate,
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              return GestureDetector(
                onTap: () {
                  onDressPressed(avatar);
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Selector<DressRoomViewModel, bool>(
                        selector: (context, vm) => vm.selectedId == avatar.id,
                        builder: (context, isSelected, child) {
                          return AnimatedContainer(
                            duration: Durations.short3,
                            curve: Curves.easeInOutQuad,
                            foregroundDecoration: BoxDecoration(
                              color: isSelected ? Colors.black26 : null,
                            ),
                            child: child,
                          );
                        },
                        child: DressedAvatar(avatar),
                      ),
                    ),
                    Positioned(
                      top: 3.5,
                      left: 3.5,
                      child: Selector<DressRoomViewModel, bool>(
                        selector: (context, vm) => vm.selectedId == avatar.id,
                        builder: (context, isSelected, child) {
                          return isSelected ? checkmark : const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 5),
          child: CupertinoTheme(
            data: const CupertinoThemeData(),
            child: Selector<DressRoomViewModel, (bool, bool)>(
              selector: (context, vm) => (vm.selectedId != null, vm.isLoading),
              builder: (context, state, child) {
                final Widget widget;
                final (isSelected, isLoading) = state;
                if (isLoading) {
                  widget = const CupertinoActivityIndicator();
                } else if (isSelected) {
                  widget = const Text("更換");
                } else {
                  widget = const Text("請選擇");
                }

                return CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(100),
                  onPressed: !isLoading && isSelected ? onConfirm : null,
                  child: widget,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class DressedAvatar extends StatelessWidget {
  final Avatar avatar;

  const DressedAvatar(this.avatar, {super.key});

  static final decoration = BoxDecoration(
    color: const Color(0xffd3d3d3),
    borderRadius: BorderRadius.circular(14),
  );

  @override
  Widget build(BuildContext context) {
    final dataUri = avatar.dataUri;
    final amount = avatar.level.toString();
    final isChangable = avatar.isOwned;
    final data = UriData.parse(dataUri);
    final avatarRequirement = "滿$amount愛心";

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned.fill(
          child: Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.all(3),
            decoration: decoration,
            child: Image.memory(
              data.contentAsBytes(),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) {
                  return child;
                }
                return AnimatedOpacity(
                  opacity: frame == null ? 0.0 : 1.0,
                  duration: Durations.short3,
                  curve: Curves.easeOut,
                  child: child,
                );
              },
              opacity: isChangable ? null : const AlwaysStoppedAnimation(0.3),
              color: isChangable ? null : const Color(0xffd3d3d3),
              colorBlendMode: isChangable ? null : BlendMode.saturation,
              cacheHeight: 300,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: MaterialGlass.withShadow(
            borderRadius: 16.5,
            color: const Color.fromARGB(172, 255, 255, 255),
            padding: const EdgeInsets.symmetric(
              vertical: 3.375,
              horizontal: 7.5,
            ),
            child: Text(
              avatarRequirement,
              style: const TextStyle(
                color: Color(0xff4e4e4e),
                fontSize: 12,
                fontWeight: .w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
