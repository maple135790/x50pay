part of "../account.dart";

class _PlayRecord extends StatefulWidget {
  final AccountViewModel viewModel;

  const _PlayRecord(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<_PlayRecord> createState() => __PlayRecordState();
}

class __PlayRecordState extends BaseStatefulState<_PlayRecord> with BaseLoaded {
  late AccountViewModel model;

  @override
  bool get disableBottomNavigationBar => true;

  @override
  BaseViewModel? baseViewModel() => widget.viewModel;

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
  }

  @override
  Widget body() {
    return FutureBuilder(
      future: model.getPlayRecord(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox();
        }
        if (snapshot.data == false) {
          scaffoldKey.currentState!.showSnackBar(const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
          return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
        }
        if (model.playRecordModel!.code != 200) {
          scaffoldKey.currentState!.showSnackBar(const SnackBar(content: Text('伺服器錯誤，請嘗試重新整理或回報X50')));
          return const Center(child: Text('伺服器錯誤，請嘗試重新整理或回報X50'));
        }
        return playRecordLoaded(model.playRecordModel!);
      },
    );
  }

  Column playRecordLoaded(PlayRecordModel model) {
    bool hasData = model.logs.isNotEmpty;

    List<DataRow> _buildRows() {
      List<DataRow> rows = [];
      for (PlayLog log in model.logs) {
        rows.add(DataRow(cells: [
          DataCell(Text(log.time, style: const TextStyle(color: Color(0xff5a5a5a)))),
          DataCell(Text('${log.mid}-${log.cid}號機', style: const TextStyle(color: Color(0xff5a5a5a)))),
          DataCell(Text('${log.price.toInt()}P', style: const TextStyle(color: Color(0xff5a5a5a)))),
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
              color: Colors.white, border: Border.all(color: const Color(0xffe9e9e9), width: 1)),
          child: Row(
            children: [
              CircleAvatar(foregroundImage: R.image.logo_150_jpg(), radius: 20),
              const SizedBox(width: 16.8),
              const Text('近兩個月的扣點明細如下', style: TextStyle(color: Color(0xff404040), fontSize: 18))
            ],
          ),
        ),
        const SizedBox(height: 12),
        hasData
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(const Color(0xfff7f7f7)),
                  border: TableBorder.all(color: const Color(0xffe9e9e9), width: 1),
                  dataRowHeight: 60,
                  decoration: BoxDecoration(
                      color: Colors.white, border: Border.all(color: const Color(0xffe9e9e9), width: 1)),
                  columns: ['日期', '機台', '使用點數']
                      .map(
                          (e) => DataColumn(label: Text(e, style: const TextStyle(color: Color(0xff5a5a5a)))))
                      .toList(),
                  rows: _buildRows(),
                ),
              )
            : const Text('無資料'),
      ],
    );
  }
}
