import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/r.g.dart';

class BidRecords extends StatefulWidget {
  const BidRecords({super.key});

  @override
  State<BidRecords> createState() => _BidRecordsState();
}

class _BidRecordsState extends BaseStatefulState<BidRecords> {
  late AccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, vm, child) {
        viewModel = vm;

        return Material(
          child: FutureBuilder(
            future: viewModel.getBidLog(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (snapshot.data == false) {
                return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
              }
              if (viewModel.bidModel!.code != 200) {
                return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
              }
              return bidRecordLoaded(viewModel.bidModel!);
            },
          ),
        );
      },
    );
  }

  Widget bidRecordLoaded(BidLogModel model) {
    bool hasData = model.logs.isNotEmpty;

    List<DataRow> buildRows() {
      List<DataRow> rows = [];
      for (BidLog log in model.logs) {
        rows.add(DataRow(cells: [
          DataCell(Text(log.time!)),
          DataCell(Text(log.point!.toInt().toString())),
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
                  const Text('近兩個月的儲值紀錄如下', style: TextStyle(fontSize: 18))
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
                    columns: ['時間', '儲值金額']
                        .map((e) => DataColumn(label: Text(e)))
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
