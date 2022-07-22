import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/buyMPass/buy_mpass.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends BaseStatefulState<Home> with BaseLoaded {
  final viewModel = HomeViewModel()..isFunctionalHeader = false;
  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    return FutureBuilder<bool>(
      future: viewModel.initHome(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
        if (snapshot.data == false) {
          EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50');
          return const SizedBox(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
        } else {
          return _HomeLoaded(GlobalSingleton.instance.user!, viewModel);
        }
      },
    );
  }
}

class _HomeLoaded extends StatefulWidget {
  final HomeViewModel viewModel;
  final UserModel user;

  const _HomeLoaded(this.user, this.viewModel, {Key? key}) : super(key: key);

  @override
  State<_HomeLoaded> createState() => _HomeLoadedState();
}

class _HomeLoadedState extends State<_HomeLoaded> {
  String _vipExpDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(widget.user.vipdate!.date - 480 * 60000);
    return '${date.month + 1}/${date.day} ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final entry = widget.viewModel.entry!;
    final gradeLv = entry.gr2[0].toInt().toString();
    final gr2HowMuch = entry.gr2[1].toInt().toString();
    final gr2Limit = entry.gr2[2].toInt().toString();
    final gr2Next = entry.gr2[3].toString();
    final gr2Day = entry.gr2[4].toString();
    final gr2Date = entry.gr2[5].toString();
    final gr2GradeBoxContent = entry.gr2[6].toString();
    final ava = entry.gr2[7].toString().split(',').last;
    final gr2VDay = entry.gr2[9].toInt().toString();
    final gr2Progress = entry.gr2[0] / 10;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('確認離開 ?', style: TextStyle(color: Color(0xfffafafa))),
              actions: [
                TextButton(
                  style: Themes.severe(isV4: true),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('是'),
                ),
                TextButton(
                  style: Themes.pale(),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('否'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: user.userimg != null
                            ? DecorationImage(image: NetworkImage(user.userimg!), fit: BoxFit.fill)
                            : DecorationImage(image: R.image.logo_150_jpg(), fit: BoxFit.fill))),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Themes.borderColor)),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                const WidgetSpan(
                                    child: Icon(Icons.person, color: Color(0xfffafafa), size: 20)),
                                const WidgetSpan(child: SizedBox(width: 5)),
                                TextSpan(text: user.name!)
                              ])),
                              const SizedBox(height: 5),
                              RichText(
                                  text: TextSpan(children: [
                                const WidgetSpan(
                                    child: Icon(Icons.perm_contact_cal, color: Color(0xfffafafa), size: 20)),
                                const WidgetSpan(child: SizedBox(width: 5)),
                                TextSpan(text: user.uid!)
                              ])),
                              const SizedBox(height: 5),
                              RichText(
                                  text: TextSpan(children: [
                                const WidgetSpan(
                                    child: Icon(Icons.currency_yen, color: Color(0xfffafafa), size: 20)),
                                const WidgetSpan(child: SizedBox(width: 5)),
                                TextSpan(text: user.point!.toInt().toString()),
                                const TextSpan(text: 'P')
                              ])),
                            ],
                          ),
                          const Spacer(),
                          const VerticalDivider(thickness: 1, width: 0),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () async {
                              await showDialog(context: context, builder: (context) => const ScanQRCode());
                            },
                            child: const Icon(Icons.qr_code, color: Color(0xfffafafa), size: 45),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Stack(children: [
              const Positioned(
                  bottom: -35, right: -20, child: Icon(Icons.east, size: 120, color: Color(0xff343434))),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => const BuyMPass()));
                          },
                          child: const Icon(Icons.confirmation_number, color: Color(0xff237804), size: 50)),
                      const SizedBox(width: 16),
                      const VerticalDivider(thickness: 1, width: 0),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(text: '券量 : '),
                            const WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(text: user.ticketint!.toString()),
                            const TextSpan(text: '張'),
                          ])),
                          const SizedBox(height: 5),
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(text: '月票 : '),
                            const WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(
                                text: user.vip! ? '已購買' : '未購買',
                                style: TextStyle(color: user.vip! == false ? Colors.red : null))
                          ])),
                          const SizedBox(height: 5),
                          RichText(
                              text: TextSpan(children: [
                            const TextSpan(text: '期限 : '),
                            const WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(text: user.vip! ? _vipExpDate() : '點左側票卷圖樣立刻購買')
                          ])),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Stack(children: [
              const Positioned(
                  bottom: -25, right: -40, child: Icon(Icons.compost, size: 140, color: Color(0xff343434))),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    Image.memory(base64Decode(ava),
                        filterQuality: FilterQuality.high,
                        gaplessPlayback: true,
                        height: 270,
                        cacheHeight: 270),
                    const SizedBox(width: 15),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(children: [
                            const Icon(Icons.favorite, color: Color(0xffc71508)),
                            const SizedBox(width: 5),
                            Text(gradeLv.toString(),
                                style: const TextStyle(color: Color(0xff808080), fontSize: 30)),
                            const SizedBox(width: 5),
                            Tooltip(
                              preferBelow: false,
                              decoration: BoxDecoration(
                                  color: const Color(0x33fefefe), borderRadius: BorderRadius.circular(8)),
                              message: user.vip! ? '月票：當日前12道加成' : '當日前10道加成',
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xff2f2f2f), borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Icon(Icons.bolt, color: Color(0xfffafafa), size: 20),
                                        Text('3'),
                                        SizedBox(width: 3)
                                      ])),
                            )
                          ]),
                          const SizedBox(height: 5),
                          // ProgressBar
                          FAProgressBar(
                            backgroundColor: const Color(0xff949494),
                            borderRadius: BorderRadius.circular(15),
                            currentValue: gr2Progress <= 20 ? 20 : gr2Progress,
                            size: 25,
                            progressColor: const Color(0xffff9bad),
                            displayTextStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                fontFamily: R.fontFamily.notoSansJP),
                            formatValue: (str, t) => '',
                            displayText: ' ♡  ',
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                                  child: RichText(
                                      text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                    const WidgetSpan(
                                        child: Icon(Icons.redeem, color: Color(0xfffafafa), size: 15)),
                                    const WidgetSpan(child: SizedBox(width: 5)),
                                    const TextSpan(text: ' 每 '),
                                    TextSpan(text: gr2HowMuch),
                                    const TextSpan(text: ' 道贈 1 張，上限 '),
                                    TextSpan(text: gr2Limit),
                                    const TextSpan(text: ' 張 '),
                                  ])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                                  child: RichText(
                                      text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                    const WidgetSpan(
                                        child: Icon(Icons.favorite, color: Color(0xfffafafa), size: 15)),
                                    const WidgetSpan(child: SizedBox(width: 5)),
                                    const TextSpan(text: ' 下一階段: '),
                                    TextSpan(text: gr2Next),
                                    const TextSpan(text: ' 親密度 '),
                                  ])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                                  child: RichText(
                                      text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                    const WidgetSpan(
                                        child:
                                            Icon(Icons.calendar_today, color: Color(0xfffafafa), size: 15)),
                                    const WidgetSpan(child: SizedBox(width: 5)),
                                    const TextSpan(text: ' 連續登入: '),
                                    TextSpan(text: gr2Day),
                                    const TextSpan(text: ' 天 '),
                                  ])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                                  child: RichText(
                                      text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                    const WidgetSpan(
                                        child: Icon(Icons.how_to_vote, color: Color(0xfffafafa), size: 15)),
                                    const WidgetSpan(child: SizedBox(width: 5)),
                                    const TextSpan(text: ' 領抽獎券: '),
                                    const TextSpan(text: ' 再 '),
                                    TextSpan(text: gr2VDay),
                                    const TextSpan(text: ' 親密度 '),
                                  ])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                                  child: RichText(
                                      text: TextSpan(style: const TextStyle(fontSize: 12), children: [
                                    const WidgetSpan(
                                        child: Icon(Icons.sync, color: Color(0xfffafafa), size: 15)),
                                    const WidgetSpan(child: SizedBox(width: 5)),
                                    const TextSpan(text: ' 重置日期: '),
                                    TextSpan(text: gr2Date),
                                  ])),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              _GradeBox(gr2GradeBoxContent, widget.viewModel));
                                    },
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      padding: MaterialStateProperty.all(
                                          const EdgeInsets.symmetric(horizontal: 20)),
                                      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 13)),
                                      visualDensity: VisualDensity.comfortable,
                                      splashFactory: NoSplash.splashFactory,
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                      foregroundColor: MaterialStateProperty.all(const Color(0xfff5222d)),
                                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                                        return const Color(0x22f7f7f7);
                                      }),
                                    ),
                                    child: const Text('養成點數商城'),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: GestureDetector(
                  onTap: () {
                    launchUrlString('https://www.youtube.com/channel/UCEbHRn4kPMzODDgsMwGhYVQ',
                        mode: LaunchMode.externalNonBrowserApplication);
                  },
                  child: Image(image: R.image.vts()))),
          Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: GestureDetector(
                  onTap: () {
                    launchUrlString('https://www.youtube.com/c/X50MusicGameStation-onAir',
                        mode: LaunchMode.externalNonBrowserApplication);
                  },
                  child: Image(image: R.image.top()))),
          const SizedBox(height: 25),
        ],
      ),
    );
  }

  void checkRemoteOpen() async {
    final location = Location();
    double deg2rad(double deg) => deg * (pi / 180);

    double getDistance(double lat1, double lon1, double lat2, double lon2) {
      var R = 6371; // Radius of the earth in km
      var dLat = deg2rad(lat2 - lat1); // deg2rad below
      var dLon = deg2rad(lon2 - lon1);
      var a = sin(dLat / 2) * sin(dLat / 2) +
          cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
      var c = 2 * atan2(sqrt(a), sqrt(1 - a));
      var d = R * c; // Distance in km
      return d;
    }

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    double myLat = locationData.latitude!;
    double myLng = locationData.longitude!;
    String result = await Repository().remoteOpenDoor(getDistance(25.0455991, 121.5027702, myLat, myLng));
    await EasyLoading.showInfo(result.replaceFirst(',', '\n'));
  }
}

