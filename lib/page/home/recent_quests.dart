import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/theme/color_theme.dart';

class RecentQuests extends StatelessWidget {
  /// 活動列表
  final List<QuestCampaign> quests;

  /// 最新活動區塊
  ///
  /// 包含最新活動的圖片，點擊圖片後會跳轉到該活動的頁面
  const RecentQuests({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: quests
          .map((q) => Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDarkTheme
                            ? CustomColorThemes.borderColorDark
                            : CustomColorThemes.borderColorLight,
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
                                context.goNamed(
                                    AppRoutes.questCampaign.routeName,
                                    pathParameters: {'couid': q.couid});
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
