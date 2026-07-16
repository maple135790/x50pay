import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/models/gift_box/claimable_gift.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/gift_system/change_confirm_dialog.dart';
import 'package:x50pay/page/gift_system/empty_notice.dart';

class GiftClaimPage extends StatelessWidget {
  final List<ClaimableGift> gifts;

  /// 領取禮物頁面
  const GiftClaimPage(this.gifts, {super.key});

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
            contentPadding: EdgeInsets.zero,
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
          final String subtitle, buttonText;
          if (gift.name.contains('抽選')) {
            subtitle = '請於想抽的月份自助兌換';
            buttonText = '馬上抽';
          } else {
            subtitle = '粉絲專頁預約';
            buttonText = '領禮物';
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.comfortable,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(imageUrl: gift.pic, width: 50),
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return ChangeConfirmDialog(gid: gift.gid);
                    },
                  );
                },
                style: CustomButtonThemes.severe(isV4: true),
                child: Text(buttonText),
              ),
            ),
          );
        },
      ),
    );
  }
}
