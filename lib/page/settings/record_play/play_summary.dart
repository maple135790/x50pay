import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/providers/app_settings_provider.dart';

enum SummarizePeriod {
  all(-1),
  twoMonth(60),
  oneMonth(30),
  oneWeek(7);

  /// 這個值代表幾天，-1代表全部
  final int day;

  const SummarizePeriod(this.day);
}

class PlaySummary extends StatefulWidget {
  final PlayRecordModel model;
  const PlaySummary({required this.model, super.key});

  @override
  State<PlaySummary> createState() => _PlaySummaryState();
}

class _PlaySummaryState extends BaseStatefulState<PlaySummary> {
  SummarizePeriod selectedPeriod = SummarizePeriod.twoMonth;
  bool isShowPointSummary = false;
  bool isShowFavGameSummary = false;
  String? get periodPoints => widget.model.getPeriodPoints(selectedPeriod.day);
  List<GameSummary> get gameSummaries =>
      widget.model.getGameSummaries(selectedPeriod.day);

  void onChangeShowPointSummary() {
    isShowPointSummary = !isShowPointSummary;
    setState(() {});
  }

  void onChangeShowFavGameSummary() {
    isShowFavGameSummary = !isShowFavGameSummary;
    setState(() {});
  }

  void showAllGameSummaries(String? favGameName) async {
    final appSettingsProvider = context.read<AppSettingsProvider>();

    void saveFavGameName(String? favGameName) async {
      log('selectedFavGameName: $favGameName', name: 'PlayRecords');

      // 這裡需要postFrameCallback，因為modal會先關閉，再執行這裡的code
      // 否則這裡的Widget tree 會被lock 住，無法setState
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appSettingsProvider.setFavGameName(favGameName);
        return;
      });
    }

    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: true,
      context: context,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: scaffoldBackgroundColor,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.8,
          builder: (context, scrollController) => SummaryFavGameModal(
            gameSummaries: gameSummaries,
            period: selectedPeriod,
            scrollController: scrollController,
            currentFavGameName: favGameName,
            onFavGameChanged: saveFavGameName,
          ),
        );
      },
    );
  }

  List<Widget> buildPeriodChips() {
    return [
      i18n.summaryPeriodAll,
      i18n.summaryPeriod60,
      i18n.summaryPeriod30,
      i18n.summaryPeriod7,
    ]
        .mapIndexed(
          (index, element) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ChoiceChip(
              label: Text(element),
              selected: selectedPeriod == SummarizePeriod.values[index],
              onSelected: (value) {
                selectedPeriod = SummarizePeriod.values[index];
                isShowPointSummary = false;
                isShowFavGameSummary = false;
                setState(() {});
              },
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(i18n.summaryPeriod),
            ),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: buildPeriodChips(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: pointSummary()),
            const SizedBox(width: 15),
            Expanded(
              child: Consumer<AppSettingsProvider>(
                builder: (context, vm, child) {
                  var summary = gameSummaries.firstWhereOrNull(
                      (element) => element.gameName == vm.favGameName);

                  var favGameSummary =
                      "${vm.favGameName}\n${i18n.summaryGameRecordRecord(summary?.playCount ?? 0, summary?.totalPoints ?? "0P")}";

                  return FutureBuilder(
                      future: vm.getSummaryFavGameName(),
                      builder: (context, snapshot) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: InkWell(
                            onLongPress: () {
                              showAllGameSummaries(vm.favGameName);
                            },
                            onTap: vm.favGameName != null
                                ? onChangeShowFavGameSummary
                                : () {},
                            child: buildGameSummary(
                              hasSetFavGame:
                                  vm.favGameName?.isNotEmpty ?? false,
                              favGameSummary: favGameSummary,
                            ),
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  Card pointSummary() {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: InkWell(
        onTap: onChangeShowPointSummary,
        child: SizedBox(
          height: 125,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(i18n.summaryPoint),
                const SizedBox(height: 8),
                Text(
                  isShowPointSummary
                      ? periodPoints ?? i18n.summaryNoData
                      : "***",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: isShowPointSummary
                      ? Text(i18n.summaryHide)
                      : Text(i18n.summaryShow),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildGameSummary({
    required bool hasSetFavGame,
    required String favGameSummary,
  }) {
    return SizedBox(
      height: 125,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: hasSetFavGame
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(i18n.summaryGame),
                  const SizedBox(height: 8),
                  Text(
                    isShowFavGameSummary ? favGameSummary : "***",
                    style: TextStyle(
                      fontSize: isShowFavGameSummary ? 14 : 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: isShowFavGameSummary
                        ? Text(i18n.summaryHide)
                        : Text(i18n.summaryShow),
                  )
                ],
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(i18n.summaryGame),
                  const SizedBox(height: 8),
                  Text(
                    i18n.summaryGameFavGameSetup,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )),
      ),
    );
  }
}

class SummaryFavGameModal extends StatefulWidget {
  final List<GameSummary> gameSummaries;
  final ScrollController scrollController;
  final String? currentFavGameName;
  final SummarizePeriod period;
  final void Function(String? value) onFavGameChanged;

  const SummaryFavGameModal({
    super.key,
    required this.gameSummaries,
    required this.period,
    required this.scrollController,
    required this.currentFavGameName,
    required this.onFavGameChanged,
  });

  @override
  State<SummaryFavGameModal> createState() => _SummaryFavGameModalState();
}

class _SummaryFavGameModalState extends BaseStatefulState<SummaryFavGameModal> {
  String selectedFavGame = '';

  @override
  void initState() {
    super.initState();
    selectedFavGame = widget.currentFavGameName ?? '';
  }

  @override
  void dispose() {
    widget.onFavGameChanged.call(selectedFavGame);
    super.dispose();
  }

  List<Widget> buildFavGameChips() {
    if (widget.gameSummaries.isEmpty) {
      return [Text(i18n.summaryGameNoData)];
    }
    return widget.gameSummaries
        .map((e) => Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(e.gameName),
                  visualDensity: VisualDensity.compact,
                  selected: selectedFavGame == e.gameName,
                  onSelected: (value) {
                    if (!value) {
                      selectedFavGame = '';
                    } else {
                      selectedFavGame = e.gameName;
                    }
                    setState(() {});
                  },
                ),
              ),
            ))
        .toList();
  }

  List<Widget> buildGameRecords() {
    if (widget.gameSummaries.isEmpty) {
      return [Text(i18n.summaryGameNoData)];
    }
    return widget.gameSummaries
        .map((e) => Text(
            '${e.gameName} : ${i18n.summaryGameRecordRecord(e.playCount, e.totalPoints)}'))
        .toList();
  }

  String getPeriodString() {
    switch (widget.period) {
      case SummarizePeriod.twoMonth:
        return i18n.summaryPeriod60;
      case SummarizePeriod.oneMonth:
        return i18n.summaryPeriod30;
      case SummarizePeriod.oneWeek:
        return i18n.summaryPeriod7;
      case SummarizePeriod.all:
        return i18n.summaryPeriodAll;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      controller: widget.scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            i18n.summaryGameFavGame,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          ...buildFavGameChips(),
          const SizedBox(height: 25),
          const Divider(),
          const SizedBox(height: 25),
          Text(
            '${getPeriodString()} ${i18n.summaryGameRecordTitle}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          ...buildGameRecords(),
        ],
      ),
    );
  }
}
