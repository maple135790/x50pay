import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/providers/app_settings_provider.dart';

enum SummarizePeriod {
  twoMonth(60),
  oneMonth(30),
  oneWeek(7);

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

  @override
  void initState() {
    super.initState();
  }

  void onChangeShowPointSummary() {
    isShowPointSummary = !isShowPointSummary;
    setState(() {});
  }

  void onChangeShowFavGameSummary() {
    isShowFavGameSummary = !isShowFavGameSummary;
    setState(() {});
  }

  void showAllGameSummaries(
    List<GameSummary> gameSummaries,
    String? favGameName,
  ) async {
    final appSettingsProvider = context.read<AppSettingsProvider>();
    final selectedFavGameName = await showDialog<String>(
      context: context,
      builder: (context) {
        String selectedFavGame = favGameName ?? '';

        return StatefulBuilder(
          builder: (context, setState) {
            return PopScope(
              canPop: true,
              child: AlertDialog(
                title: const Text('詳細機種別'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(selectedFavGame);
                    },
                    child: const Text('關閉'),
                  )
                ],
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('設定喜好機台'),
                    Flexible(
                      child: Wrap(
                        children: gameSummaries
                            .map((e) => Padding(
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
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text('機種別紀錄:'),
                    ...gameSummaries.map((e) => Text(
                        '${e.gameName} : ${e.playCount}次，共${e.totalPoints}'))
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    log('selectedFavGameName: $selectedFavGameName', name: 'PlayRecords');
    if (selectedFavGameName == null || selectedFavGameName.isEmpty) return;

    appSettingsProvider.setFavGameName(selectedFavGameName);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Align(alignment: Alignment.topCenter, child: Text('計算期間  ')),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: [
                  i18n.summaryPeriod60,
                  i18n.summaryPeriod30,
                  i18n.summaryPeriod7
                ]
                    .mapIndexed(
                      (index, element) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ChoiceChip(
                          label: Text(element),
                          selected:
                              selectedPeriod == SummarizePeriod.values[index],
                          onSelected: (value) {
                            selectedPeriod = SummarizePeriod.values[index];
                            isShowPointSummary = false;
                            isShowFavGameSummary = false;
                            setState(() {});
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: pointSummary(),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Consumer<AppSettingsProvider>(
                builder: (context, vm, child) {
                  var summary = gameSummaries.firstWhereOrNull(
                      (element) => element.gameName == vm.favGameName);
                  var favGameSummary =
                      "${vm.favGameName}\n${summary?.playCount ?? 0}次，共${summary?.totalPoints ?? "0P"}";

                  return FutureBuilder(
                      future: vm.getFavGameName(),
                      builder: (context, snapshot) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: InkWell(
                            onLongPress: () {
                              showAllGameSummaries(
                                gameSummaries,
                                vm.favGameName,
                              );
                            },
                            onTap: vm.favGameName != null
                                ? onChangeShowFavGameSummary
                                : () {},
                            child: buildGameSummary(
                              hasSetFavGame: vm.favGameName != null,
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
      color: Theme.of(context).colorScheme.surfaceVariant,
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
                const Text('使用點數'),
                const SizedBox(height: 8),
                Text(
                  isShowPointSummary ? periodPoints ?? '無資料' : "***",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child:
                      isShowPointSummary ? const Text('隱藏') : const Text('顯示'),
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
                  const Text('機種別'),
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
                        ? const Text('隱藏')
                        : const Text('顯示'),
                  )
                ],
              )
            : const Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('機種別'),
                  SizedBox(height: 8),
                  Text(
                    "可設定喜好機台",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )),
      ),
    );
  }
}
