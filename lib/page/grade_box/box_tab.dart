import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/grade_box/grade_box.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';

class GradeBoxTab extends StatefulWidget {
  final List<GradeBoxItem?> items;

  const GradeBoxTab({super.key, required this.items});

  @override
  State<GradeBoxTab> createState() => _GradeBoxTabState();
}

class _GradeBoxTabState extends BaseStatefulState<GradeBoxTab> {
  bool get isEmptyItems => widget.items.isEmpty;

  void onChangeItemPressed(String gid, String eid) async {
    final isConfirm = await showDialog<bool?>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: const Text('確認兌換'),
        content: const Text('確認是否要使用親密度兌換？'),
        actions: [
          TextButton(
            style: Themes.pale(),
            onPressed: () {
              context.pop(false);
            },
            child: const Text('取消'),
          ),
          TextButton(
            style: Themes.severe(isV4: true),
            onPressed: () {
              context.pop(true);
            },
            child: const Text('兌換'),
          )
        ],
      ),
    );
    if (!(isConfirm ?? false)) return;
    if (mounted) {
      final nav = GoRouter.of(context);
      final isSuccess =
          await context.read<GradeBoxViewModel>().doChangeGrade(gid, eid);
      if (isSuccess) {
        EasyLoading.showSuccess(
          '成功兌換,將會回到首頁',
          duration: const Duration(seconds: 2),
          dismissOnTap: false,
        );
      } else {
        EasyLoading.showError(
          '兌換失敗,將會回到首頁',
          duration: const Duration(seconds: 2),
          dismissOnTap: false,
        );
      }
      await Future.delayed(const Duration(milliseconds: 2500));
      nav.goNamed(AppRoutes.home.routeName);
    }
  }

  Widget itemRow(GradeBoxItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: item.picUrl,
                placeholder: (_, __) => const Icon(
                  Icons.broken_image_rounded,
                  size: 35,
                  color: Color(0xff303030),
                ),
                errorWidget: (_, __, ___) => const Icon(
                    Icons.broken_image_rounded,
                    size: 35,
                    color: Color(0xff303030)),
                width: 65,
                height: 65,
              )),
          Flexible(
            fit: FlexFit.tight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${item.name}\n${item.info}',
                  style: const TextStyle(
                    color: Color(0xfffafafa),
                    height: 2,
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: Themes.severe(isV4: true, isRRect: true),
            onPressed: () {
              onChangeItemPressed(item.gid, item.eid);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite_rounded, size: 17),
                Text(' ${item.heart} ')
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isEmptyItems) return const SizedBox();
    return Scaffold(
      body: Scrollbar(
        child: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            final item = widget.items[index]!;

            return itemRow(item);
          },
        ),
      ),
    );
  }
}
