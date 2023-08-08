part of 'grade_box.dart';

class _BoxTab extends StatefulWidget {
  final List<GradeBoxItem?> items;

  const _BoxTab({required this.items});

  @override
  State<_BoxTab> createState() => __BoxTabState();
}

class __BoxTabState extends State<_BoxTab> {
  bool get isEmptyItems => widget.items.isEmpty;
  late List<Widget> children;

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

  @override
  void initState() {
    super.initState();
    if (isEmptyItems) return;
    children = widget.items.map((e) {
      final item = e!;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: item.rawPicUrl,
                  errorWidget: (_, __, ___) => const Icon(
                      Icons.broken_image_rounded,
                      size: 35,
                      color: Color(0xff303030)),
                  width: 65,
                  height: 65,
                )),
            Flexible(
                child: Text(
              '${item.name}\n${item.info}',
              style: const TextStyle(color: Color(0xfffafafa), height: 2),
            )),
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
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isEmptyItems) return const SizedBox();
    return Scaffold(
      body: Column(
        children: children,
      ),
    );
  }
}
