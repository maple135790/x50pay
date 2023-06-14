part of "../account.dart";

class _TicketUsedRecord extends StatefulWidget {
  final AccountViewModel viewModel;

  const _TicketUsedRecord(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<_TicketUsedRecord> createState() => __TicketUsedRecordState();
}

class __TicketUsedRecordState extends BaseStatefulState<_TicketUsedRecord>
    with BaseLoaded {
  late AccountViewModel model;

  @override
  BaseViewModel? baseViewModel() => widget.viewModel;

  @override
  bool get disableBottomNavigationBar => true;

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
  }

  @override
  Widget body() {
    return FutureBuilder(
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
    );
  }

  Column ticUsedRecordLoaded(TicUsedModel model) {
    bool hasData = model.logs.isNotEmpty;

    List<DataRow> buildRows() {
      List<DataRow> rows = [];
      for (TicUsedLog log in model.logs) {
        rows.add(DataRow(cells: [
          DataCell(Text(log.time)),
          DataCell(Text('${log.mid}-${log.cid}號機')),
          const DataCell(Text('1張')),
        ]));
      }
      return rows;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Themes.borderColor, width: 1)),
          child: Row(
            children: [
              CircleAvatar(foregroundImage: R.image.logo_150_jpg(), radius: 29),
              const SizedBox(width: 16.8),
              const Text('近兩個月的遊玩券使用明細如下', style: TextStyle(fontSize: 18))
            ],
          ),
        ),
        const SizedBox(height: 12),
        hasData
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder.all(color: Themes.borderColor, width: 1),
                  dataRowMaxHeight: 60,
                  columns: ['日期', '機台', '消耗']
                      .map((e) => DataColumn(label: Text(e)))
                      .toList(),
                  rows: buildRows(),
                ),
              )
            : const Text('無資料'),
      ],
    );
  }
}
