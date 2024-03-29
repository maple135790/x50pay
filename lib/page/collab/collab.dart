import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/collab/collab_shop_list.dart';

class Collab extends StatefulWidget {
  /// 合作店家頁面
  const Collab({super.key});

  @override
  State<Collab> createState() => _CollabState();
}

class _CollabState extends BaseStatefulState<Collab> {
  static const titleImageUrl = 'https://pay.x50.fun/static/giftcenter.png';
  final tabs = const <Widget>[Tab(text: '商家清單 / 兌換')];

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(children: [
              const Positioned(
                  right: 0,
                  child: Image(
                    image: CachedNetworkImageProvider(titleImageUrl),
                    height: 135,
                    opacity: AlwaysStoppedAnimation(0.8),
                  )),
              SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        color: isDarkTheme
                            ? const Color.fromARGB(12, 255, 255, 255)
                            : const Color.fromARGB(12, 0, 0, 0),
                        width: MediaQuery.of(context).size.width,
                        height: 89.19,
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('X50Pay 合作商家',
                                  style: TextStyle(fontSize: 17)),
                              Text('查看 & 兌換合作商家優惠',
                                  style: TextStyle(color: Color(0xff787878)))
                            ])),
                    Container(
                        height: 42.5,
                        alignment: Alignment.centerLeft,
                        color: isDarkTheme
                            ? const Color.fromARGB(5, 255, 255, 255)
                            : const Color.fromARGB(5, 0, 0, 0),
                        child: TabBar(
                          tabAlignment: TabAlignment.start,
                          isScrollable: true,
                          tabs: tabs,
                          indicatorWeight: 3,
                        )),
                  ],
                ),
              ),
            ]),
            const Expanded(
              child: TabBarView(
                children: [
                  CollabShopList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
