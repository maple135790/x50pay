import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/models/gift_box/claimed_gift.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/gift_system/empty_notice.dart';

class ClaimedGiftPage extends StatelessWidget {
  final List<ClaimedGift> gifts;

  /// 已領取禮物頁面
  const ClaimedGiftPage(this.gifts, {super.key});

  @override
  Widget build(BuildContext context) {
    if (gifts.isEmpty) {
      return const Align(alignment: .topCenter, child: EmptyNotice());
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: gifts.length,
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
                Text('', style: TextStyle(fontSize: 14)),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: null,
              style: CustomButtonThemes.grey(),
              child: const Text('已領取'),
            ),
          ),
        ),
        itemBuilder: (context, index) {
          final gift = gifts[index];

          final String subtitle;
          if (gift.auto) {
            subtitle = '已自動發送至會員帳號';
          } else if (gift.name.contains('抽選')) {
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
                  imageUrl: gift.pic,
                  errorWidget: (context, url, error) => Icon(
                    Icons.broken_image_rounded,
                    color: const Color(0xff505050).withValues(alpha: 0.7),
                  ),
                  placeholder: (context, url) => Icon(
                    Icons.hourglass_top_rounded,
                    color: const Color(0xff505050).withValues(alpha: 0.7),
                  ),
                  width: 50,
                ),
              ),
              title: Text(gift.name, style: const TextStyle(fontSize: 14)),
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
                child: const Text('已領取'),
              ),
            ),
          );
        },
      ),
    );
  }
}
