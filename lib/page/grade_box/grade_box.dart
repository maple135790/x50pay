import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/grade_box/grade_box.dart';
import 'package:x50pay/page/grade_box/box_tab.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class GradeBox extends StatefulWidget {
  /// 養成商場頁面
  const GradeBox({super.key});

  @override
  State<GradeBox> createState() => _GradeBoxState();
}

class _GradeBoxState extends BaseStatefulState<GradeBox> {
  final repo = Repository();
  late final viewModel = GradeBoxViewModel(repository: repo);
  late Future<GradeBoxModel> init;

  @override
  void initState() {
    super.initState();
    init = viewModel.getGradeBox();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) => FutureBuilder<GradeBoxModel>(
        future: init,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: kDebugMode ? Text('not done') : null);
          }
          if (!snapshot.hasData) {
            return Center(child: kDebugMode ? Text(serviceErrorText) : null);
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

class _GradeBoxLoadedState extends BaseStatefulState<_GradeBoxLoaded> {
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
      GradeBoxTab(items: widget.model.all),
      GradeBoxTab(items: widget.model.card),
      GradeBoxTab(items: widget.model.gifts),
      GradeBoxTab(items: widget.model.cd),
      GradeBoxTab(items: widget.model.x50),
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
                      color: isDarkTheme
                          ? const Color.fromARGB(12, 255, 255, 255)
                          : const Color.fromARGB(12, 0, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      height: 89.19,
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('養成商場', style: TextStyle(fontSize: 17)),
                            Text('點數兌換商品',
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
