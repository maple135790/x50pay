import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/page/settings/record_mixin.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';

class TicketRecords extends StatefulWidget {
  /// 獲券紀錄頁面
  const TicketRecords({super.key});

  @override
  State<TicketRecords> createState() => _TicketRecordsState();
}

class _TicketRecordsState extends BaseStatefulState<TicketRecords>
    with RecordPageMixin<TicDateLogModel, TicketRecords> {
  @override
  String pageTitle() => '以下是您尚未使用的遊玩券記錄';

  @override
  Future<TicDateLogModel> getRecord() =>
      context.read<SettingsViewModel>().getTicketLog();

  @override
  List<DataColumn> buildColumns() => ['活動名稱', '過期日', '剩餘張數', '詳情']
      .map((e) => DataColumn(label: Expanded(child: Text(e, softWrap: true))))
      .toList();

  @override
  List<DataRow> buildRows(TicDateLogModel model) {
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

  @override
  bool hasData(model) => model.logs.isNotEmpty;
}
