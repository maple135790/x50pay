import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/models/avatar/avatar.dart';
import 'package:x50pay/page/home/dress_room/dress_room_loaded.dart';
import 'package:x50pay/page/home/dress_room/dress_room_loading.dart';
import 'package:x50pay/page/home/dress_room/dress_room_view_model.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class DressRoom extends StatefulWidget {
  const DressRoom({super.key});

  @override
  State<DressRoom> createState() => _DressRoomState();

  static final gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 6,
    mainAxisSpacing: 6,
    mainAxisExtent: 175,
  );
}

class _DressRoomState extends State<DressRoom> {
  late final DressRoomViewModel viewModel;
  late Future<List<Avatar>> initDressRoom;

  @override
  void initState() {
    super.initState();
    viewModel = DressRoomViewModel(repository: context.read<MainRepository>());
    initDressRoom = viewModel.getAvatars();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Scrollbar(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xff1e1e1e),
            borderRadius: BorderRadius.circular(15),
          ),
          child: FutureBuilder(
            future: initDressRoom,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const DressRoomLoading();
              }
              final avatars = snapshot.data!;
              return DressRoomLoaded(avatars);
            },
          ),
        ),
      ),
    );
  }
}
