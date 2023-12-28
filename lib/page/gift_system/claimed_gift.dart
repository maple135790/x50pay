import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/gift_system/gift_system_view_model.dart';

class ClaimedGift extends StatelessWidget {
  /// 已領取禮物頁面
  const ClaimedGift({super.key});

  @override
  Widget build(BuildContext context) {
    final claimedList = context.select<GiftSystemViewModel, List<AlChange>>(
        (vm) => vm.giftBox?.alChange ?? []);

    return Scrollbar(
      child: ListView.builder(
        itemCount: claimedList.length,
        prototypeItem: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: ListTile(
            visualDensity: VisualDensity.comfortable,
            title: const Text('', style: TextStyle(fontSize: 14)),
            subtitle: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 4),
                Text('', style: TextStyle(fontSize: 14))
              ],
            ),
            trailing: ElevatedButton(
                onPressed: null,
                style: CustomButtonThemes.grey(),
                child: const Text('已領取')),
          ),
        ),
        itemBuilder: (context, index) {
          late String subtitle;
          if (claimedList[index].auto) {
            subtitle = '已自動發送至會員帳號';
          } else if (claimedList[index].name.contains('抽選')) {
            subtitle = '請於想抽的月份自助兌換';
          } else {
            subtitle = '粉絲專頁預約';
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.comfortable,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: claimedList[index].pic,
                  errorWidget: (context, url, error) => Icon(
                      Icons.broken_image_rounded,
                      color: const Color(0xff505050).withOpacity(0.7)),
                  placeholder: (context, url) => Icon(
                      Icons.hourglass_top_rounded,
                      color: const Color(0xff505050).withOpacity(0.7)),
                  width: 50,
                ),
              ),
              title: Text(claimedList[index].name,
                  style: const TextStyle(fontSize: 14)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14)),
                ],
              ),
              trailing: ElevatedButton(
                  onPressed: null,
                  style: CustomButtonThemes.grey(),
                  child: const Text('已領取')),
            ),
          );
        },
      ),
    );
  }
}
