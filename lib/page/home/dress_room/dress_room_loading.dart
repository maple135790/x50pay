import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
import 'package:x50pay/page/home/dress_room/dress_room.dart';

class DressRoomLoading extends StatelessWidget {
  const DressRoomLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final notice = const MaterialGlass.withShadow(
      color: Colors.black54,
      isBlurEnabled: true,
      borderRadius: 14,
      padding: EdgeInsets.all(36),
      child: DefaultTextStyle(
        style: TextStyle(color: Color(0xffb4b4b4)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(radius: 20),
            SizedBox(height: 15),
            Text("衣櫃有點大~", style: TextStyle(fontSize: 17)),
            SizedBox(height: 3.75),
            Text("正在載入中", style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: Skeletonizer(
            child: GridView.builder(
              gridDelegate: DressRoom.gridDelegate,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3 * 6,
              itemBuilder: (context, index) {
                return const Skeleton.leaf(child: Card());
              },
            ),
          ),
        ),
        Center(child: notice),
      ],
    );
  }
}
