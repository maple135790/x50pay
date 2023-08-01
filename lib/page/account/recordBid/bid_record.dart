part of "../account.dart";

class _BidRecord extends StatefulWidget {
  final AccountViewModel viewModel;

  const _BidRecord(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<_BidRecord> createState() => __BidRecordState();
}

class __BidRecordState extends BaseStatefulState<_BidRecord> {
  late AccountViewModel model;

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: model.getBidLog(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }
        if (snapshot.data == false) {
          scaffoldKey.currentState!.showSnackBar(
              const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
          return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
        }
        if (model.bidModel!.code != 200) {
          scaffoldKey.currentState!.showSnackBar(
              const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
          return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
        }
        return bidRecordLoaded(model.bidModel!);
      },
    );
  }

  Column bidRecordLoaded(BidLogModel model) {
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
              const Text('近兩個月的儲值紀錄如下', style: TextStyle(fontSize: 18))
            ],
          ),
        ),
        const SizedBox(height: 12),
        hasData
            ? DataTable(
                border: TableBorder.all(color: Themes.borderColor, width: 1),
                columns: ['時間', '儲值金額']
                    .map((e) => DataColumn(label: Text(e)))
                    .toList(),
                rows: buildRows(),
              )
            : const Text('無資料'),
      ],
    );
  }
}
