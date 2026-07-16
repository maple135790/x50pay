import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/gift_box/claimable_gift.dart';
import 'package:x50pay/common/models/gift_box/claimed_gift.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
import 'package:x50pay/page/collab/collab_shop_list.dart';
import 'package:x50pay/page/gift_system/claimed_gift.dart';
import 'package:x50pay/page/gift_system/gift_claim.dart';
import 'package:x50pay/page/gift_system/gift_system_view_model.dart';

enum GiftTab { claim, claimedGift, collab }

class GiftPageLoaded extends StatefulWidget {
  const GiftPageLoaded({super.key});

  @override
  State<GiftPageLoaded> createState() => _GiftPageLoadedState();
}

class _GiftPageLoadedState extends State<GiftPageLoaded>
    with AppThemeMixin, SingleTickerProviderStateMixin {
  static const titleImageUrl =
      'https://pay.x50.fun/static/content/gradebox.jpg';
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: GiftTab.values.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final headerImageHeight = padding.top + 170;
    final titleWidget = Column(
      children: [
        Icon(
          Icons.shopping_cart_rounded,
          color: const Color(0xfffafafa),
          size: 35,
          shadows: [
            Shadow(color: Colors.black.withValues(alpha: 0.7), blurRadius: 8),
          ],
        ),
        const Text(
          '禮物/折扣',
          style: TextStyle(
            fontSize: 17,
            color: Color(0xfffafafa),
            fontWeight: .w600,
            shadows: [Shadow(blurRadius: 5)],
          ),
        ),
        Text(
          '立即兌換禮物或查詢合作折扣',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
            shadows: [const Shadow(blurRadius: 5)],
          ),
        ),
      ],
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: headerImageHeight,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                left: 0,
                child: DecoratedBox(
                  position: .foreground,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black45, Colors.transparent],
                      stops: [0, 0.7],
                      begin: .bottomCenter,
                      end: .topCenter,
                    ),
                  ),
                  child: Image(
                    alignment: .topCenter,
                    image: const CachedNetworkImageProvider(titleImageUrl),
                    fit: BoxFit.cover,
                    height: headerImageHeight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 12, 18),
                child: Column(
                  children: [
                    SizedBox(height: padding.top),
                    titleWidget,
                    const Spacer(),
                    MaterialGlass.withShadow(
                      isBlurEnabled: true,
                      borderRadius: 100,
                      color: Colors.white24,
                      child: TabBar(
                        tabs: GiftTab.values.map((e) {
                          final label = switch (e) {
                            .claim => "領取禮物",
                            .claimedGift => "已領取",
                            .collab => "合作折扣",
                          };
                          return Tab(text: label);
                        }).toList(),
                        indicatorPadding: const EdgeInsets.all(6.5),
                        labelStyle: const TextStyle(
                          fontSize: 12.75,
                          fontWeight: .w700,
                        ),
                        labelColor: const Color(0xfff00764),
                        unselectedLabelColor: Colors.white.withValues(
                          alpha: 0.9,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 12.75,
                          fontWeight: .w700,
                        ),
                        controller: tabController,
                        tabAlignment: TabAlignment.fill,
                        indicator: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        indicatorSize: .tab,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: TabBarView(
              controller: tabController,
              children: GiftTab.values.map((e) {
                return switch (e) {
                  .claim => Selector<GiftPageViewModel, List<ClaimableGift>>(
                    selector: (context, vm) => vm.claimableGifts,
                    builder: (context, gifts, child) {
                      return GiftClaim(gifts);
                    },
                  ),
                  .claimedGift =>
                    Selector<GiftPageViewModel, List<ClaimedGift>>(
                      selector: (context, vm) => vm.claimedGifts,
                      builder: (context, gifts, child) {
                        return ClaimedGiftPage(gifts);
                      },
                    ),
                  .collab => const CollabShopList(),
                };
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
