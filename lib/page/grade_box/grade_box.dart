import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/grade_box/grade_box.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';

part 'box_tab.dart';

class GradeBox extends StatefulWidget {
  const GradeBox({Key? key}) : super(key: key);

  @override
  State<GradeBox> createState() => _GradeBoxState();
}

class _GradeBoxState extends BaseStatefulState<GradeBox> {
  final viewModel = GradeBoxViewModel();
  late Future<GradeBoxModel> init;

  @override
  void initState() {
    super.initState();
    init = viewModel.getGradeBox();
  }

  @override
  Widget build(BuildContext context) {
    log('path: ${GoRouterState.of(context).matchedLocation}', name: 'GradeBox');
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) => FutureBuilder<GradeBoxModel>(
        future: init,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(child: kDebugMode ? Text('not done') : null);
          }
          if (!snapshot.hasData) {
            return const SizedBox(child: kDebugMode ? Text('not true') : null);
          }
          final data = snapshot.data!;
          return _GradeBoxLoaded(model: data);
        },
      ),
    );
  }
}

class _GradeBoxLoaded extends StatefulWidget {
  final GradeBoxModel model;

  const _GradeBoxLoaded({required this.model});

  @override
  State<_GradeBoxLoaded> createState() => _GradeBoxLoadedState();
}

class _GradeBoxLoadedState extends State<_GradeBoxLoaded> {
  static const titleImageUrl = 'https://pay.x50.fun/static/grade/gdebox.png';
  final tabs = const <Widget>[
    Tab(text: '全部'),
    Tab(text: '卡片'),
    Tab(text: '物料'),
    Tab(text: '專輯'),
    Tab(text: 'X50')
  ];
  late List<Widget> tabViews;

  @override
  void initState() {
    super.initState();

    tabViews = [
      _BoxTab(items: widget.model.all),
      _BoxTab(items: widget.model.card),
      _BoxTab(items: widget.model.gifts),
      _BoxTab(items: widget.model.cd),
      _BoxTab(items: widget.model.x50),
    ];
  }

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
                            Text('養成商場', style: TextStyle(fontSize: 17)),
                            Text('點數兌換商品',
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
          Expanded(
            child: Consumer<GradeBoxViewModel>(
              builder: (context, value, child) {
                return TabBarView(
                  children: tabViews,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
