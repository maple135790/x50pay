import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/page/settings/record_mixin.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';

class TicketUsedRecords extends StatefulWidget {
  const TicketUsedRecords({super.key});

  @override
  State<TicketUsedRecords> createState() => _TicketUsedRecordsState();
}

class _TicketUsedRecordsState extends BaseStatefulState<TicketUsedRecords>
    with RecordPageMixin<TicUsedModel, TicketUsedRecords> {
  @override
  List<DataColumn> buildColumns() => ['日期', '機台', '消耗']
      .map((e) => DataColumn(label: Expanded(child: Text(e, softWrap: true))))
      .toList();
  @override
  List<DataRow> buildRows(TicUsedModel model) {
    List<DataRow> rows = [];
    for (TicUsedLog log in model.logs) {
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
        const DataCell(Text('1張')),
      ]));
    }
    return rows;
  }

  @override
  Future<TicUsedModel> getRecord() =>
      context.read<SettingsViewModel>().getTicUsedLog();

  @override
  bool hasData(TicUsedModel model) => model.logs.isNotEmpty;

  @override
  String pageTitle() => '近兩個月的遊玩券使用明細如下';
}
