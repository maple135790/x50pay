import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/grade_box/grade_box_item.dart';
import 'package:x50pay/common/widgets/material_glass.dart';
import 'package:x50pay/page/grade_box/filtered_view.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';

enum GradeBoxFilter {
  all,
  card,
  misc,
  album,
  storeRelated;

  static GradeBoxFilter get initial => all;
}

class GradeBoxLoaded extends StatefulWidget {
  const GradeBoxLoaded({super.key});

  @override
  State<GradeBoxLoaded> createState() => _GradeBoxLoadedState();
}

class _GradeBoxLoadedState extends State<GradeBoxLoaded> with AppThemeMixin {
  static const titleImageUrl =
      'https://pay.x50.fun/static/content/gradebox.jpg';
  AnimationStatus _status = AnimationStatus.dismissed;

  String filterName(GradeBoxFilter filter) {
    return switch (filter) {
      GradeBoxFilter.all => "全部",
      GradeBoxFilter.card => "卡片",
      GradeBoxFilter.misc => "物料",
      GradeBoxFilter.album => "專輯",
      GradeBoxFilter.storeRelated => "店周邊",
    };
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
          '養成點數商場',
          style: TextStyle(
            fontSize: 17,
            color: Color(0xfffafafa),
            fontWeight: .w600,
            shadows: [Shadow(blurRadius: 5)],
          ),
        ),
        Text(
          '立刻使用養成點數兌換禮物',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
            shadows: [const Shadow(blurRadius: 5)],
          ),
        ),
      ],
    );

    final filterDropdown = MaterialGlass.withShadow(
      isBlurEnabled: true,
      borderRadius: 100,
      width: double.maxFinite,
      child: CupertinoMenuAnchor(
        consumeOutsideTaps: true,
        onAnimationStatusChanged: (status) {
          setState(() {
            _status = status;
          });
        },
        menuChildren: GradeBoxFilter.values.map((e) {
          final label = filterName(e);
          return CupertinoMenuItem(
            child: Text(label),
            onPressed: () {
              context.read<GradeBoxViewModel>().selectedFilter = e;
            },
          );
        }).toList(),
        builder: (context, controller, child) {
          return GestureDetector(
            onTap: () {
              if (_status.isForwardOrCompleted) {
                controller.close();
              } else {
                controller.open();
              }
            },
            child: child,
          );
        },
        child: MaterialGlass.withShadow(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          borderRadius: 50,
          height: 37,
          color: Colors.white30,
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Selector<GradeBoxViewModel, String>(
                selector: (context, vm) => filterName(vm.selectedFilter),
                builder: (context, name, child) {
                  return Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 12, color: Colors.black54)],
                    ),
                  );
                },
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 12, color: Colors.black54)],
              ),
            ],
          ),
        ),
      ),
    );
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
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
                      filterDropdown,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Selector<GradeBoxViewModel, List<GradeBoxItem>>(
              selector: (context, vm) => vm.filteredItems,
              builder: (context, data, child) {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: FilteredView(data),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
