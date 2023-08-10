part of "../account.dart";

class TicketUsedRecords extends StatefulWidget {
  final AccountViewModel viewModel;

  const TicketUsedRecords(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<TicketUsedRecords> createState() => _TicketUsedRecordsState();
}

class _TicketUsedRecordsState extends BaseStatefulState<TicketUsedRecords> {
  late AccountViewModel model;

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: model.getTicUsedLog(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }
          if (snapshot.data == false) {
            scaffoldKey.currentState!.showSnackBar(
                const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
            return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
          }
          if (model.ticUsedModel!.code != 200) {
            scaffoldKey.currentState!.showSnackBar(
                const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
            return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
          }
          return ticUsedRecordLoaded(model.ticUsedModel!);
        },
      ),
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
          ],
        ),
      ),
    );
  }
}
