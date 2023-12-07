import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/page/settings/record_mixin.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/providers/app_settings_provider.dart';

enum SummarizePeriod {
  twoMonth(60),
  oneMonth(30),
  oneWeek(7);

  final int day;

  const SummarizePeriod(this.day);
}

class PlayRecords extends StatefulWidget {
  const PlayRecords({super.key});

  @override
  State<PlayRecords> createState() => _PlayRecordsState();
}

class _PlayRecordsState extends BaseStatefulState<PlayRecords>
    with RecordPageMixin<PlayRecordModel, PlayRecords> {
  SummarizePeriod selectedPeriod = SummarizePeriod.oneWeek;
  bool isShowPointSummary = false;
  bool isShowFavGameSummary = false;

  @override
  String pageTitle() => '近兩個月的扣點明細如下';

  @override
  Future<PlayRecordModel> getRecord() =>
      context.read<SettingsViewModel>().getPlayRecord();

  @override
  List<DataColumn> buildColumns() => ['日期', '機台', '使用點數']
      .map((e) => DataColumn(label: Expanded(child: Text(e, softWrap: true))))
      .toList();

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
            return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop(selectedFavGame);
                return true;
              },
              child: AlertDialog(
                title: Text('詳細機種別'),
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
                    Text('設定喜好機台'),
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
                    const SizedBox(height: 10),
                    Text('機種別紀錄:'),
                    ...gameSummaries
                        .map((e) => Text(
                            '${e.gameName} : ${e.playCount}次，共${e.totalPoints}'))
                        .toList()
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
  Widget summarizedInfo(PlayRecordModel model) {
    var periodPoints = model.getPeriodPoints(selectedPeriod.day);
    var gameSummaries = model.getGameSummaries(selectedPeriod.day);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text('計算期間  '),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  i18n.summaryPeriod60,
                  i18n.summaryPeriod30,
                  i18n.summaryPeriod7
                ]
                    .mapIndexed(
                      (index, element) => ChoiceChip(
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
              child: Card(
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
                          Text('使用點數'),
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
                            child: isShowPointSummary ? Text('隱藏') : Text('顯示'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                                  gameSummaries, vm.favGameName);
                            },
                            onTap: vm.favGameName != null
                                ? onChangeShowFavGameSummary
                                : () {},
                            child: SizedBox(
                              height: 125,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: vm.favGameName != null
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('機種別'),
                                          const SizedBox(height: 8),
                                          Text(
                                            isShowFavGameSummary
                                                ? favGameSummary
                                                : "***",
                                            style: TextStyle(
                                              fontSize: isShowFavGameSummary
                                                  ? 14
                                                  : 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const Spacer(),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: isShowFavGameSummary
                                                ? Text('隱藏')
                                                : Text('顯示'),
                                          )
                                        ],
                                      )
                                    : Center(
                                        child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('機種別'),
                                          const SizedBox(height: 8),
                                          Text(
                                            "可設定喜好機台",
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      )),
                              ),
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

  @override
  List<DataRow> buildRows(PlayRecordModel model) {
    List<DataRow> rows = [];
    for (PlayLog log in model.logs) {
      String cab = '${log.mid}-${log.cid}號機';
      if (cab.length > 20) cab = '${log.mid}-\n${log.cid}號機';
      rows.add(DataRow(cells: [
        DataCell(Text(log.time)),
        DataCell(
          Text(
            cab,
            textScaler: TextScaler.linear(cab.length > 20 ? 0.9 : 1),
          ),
        ),
        DataCell(Text('${log.price.toInt()}+${log.freep.toInt()}P')),
      ]));
    }
    return rows;
  }

  @override
  bool hasData(PlayRecordModel model) => model.logs.isNotEmpty;
}
