import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/models/entry/entry.dart';

class RecentQuests extends StatelessWidget {
  /// 活動列表
  final List<QuestCampaign> quests;

  /// 最新活動區塊
  ///
  /// 包含最新活動的圖片，點擊圖片後會跳轉到該活動的頁面
  const RecentQuests({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: quests
          .map((q) => Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xff505050),
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: q.lpic,
                      height: 55,
                      width: MediaQuery.sizeOf(context).width,
                      fit: BoxFit.fitWidth,
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.goNamed(AppRoutes.questCampaign.routeName,
                                pathParameters: {'couid': q.couid});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
