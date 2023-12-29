import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/page/home/event_info.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/page/home/mari_info.dart';
import 'package:x50pay/page/home/official_info.dart';
import 'package:x50pay/page/home/recent_quests.dart';
import 'package:x50pay/page/home/ticket_info.dart';
import 'package:x50pay/page/home/top_info.dart';
import 'package:x50pay/repository/repository.dart';

class Home extends StatefulWidget {
  /// 首頁
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends BaseStatefulState<Home> {
  final repo = Repository();
  late final HomeViewModel viewModel;

  var refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(repository: repo)..isFunctionalHeader = false;
  }

  Future<void> onRefresh() async {
    refreshKey = GlobalKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: scaffoldBackgroundColor,
      child: RefreshIndicator(
        displacement: 80,
        onRefresh: onRefresh,
        child: ChangeNotifierProvider.value(
          value: viewModel,
          builder: (context, child) => FutureBuilder(
            future: viewModel.initHome(),
            key: refreshKey,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (snapshot.hasError || snapshot.data == false) {
                showServiceError();
                return Center(child: Text(serviceErrorText));
              }
              return const Scrollbar(
                child: SingleChildScrollView(
                  child: _HomeLoaded(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeLoaded extends StatefulWidget {
  const _HomeLoaded();

  @override
  State<_HomeLoaded> createState() => _HomeLoadedState();
}

class _HomeLoadedState extends BaseStatefulState<_HomeLoaded> {
  Widget divider(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Row(
        children: [
          Expanded(child: Divider(color: borderColor)),
          Text(' $title '),
          Expanded(child: Divider(color: borderColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GlobalSingleton.instance.entryNotifier,
      builder: (context, entry, child) {
        final recentQuests = entry?.questCampaign;
        final events = entry?.evlist;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const TopInfo(),
            const TicketInfo(),
            const MariInfo(),
            if (events != null && events.isNotEmpty) EventInfo(events: events),
            if (recentQuests != null) divider(i18n.infoNotify),
            if (recentQuests != null) RecentQuests(quests: recentQuests),
            divider(i18n.officialNotify),
            const OfficialInfo(),
            const SizedBox(height: 25),
          ],
        );
      },
    );
  }
}
