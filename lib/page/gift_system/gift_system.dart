import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/gift_system/claimed_gift.dart';
import 'package:x50pay/page/gift_system/gift_claim.dart';
import 'package:x50pay/page/gift_system/gift_system_view_model.dart';
import 'package:x50pay/page/gift_system/lotte_box.dart';
import 'package:x50pay/repository/repository.dart';

class GiftSystem extends StatefulWidget {
  /// 禮物系統頁面
  const GiftSystem({super.key});

  @override
  State<GiftSystem> createState() => _GiftSystemState();
}

class _GiftSystemState extends BaseStatefulState<GiftSystem> {
  final repo = Repository();
  late final viewModel = GiftSystemViewModel(repository: repo);
  late Future<void> init;

  @override
  void initState() {
    super.initState();
    init = viewModel.giftSystemInit();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewModel,
        builder: (context, child) {
          return FutureBuilder(
            future: init,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                    child: kDebugMode ? Text('not done') : null);
              }
              if (snapshot.hasError) {
                showServiceError();
                return Center(child: Text(serviceErrorText));
              }
              if (EasyLoading.isShow) EasyLoading.dismiss();
              return const _GiftBoxLoaded();
            },
          );
        });
  }
}

class _GiftBoxLoaded extends StatefulWidget {
  const _GiftBoxLoaded();

  @override
  State<_GiftBoxLoaded> createState() => _GiftBoxLoadedState();
}

class _GiftBoxLoadedState extends BaseStatefulState<_GiftBoxLoaded> {
  final tabs = const <Widget>[
    Tab(text: '養成抽獎箱'),
    Tab(text: '領取禮物'),
    Tab(text: '已領取')
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(children: [
            Positioned(
              bottom: -35,
              right: -20,
              child: Icon(
                Icons.redeem_rounded,
                size: 120,
                color: IconTheme.of(context).color?.withOpacity(0.1),
              ),
            ),
            Column(
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
                          Text('禮物系統', style: TextStyle(fontSize: 17)),
                          Text('X50Pay 禮物系統',
                              style: TextStyle(color: Color(0xffb4b4b4)))
                        ])),
                Container(
                    height: 42.5,
                    alignment: Alignment.centerLeft,
                    color: isDarkTheme
                        ? const Color.fromARGB(5, 255, 255, 255)
                        : const Color.fromARGB(5, 0, 0, 0),
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: tabs,
                      indicatorWeight: 3,
                    )),
              ],
            ),
          ]),
          const Expanded(
            child: TabBarView(
              children: [
                LotteBox(),
                GiftClaim(),
                ClaimedGift(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
