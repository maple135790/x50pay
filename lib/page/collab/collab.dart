import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/page/giftSystem/gift_system_view_model.dart';
import 'package:x50pay/page/pages.dart';

part 'collab_shop_list.dart';

class Collab extends StatefulWidget {
  const Collab({Key? key}) : super(key: key);

  @override
  State<Collab> createState() => _CollabState();
}

class _CollabState extends BaseStatefulState<Collab> {
  final viewModel = GiftSystemViewModel();
  late Future<bool> init;

  @override
  void initState() {
    super.initState();
    init = viewModel.giftSystemInit();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: init,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(child: kDebugMode ? Text('not done') : null);
        }
        if (snapshot.data != true) {
          if (EasyLoading.isShow) EasyLoading.dismiss();
          return const SizedBox(child: kDebugMode ? Text('not true') : null);
        }
        if (EasyLoading.isShow) EasyLoading.dismiss();
        return _CollabLoaded(
          giftBoxModel: viewModel.giftBoxModel!,
          lotteListModel: viewModel.lotteListModel!,
        );
      },
    );
  }
}

class _CollabLoaded extends StatefulWidget {
  final LotteListModel lotteListModel;
  final GiftBoxModel giftBoxModel;

  const _CollabLoaded(
      {Key? key, required this.giftBoxModel, required this.lotteListModel})
      : super(key: key);

  @override
  State<_CollabLoaded> createState() => _CollabLoadedState();
}

class _CollabLoadedState extends State<_CollabLoaded> {
  // final viewModel = GiftSystemViewModel();
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
            Positioned(
                right: 0,
                child: Image.network(
                  titleImageUrl,
                  height: 135,
                  opacity: const AlwaysStoppedAnimation(80),
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
