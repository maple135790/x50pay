part of "../account.dart";

class TicketRecords extends StatefulWidget {
  final AccountViewModel viewModel;

  const TicketRecords(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<TicketRecords> createState() => _TicketRecordsState();
}

class _TicketRecordsState extends BaseStatefulState<TicketRecords> {
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
        future: model.getTicketLog(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }
          if (snapshot.data == false) {
            scaffoldKey.currentState!.showSnackBar(
                const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
            return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
          }
          if (model.ticDateLogModel!.code != 200) {
            scaffoldKey.currentState!.showSnackBar(
                const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
            return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
          }
          return ticketRecordLoaded(model.ticDateLogModel!);
        },
      ),
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
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DataTable(
                      border: TableBorder.all(color: Themes.borderColor),
                      dataRowMaxHeight: 60,
                      columns: ['活動名稱', '過期日', '剩餘張數', '詳情']
                          .map((e) => DataColumn(label: Text(e)))
                          .toList(),
                      rows: buildRows(),
                    ),
                  ),
                )
              : const Text('無資料'),
        ],
      ),
    );
  }
}
