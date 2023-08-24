import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/r.g.dart';

class PlayRecords extends StatefulWidget {
  const PlayRecords({super.key});

  @override
  State<PlayRecords> createState() => _PlayRecordsState();
}

class _PlayRecordsState extends BaseStatefulState<PlayRecords> {
  late AccountViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, vm, child) {
        viewModel = vm;

        return Material(
          child: FutureBuilder(
            future: viewModel.getPlayRecord(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (snapshot.data == false) {
                return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
              }
              if (viewModel.playRecordModel!.code != 200) {
                return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
              }
              return playRecordLoaded(viewModel.playRecordModel!);
            },
          ),
        );
      },
    );
  }

  Widget playRecordLoaded(PlayRecordModel model) {
    bool hasData = model.logs.isNotEmpty;

    List<DataRow> buildRows() {
      List<DataRow> rows = [];
      for (PlayLog log in model.logs) {
        String cab = '${log.mid}-${log.cid}號機';
        if (cab.length > 20) cab = '${log.mid}-\n${log.cid}號機';
        rows.add(DataRow(cells: [
          DataCell(Text(log.time)),
          DataCell(
            Text(
              cab,
              textScaleFactor: cab.length > 20 ? 0.9 : 1,
            ),
          ),
          DataCell(Text('${log.price.toInt()}P')),
        ]));
      }
      return rows;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Themes.borderColor)),
              child: Row(
                children: [
                  CircleAvatar(
                      foregroundImage: R.image.logo_150_jpg(), radius: 29),
                  const SizedBox(width: 16.8),
                  const Text('近兩個月的扣點明細如下', style: TextStyle(fontSize: 18))
                ],
              ),
            ),
            const SizedBox(height: 12),
            hasData
                ? FittedBox(
                    child: DataTable(
                      border:
                          TableBorder.all(color: Themes.borderColor, width: 1),
                      dataRowMaxHeight: 60,
                      horizontalMargin: 12,
                      columnSpacing: 25,
                      columns: ['日期', '機台', '使用點數']
                          .map((e) => DataColumn(
                              label: Expanded(child: Text(e, softWrap: true))))
                          .toList(),
                      rows: buildRows(),
                    ),
                  )
                : const Center(child: Text('無資料')),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