class _GradeBox extends StatelessWidget {
  final HomeViewModel viewModel;
  final String gradeBox;
  const _GradeBox(this.gradeBox, this.viewModel, {Key? key}) : super(key: key);

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
            var rawStr = substring.split(' ').last.split('="chgGradev2(').last.replaceAll(');"', '');
            for (String param in rawStr.split(',')) {
              params.add(param.replaceAll("'", ''));
            }
            result.add(params);
          }
        }
      }
      // print(result);
      return result;
    }

    metas = getDivLabel(divName: 'meta');
    titles = getDivLabel(divName: 'header');
    prices = getDivLabel(divName: '/span');
    params = getParams();

    for (int i = 0; i < titles.length; i++) {
      gifts.add(_TradeGift(
          title: titles[i], meta: metas[i], price: prices[i], gid: params[i][0], grid: params[i][1]));
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
              padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
              child: Row(children: [
                const Text('養成兌換箱'),
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.cancel, color: Color(0xfffafafa), size: 20))
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
            title: const Text('確認兌換', style: TextStyle(color: Color(0xfffafafa))),
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
                    var nav = Navigator.of(context);
                    if (await viewModel.chgGradev2(gid: gid, grid: grid)) {
                      await EasyLoading.showSuccess('成功兌換,將會回到首頁',
                          duration: const Duration(milliseconds: 1500));
                      await Future.delayed(const Duration(milliseconds: 1500));

                      nav.popUntil(ModalRoute.withName(AppRoute.home));
                    } else {
                      await EasyLoading.showError('兌換失敗,將會回到首頁',
                          duration: const Duration(milliseconds: 1500));
                      await Future.delayed(const Duration(milliseconds: 1500));

                      nav.popUntil(ModalRoute.withName(AppRoute.home));
                    }
                  },
                  style: Themes.severe(isV4: true),
                  child: const Text('兌換')),
            ],
          );
        });
  }

  Widget giftRow({required _TradeGift gift, required void Function(String, String) tradeOnPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: Image(image: getGiftImage(gift.title), filterQuality: FilterQuality.high),
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
            style: Themes.severe(isV4: true, padding: const EdgeInsets.symmetric(horizontal: 15)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [const Icon(Icons.favorite, size: 20), const SizedBox(width: 10), Text(gift.price)],
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
      {required this.title, required this.meta, required this.price, required this.gid, required this.grid});

  @override
  String toString() {
    return '''

title: $title,
meta: $meta,
price: $price,
gid: $gid,
grid: $grid,
''';
  }
}
