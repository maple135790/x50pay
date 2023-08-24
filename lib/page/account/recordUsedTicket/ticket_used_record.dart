import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/r.g.dart';

class TicketUsedRecords extends StatefulWidget {
  const TicketUsedRecords({super.key});

  @override
  State<TicketUsedRecords> createState() => _TicketUsedRecordsState();
}

class _TicketUsedRecordsState extends BaseStatefulState<TicketUsedRecords> {
  late AccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, vm, child) {
        viewModel = vm;

        return Material(
          child: FutureBuilder(
            future: viewModel.getTicUsedLog(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (snapshot.data == false) {
                return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
              }
              if (viewModel.ticUsedModel!.code != 200) {
                return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
              }
              return ticUsedRecordLoaded(viewModel.ticUsedModel!);
            },
          ),
        );
      },
    );
  }

  Widget ticUsedRecordLoaded(TicUsedModel model) {
    bool hasData = model.logs.isNotEmpty;

    List<DataRow> buildRows() {
      List<DataRow> rows = [];
      for (TicUsedLog log in model.logs) {
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
          const DataCell(Text('1張')),
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
                  border: Border.all(color: Themes.borderColor, width: 1)),
              child: Row(
                children: [
                  CircleAvatar(
                      foregroundImage: R.image.logo_150_jpg(), radius: 29),
                  const SizedBox(width: 16.8),
                  const Text('近兩個月的遊玩券使用明細如下', style: TextStyle(fontSize: 18))
                ],
              ),
            ),
            const SizedBox(height: 12),
            hasData
                ? DataTable(
                    border: TableBorder.all(color: Themes.borderColor),
                    dataRowMaxHeight: 60,
                    horizontalMargin: 12,
                    columnSpacing: 25,
                    columns: ['日期', '機台', '消耗']
                        .map((e) => DataColumn(
                            label: Expanded(child: Text(e, softWrap: true))))
                        .toList(),
                    rows: buildRows(),
                  )
                : const Center(child: Text('無資料')),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
