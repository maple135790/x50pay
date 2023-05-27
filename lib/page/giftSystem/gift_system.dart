import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/giftBox/gift_box.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/giftSystem/gift_system_view_model.dart';
import 'package:x50pay/repository/repository.dart';

part "lotte_box.dart";
part "gift_claim.dart";
part "claimed_gift.dart";

class GiftSystem extends StatefulWidget {
  const GiftSystem({Key? key}) : super(key: key);

  @override
  State<GiftSystem> createState() => _GiftSystemState();
}

class _GiftSystemState extends BaseStatefulState<GiftSystem> with BaseLoaded {
  final viewModel = GiftSystemViewModel();
  late Future<bool> init;

  @override
  bool get isScrollable => false;

  @override
  BaseViewModel? baseViewModel() => viewModel;
  @override
  void initState() {
    super.initState();
    init = viewModel.giftSystemInit();
  }

  @override
  Widget body() {
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
        return _GiftBoxLoaded(
          giftBoxModel: viewModel.giftBoxModel!,
          lotteListModel: viewModel.lotteListModel!,
        );
      },
    );
  }
}

class _GiftBoxLoaded extends StatefulWidget {
  final LotteListModel lotteListModel;
  final GiftBoxModel giftBoxModel;

  const _GiftBoxLoaded({Key? key, required this.giftBoxModel, required this.lotteListModel})
      : super(key: key);

  @override
  State<_GiftBoxLoaded> createState() => _GiftBoxLoadedState();
}

class _GiftBoxLoadedState extends State<_GiftBoxLoaded> {
  final viewModel = GiftSystemViewModel();
  final tabs = const <Widget>[Tab(text: '養成抽獎箱'), Tab(text: '領取禮物'), Tab(text: '已領取')];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            const Positioned(
                bottom: -35, right: -20, child: Icon(Icons.redeem, size: 120, color: Color(0xff343434))),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    color: const Color.fromARGB(12, 255, 255, 255),
                    width: MediaQuery.of(context).size.width,
                    height: 90,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('禮物系統', style: TextStyle(fontSize: 17)),
                          Text('X50Pay 禮物系統', style: TextStyle(color: Color(0xffb4b4b4)))
                        ])),
                Container(
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
          ]),
          Expanded(
            child: TabBarView(
              children: [
                _LotteBox(lotteList: widget.lotteListModel),
                _GiftClaim(canChangeList: widget.giftBoxModel.canChange),
                _ClaimedGift(claimedList: widget.giftBoxModel.alChange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
