import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/r.g.dart';

class FreePRecords extends StatefulWidget {
  const FreePRecords({super.key});

  @override
  State<FreePRecords> createState() => _FreePRecordsState();
}

class _FreePRecordsState extends BaseStatefulState<FreePRecords> {
  late AccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, vm, child) {
        viewModel = vm;

        return Material(
          child: FutureBuilder(
            future: viewModel.getFreePRecord(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (snapshot.hasError) {
                return Center(child: Text(serviceErrorText));
              }
              final model = snapshot.data!;
              if (model.code != 200) {
                return Center(child: Text(serviceErrorText));
              }
              return freePRecordLoaded(model);
            },
          ),
        );
      },
    );
  }

  Widget freePRecordLoaded(FreePModel model) {
    bool hasData = model.logs.isNotEmpty;

    List<DataRow> buildRows() {
      List<DataRow> rows = [];
      for (var log in model.logs) {
        rows.add(DataRow(cells: [
          DataCell(Text('${log.fpoint.toInt()}P')),
          DataCell(Text('${log.much.toInt()}P')),
          DataCell(Text(log.limitTime)),
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
                  const Text('回饋點數明細如下', style: TextStyle(fontSize: 18))
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
                    columns: ['獲得數量', '剩餘', '使用期限']
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
