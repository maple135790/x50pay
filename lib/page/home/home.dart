import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/common/app_theme_mixin.dart';
import 'package:x50pay/common/models/entry/entry.dart';
import 'package:x50pay/common/sliver_padding_injector.dart';
import 'package:x50pay/generated/l10n.dart';
import 'package:x50pay/page/home/event_info/event_info.dart';
import 'package:x50pay/page/home/home_view_model.dart';
import 'package:x50pay/page/home/mari_info/mari_info.dart';
import 'package:x50pay/page/home/official_info.dart';
import 'package:x50pay/page/home/recent_quests.dart';
import 'package:x50pay/page/home/ticket_info/ticket_info.dart';
import 'package:x50pay/page/home/top_info.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/home_background_provider.dart';
import 'package:x50pay/providers/home_refresh_provider.dart';
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
    context.read<HomeRefreshProvider>().registerRefreshCallback(() {
      initHome = viewModel.initHome();
    });
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

            return const _HomeLoaded();
          },
        );
      },
    );
  }
}

class _HomeLoaded extends StatelessWidget {
  const _HomeLoaded();

  @override
  Widget build(BuildContext context) {
    final themeHelper = AppThemeHelper(context);
    final statusBarHeight = MediaQuery.paddingOf(context).top;

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

    Future<void> onRefresh() async {
      context.read<HomeRefreshProvider>().refresh();
    }

    return Selector<EntryProvider, EntryModel?>(
      selector: (context, provider) => provider.entry,
      builder: (context, entry, child) {
        final i18n = S.of(context);
        final recentQuests = entry?.questCampaign ?? [];
        final events = entry?.evlist;

        final infoWithBackground = Selector<HomeBackgroundProvider, Uri>(
          selector: (context, provider) => provider.backgroundUri,
          builder: (context, uri, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0x40ffffff), Colors.transparent],
                  stops: [0, 0.25],
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                  image: CachedNetworkImageProvider(
                    maxHeight: 800,
                    maxWidth: 800,
                    uri.toString(),
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: statusBarHeight),
                  const TopInfo(),
                  TicketInfo(entry?.stamps),
                ],
              ),
            );
          },
        );

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                refreshTriggerPullDistance: 80 + statusBarHeight,
                refreshIndicatorExtent: 60 + statusBarHeight,
                onRefresh: onRefresh,
                builder: buildRefreshIndicator,
              ),
              SliverPaddingAutoInjector(
                slivers: [
                  SliverList.list(
                    children: [
                      RepaintBoundary(child: infoWithBackground),
                      const RepaintBoundary(child: MariInfo()),
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
          ),
        );
      },
    );
  }
}
