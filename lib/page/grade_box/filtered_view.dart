import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/grade_box/grade_box_item.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';
import 'package:x50pay/route/app_route.dart';

class FilteredView extends StatelessWidget {
  final List<GradeBoxItem> items;

  const FilteredView(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();

    void onChangeItemPressed(GradeBoxItem item) async {
      final nav = GoRouter.of(context);
      final viewModel = context.read<GradeBoxViewModel>();
      final isConfirmExchange = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          final isDarkTheme = AppThemeHelper(context).isDarkTheme;
          return AlertDialog(
            title: const Text('確認兌換'),
            content: const Text('確認是否要使用親密度兌換？'),
            actions: [
              TextButton(
                style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                onPressed: () {
                  context.pop(false);
                },
                child: const Text('取消'),
              ),
              TextButton(
                style: CustomButtonThemes.severe(isV4: true),
                onPressed: () {
                  context.pop(true);
                },
                child: const Text('兌換'),
              ),
            ],
          );
        },
      );
      if (isConfirmExchange != true) return;

      final isSuccess = await viewModel.exchangeItem(item);
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
      nav.goNamed(AppRoute.home.routeName);
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
                fit: BoxFit.cover,
                imageUrl: item.picUrl,
                placeholder: (_, _) => const Icon(
                  Icons.broken_image_rounded,
                  size: 35,
                  color: Color(0xff303030),
                ),
                errorWidget: (_, _, _) => const Icon(
                  Icons.broken_image_rounded,
                  size: 35,
                  color: Color(0xff303030),
                ),
                width: 65,
                height: 65,
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${item.name}\n${item.info}',
                    style: const TextStyle(height: 2),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: CustomButtonThemes.severe(isV4: true, isRRect: true),
              onPressed: () {
                onChangeItemPressed(item);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite_rounded, size: 17),
                  Text(' ${item.heart} '),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return itemRow(item);
        },
      ),
    );
  }
}
