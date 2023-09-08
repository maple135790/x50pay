import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/account/record_mixin.dart';

class PlayRecords extends StatefulWidget {
  const PlayRecords({super.key});

  @override
  State<PlayRecords> createState() => _PlayRecordsState();
}

class _PlayRecordsState extends BaseStatefulState<PlayRecords>
    with RecordPageMixin<PlayRecordModel, PlayRecords> {
  @override
  String pageTitle() => '近兩個月的扣點明細如下';

  @override
  Future<PlayRecordModel> getRecord() =>
      context.read<AccountViewModel>().getPlayRecord();

  @override
  List<DataColumn> buildColumns() => ['日期', '機台', '使用點數']
      .map((e) => DataColumn(label: Expanded(child: Text(e, softWrap: true))))
      .toList();

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
            textScaleFactor: cab.length > 20 ? 0.9 : 1,
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
