import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/free_p/free_p.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/account/record_mixin.dart';

class FreePointRecords extends StatefulWidget {
  const FreePointRecords({super.key});

  @override
  State<FreePointRecords> createState() => _FreePointRecordsState();
}

class _FreePointRecordsState extends BaseStatefulState<FreePointRecords>
    with RecordPageMixin<FreePointModel, FreePointRecords> {
  late AccountViewModel viewModel;

  @override
  List<DataColumn> buildColumns() =>
      ['獲得數量', '剩餘', '使用期限'].map((e) => DataColumn(label: Text(e))).toList();

  @override
  List<DataRow> buildRows(FreePointModel model) {
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

  @override
  Future<FreePointModel> getRecord() =>
      context.read<AccountViewModel>().getFreePointRecord();

  @override
  bool hasData(FreePointModel model) => model.logs.isNotEmpty;

  @override
  String pageTitle() => '回饋點數明細如下';
}
