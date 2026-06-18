import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/sliver_padding_injector.dart';
import 'package:x50pay/gen/assets.gen.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/event_info/event_info.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/page/home/mari_info/mari_info.dart';
import 'package:x50pay/page/home/official_info.dart';
import 'package:x50pay/page/home/recent_quests.dart';
import 'package:x50pay/page/home/ticket_info.dart';
import 'package:x50pay/page/home/top_info.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/user_provider.dart';

class Home extends StatefulWidget {
  /// 首頁
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AppThemeMixin, AppFeedbackMixin {
  late final HomeViewModel viewModel;

  late Future<bool> initHome;

  @override
  void initState() {
    super.initState();
    viewModel = HomeViewModel(
      userProvider: context.read<UserProvider>(),
      entryProvider: context.read<EntryProvider>(),
    )..isFunctionalHeader = false;
    initHome = viewModel.initHome();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return FutureBuilder(
          future: initHome,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            if (snapshot.hasError || snapshot.data == false) {
              showServiceError();
              return Center(child: Text(serviceErrorText));
            }

            return _HomeLoaded(
              onRefresh: () async {
                initHome = viewModel.initHome();
              },
            );
          },
        );
      },
    );
  }
}

class _HomeLoaded extends StatelessWidget {
  final Future<void> Function() onRefresh;
  const _HomeLoaded({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final themeHelper = AppThemeHelper(context);
    Widget divider(String title) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Row(
          children: [
            Expanded(child: Divider(color: themeHelper.borderColor)),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 16),
            Expanded(child: Divider(color: themeHelper.borderColor)),
          ],
        ),
      );
    }

    Widget buildRefreshIndicator(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
    ) {
      final statusBarHeight = MediaQuery.paddingOf(context).top;
      return Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: CupertinoSliverRefreshControl.buildRefreshIndicator(
          context,
          refreshState,
          pulledExtent,
          refreshTriggerPullDistance,
          refreshIndicatorExtent,
        ),
      );
    }

    return Selector<EntryProvider, EntryModel?>(
      selector: (context, provider) => provider.entry,
      builder: (context, entry, child) {
        final i18n = S.of(context);
        final recentQuests = entry?.questCampaign ?? [];
        final events = entry?.evlist;
        final double statusBarHeight = MediaQuery.paddingOf(context).top;

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 40 + statusBarHeight,
              refreshIndicatorExtent: 30 + statusBarHeight,
              onRefresh: onRefresh,
              builder: buildRefreshIndicator,
            ),
            SliverPaddingAutoInjector(
              slivers: [
                SliverList.list(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0x40ffffff), Colors.transparent],
                          stops: [0, 0.25],
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: R.images.home.topBackground.womdMin.provider(),
                        ),
                      ),
                      child: const Column(
                        children: [
                          SizedBox(height: 10),
                          TopInfo(),
                          TicketInfo(),
                        ],
                      ),
                    ),
                    const MariInfo(),
                    if (events != null && events.isNotEmpty)
                      EventInfo(events: events),
                    if (recentQuests.isNotEmpty) divider(i18n.infoNotify),
                    if (recentQuests.isNotEmpty)
                      RecentQuests(quests: recentQuests),
                    divider(i18n.officialNotify),
                    const OfficialInfo(),
                    const SizedBox(height: 25),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
