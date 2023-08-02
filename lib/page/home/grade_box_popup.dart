part of "home.dart";

class _GradeBoxPopup extends StatelessWidget {
  final Future<bool> Function(
      {int debugFlag, required String gid, required String grid}) onChangeGrade;
  final String gradeBox;

  const _GradeBoxPopup({required this.onChangeGrade, required this.gradeBox});

  ImageProvider getGiftImage(String title) {
    if (title == 'SDVX VVelcome!! 限定卡') {
      return R.image.vvelcome();
    } else if (title == 'Chunithm NEW代海報' || title == 'CHUNITHM 吊飾盲抽') {
      return R.image.chu_80();
    } else if (title == 'SDVX MAYHEM 限定卡') {
      return R.image.mayhem();
    } else if (title == 'Project DIVA 2nd# 特典') {
      return R.image.miku2nd();
    } else if (title == 'maimaiDX 宇宙限定卡' || title == 'maimaiDX 宇宙代海報') {
      return R.image.mmdxc_jpg();
    } else if (title == '真璃泳裝一代立排' || title == '真璃Q版制服吊飾') {
      return R.image.ouo_80();
    } else if (title == 'SDVX 10 週年限定卡') {
      return R.image.sdvx10th_jpg();
    }
    return R.image.ouo_80();
  }

  List<_TradeGift> getTradeGifts(String str) {
    List<String> metas = [];
    List<String> titles = [];
    List<String> prices = [];
    List<List<String>> params = [];
    List<_TradeGift> gifts = [];

    List<String> getDivLabel({required String divName}) {
      List<String> result = [];
      int? start;

      for (int i = 0; i < str.length; i++) {
        var char = str[i];

        if (char == '<') start = i;

        if (start != null && char == '>') {
          String substring = str.substring(start, i);
          if (substring.contains(divName)) {
            int j = i;
            while (str[j] != '<') {
              j++;
            }
            result.add(str.substring(i + 1, j));
          }
        }
      }
      return result;
    }

    List<List<String>> getParams() {
      List<List<String>> result = [];
      int? start;

      for (int i = 0; i < str.length; i++) {
        var char = str[i];

        if (char == '<') start = i;

        if (start != null && char == '>') {
          List<String> params = [];
          String substring = str.substring(start, i);
          if (substring.contains('chgGradev2')) {
            var rawStr = substring
                .split(' ')
                .last
                .split('="chgGradev2(')
                .last
                .replaceAll(');"', '');
            for (String param in rawStr.split(',')) {
              params.add(param.replaceAll("'", ''));
            }
            result.add(params);
          }
        }
      }
      return result;
    }

    metas = getDivLabel(divName: 'meta');
    titles = getDivLabel(divName: 'header');
    prices = getDivLabel(divName: '/span');
    params = getParams();

    for (int i = 0; i < titles.length; i++) {
      gifts.add(_TradeGift(
          title: titles[i],
          meta: metas[i],
          price: prices[i],
          gid: params[i][0],
          grid: params[i][1]));
    }
    return gifts;
  }

  @override
  Widget build(BuildContext context) {
    List<_TradeGift> gifts = getTradeGifts(gradeBox);

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      contentPadding: EdgeInsets.zero,
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
              child: Row(children: [
                const Text('養成兌換箱'),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.cancel,
                        color: Color(0xfffafafa), size: 20))
              ])),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.maxFinite,
              height: 1050,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: gifts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 25),
                itemBuilder: (context, index) {
                  return giftRow(
                    gift: gifts[index],
                    tradeOnPressed: (gid, grid) {
                      tradeGift(gid, grid, context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tradeGift(gid, grid, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                const Text('確認兌換', style: TextStyle(color: Color(0xfffafafa))),
            content: const Text('確認是否要使用親密度兌換 ? '),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: Themes.pale(),
                  child: const Text('取消')),
              TextButton(
                  onPressed: () async {
                    var nav = GoRouter.of(context);
                    if (await onChangeGrade(gid: gid, grid: grid)) {
                      await EasyLoading.showSuccess('成功兌換,將會回到首頁',
                          duration: const Duration(milliseconds: 1500));
                      await Future.delayed(const Duration(milliseconds: 1500));

                      nav.goNamed(AppRoutes.home.routeName);
                    } else {
                      await EasyLoading.showError('兌換失敗,將會回到首頁',
                          duration: const Duration(milliseconds: 1500));
                      await Future.delayed(const Duration(milliseconds: 1500));

                      nav.goNamed(AppRoutes.home.routeName);
                    }
                  },
                  style: Themes.severe(isV4: true),
                  child: const Text('兌換')),
            ],
          );
        });
  }

  Widget giftRow(
      {required _TradeGift gift,
      required void Function(String, String) tradeOnPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Image(
                    image: getGiftImage(gift.title),
                    filterQuality: FilterQuality.high),
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gift.title, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 5),
                      Text(gift.meta, style: const TextStyle(fontSize: 12))
                    ]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        TextButton(
            onPressed: () {
              tradeOnPressed(gift.gid, gift.grid);
            },
            style: Themes.severe(
                isV4: true,
                padding: const EdgeInsets.symmetric(horizontal: 15)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, size: 20),
                const SizedBox(width: 10),
                Text(gift.price)
              ],
            )),
      ],
    );
  }
}

class _TradeGift {
  final String title;
  final String meta;
  final String price;
  final String gid;
  final String grid;

  const _TradeGift(
      {required this.title,
      required this.meta,
      required this.price,
      required this.gid,
      required this.grid});

  @override
  String toString() {
    return 'title: $title\nmeta: $meta\nprice: $price\ngid: $gid\ngrid: $grid,';
  }
}
