import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/page/collab/collab_shop_list_view_model.dart';
import 'package:x50pay/r.g.dart';

part 'collab_shop_list.dart';

class Collab extends StatefulWidget {
  /// 合作店家頁面
  const Collab({Key? key}) : super(key: key);

  @override
  State<Collab> createState() => _CollabState();
}

class _CollabState extends State<Collab> {
  static const titleImageUrl = 'https://pay.x50.fun/static/giftcenter.png';
  final tabs = const <Widget>[Tab(text: '商家清單 / 兌換')];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                      color: const Color.fromARGB(12, 255, 255, 255),
                      width: MediaQuery.of(context).size.width,
                      height: 89.19,
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('X50Pay 合作商家', style: TextStyle(fontSize: 17)),
                            Text('查看 & 兌換合作商家優惠',
                                style: TextStyle(color: Color(0xffb4b4b4)))
                          ])),
                  Container(
                      height: 42.5,
                      alignment: Alignment.centerLeft,
                      color: const Color.fromARGB(5, 255, 255, 255),
                      child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          isScrollable: true,
                          tabs: tabs,
                          indicatorWeight: 3,
                          splashFactory: NoSplash.splashFactory,
                          indicatorColor: Colors.white)),
                ],
              ),
            ),
          ]),
          const Expanded(
            child: TabBarView(
              children: [
                _CollabShopList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
