import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/account/record_mixin.dart';

class BidRecords extends StatefulWidget {
  /// 儲值紀錄頁面
  const BidRecords({super.key});

  @override
  State<BidRecords> createState() => _BidRecordsState();
}

class _BidRecordsState extends BaseStatefulState<BidRecords>
    with RecordPageMixin<BidLogModel, BidRecords> {
  @override
  String pageTitle() => '近兩個月的儲值紀錄如下';

  @override
  Future<BidLogModel> getRecord() =>
      context.read<AccountViewModel>().getBidLog();

  @override
  List<DataColumn> buildColumns() =>
      ['時間', '儲值金額'].map((e) => DataColumn(label: Text(e))).toList();

  @override
  List<DataRow> buildRows(BidLogModel model) {
    List<DataRow> rows = [];
    for (BidLog log in model.logs) {
      rows.add(DataRow(cells: [
        DataCell(Text(log.time!)),
        DataCell(Text(log.point!.toInt().toString())),
      ]));
    }
    return rows;
  }

  @override
  bool hasData(model) => model.logs.isNotEmpty;
}
