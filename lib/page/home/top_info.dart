import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/page/home/user_info_panel/user_info_panel.dart';
import 'package:x50pay/providers/user_provider.dart';

class TopInfo extends StatelessWidget {
  /// 頁面頂部的個人資訊
  ///
  /// 包含頭像、名稱、UID、P點、QRCode掃描按鈕
  const TopInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserProvider, UserModel>(
      selector: (context, provider) => provider.user!,
      builder: (context, user, child) {
        final userAvatarAndId = Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            PhysicalModel(
              color: Colors.transparent,
              shape: BoxShape.circle,
              elevation: 1.2,
              child: CircleAvatar(
                radius: 78 / 2,
                foregroundImage: NetworkImage(user.userImageUrl),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xff52c41a),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [const BoxShadow(blurRadius: 12, color: Colors.black54)],
              ),
              child: Text(
                "ID ${user.uid ?? ""}",
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          child: Row(
            children: [
              userAvatarAndId,
              const SizedBox(width: 12),
              Expanded(child: UserInfoPanel(user)),
            ],
          ),
        );
      },
    );
  }
}
