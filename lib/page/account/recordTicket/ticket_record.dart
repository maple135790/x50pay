import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/r.g.dart';

class TicketRecords extends StatefulWidget {
  /// 獲券紀錄頁面
  const TicketRecords({super.key});

  @override
  State<TicketRecords> createState() => _TicketRecordsState();
}

class _TicketRecordsState extends BaseStatefulState<TicketRecords> {
  late AccountViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, vm, child) {
        viewModel = vm;

        return Material(
          child: FutureBuilder(
            future: viewModel.getTicketLog(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox();
              }
              if (snapshot.data == false) {
                return Center(child: Text(serviceErrorText));
              }
              if (viewModel.ticDateLogModel!.code != 200) {
                return Center(child: Text(serviceErrorText));
              }
              return ticketRecordLoaded(viewModel.ticDateLogModel!);
            },
          ),
        );
      },
    );
  }

  Widget ticketRecordLoaded(TicDateLogModel model) {
    bool hasData = model.logs.isNotEmpty;

    List<DataRow> buildRows() {
      List<DataRow> rows = [];
      for (List log in model.logs) {
        final String eventName = log[1];
        final String expDate = log[2];
        final String remainCount = log[0].toString();
        String? details;
        dynamic maybeString = log.last;
        if (maybeString is String) details = maybeString;

        rows.add(DataRow(cells: [
          DataCell(Text(eventName)),
          DataCell(Text(expDate)),
          DataCell(Text(remainCount)),
          DataCell(Text(details ?? '')),
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
                  const Text('以下是您尚未使用的遊玩券記錄', style: TextStyle(fontSize: 18))
                ],
              ),
            ),
            const SizedBox(height: 12),
            hasData
                ? FittedBox(
                    child: DataTable(
                      border: TableBorder.all(color: Themes.borderColor),
                      dataRowMaxHeight: 60,
                      horizontalMargin: 12,
                      columnSpacing: 25,
                      columns: ['活動名稱', '過期日', '剩餘張數', '詳情']
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
