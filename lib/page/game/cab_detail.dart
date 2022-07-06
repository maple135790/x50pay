part of "game.dart";

class _CabDetail extends StatefulWidget {
  final String machineId;
  const _CabDetail(this.machineId, {Key? key}) : super(key: key);

  @override
  State<_CabDetail> createState() => __CabDetailState();
}

class __CabDetailState extends BaseStatefulState<_CabDetail> with BaseLoaded {
  final viewModel = CabDatailViewModel();
  @override
  BaseViewModel? baseViewModel() => null;

  @override
  String? get subPageOf => 'game';

  @override
  Widget body() {
    return FutureBuilder(
      future: viewModel.getSelGame(widget.machineId),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const SizedBox();
        if (snapshot.data == true) {
          final cabDetail = viewModel.cabinetModel!;
          return cabDetailLoaded(cabDetail);
        } else {
          return const Text('failed');
        }
      },
    );
  }

  Widget cabDetailLoaded(CabinetModel model) {
    String tagLabel = model.cabinets.first.isBool == true
        ? model.cabinets.first.vipbool == true
            ? '月票'
            : '離峰'
        : '通常';
    double price = model.cabinets.first.mode[0][2];
    List<Cabinet> cabs = model.cabinets;
    List note = model.note;
    bool revbool = note.reversed.elementAt(1);
    var rrbool = note.reversed.elementAt(2);
    if (note[note.length - 1] == "twor") {
      note[note.length - 1] = "two";
      var nwcabinet = model.cabinets[0];
      var nwcabinet1 = model.cabinets[1];
      model.cabinets[1] = nwcabinet;
      model.cabinets[0] = nwcabinet1;
    }
    if (revbool == true) cabs = cabs.reversed.toList();
    if (rrbool is bool) {
      var nwcabinet = model.cabinets[4];
      var nwcabinet1 = model.cabinets[5];
      model.cabinets[4] = nwcabinet;
      model.cabinets[5] = nwcabinet1;
    }
    List<Widget> _buildCabBlock() {
      List<Widget> widgets = [];
      double gi = note.first;
      int cabGroupIndex = gi.toInt();
      int blockCount = 0;

      for (var e in note.getRange(0, note.length - 1)) {
        if (e is String) blockCount++;
      }
      for (int divIndex = 0; divIndex < blockCount; divIndex++) {
        String divText = note[1 + divIndex];
        List<Cabinet> cabGroup1 = cabs.sublist(0, cabGroupIndex + 1);
        List<Cabinet>? cabGroup2;
        if (cabGroupIndex != cabs.length) cabGroup2 = cabs.sublist(cabGroupIndex + 1);

        widgets
          ..add(const SizedBox(height: 15))
          ..add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xffe5e5e5), thickness: 1)),
                  Text(divText, style: const TextStyle(color: Color(0xff919191))),
                  const Expanded(child: Divider(color: Color(0xffe5e5e5), thickness: 1))
                ],
              )))
          ..add(const SizedBox(height: 15))
          ..add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 100,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildChildren(divIndex == 0 ? cabGroup1 : cabGroup2!)),
            ),
          ));
      }
      return widgets;
    }

    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(15, 20, 15, 8),
            padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
            decoration: BoxDecoration(
                color: const Color(0xfffbfbfb),
                border: Border.all(color: const Color(0xffededed), width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Icon(Icons.tablet_mac, color: Color(0xff5a5a5a), size: 16),
                Text('  X50Pad 排隊狀況：${viewModel.lineupCount} 人等待中',
                    style: const TextStyle(color: Color(0xff5a5a5a))),
                const Spacer(),
                TextButton(onPressed: () async {}, style: Themes.energy(), child: const Text('立刻排隊'))
              ],
            )),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Stack(
                children: [
                  Positioned.fill(
                      child: Image(image: _getBackground(widget.machineId), fit: BoxFit.fitWidth)),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 1]),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.cabinets.first.label,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                shadows: [Shadow(color: Colors.black, blurRadius: 18)])),
                        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          const Icon(Icons.sell, size: 16, color: Color(0xe6ffffff)),
                          Text('  $tagLabel',
                              style: const TextStyle(
                                  color: Color(0xffbcbfbf),
                                  fontSize: 16,
                                  shadows: [Shadow(color: Colors.black, blurRadius: 15)])),
                          const SizedBox(width: 5),
                          const Icon(Icons.attach_money, size: 16, color: Color(0xe6ffffff)),
                          Text('${price.toInt()}P',
                              style: const TextStyle(
                                  color: Color(0xffbcbfbf),
                                  fontSize: 16,
                                  shadows: [Shadow(color: Colors.black, blurRadius: 15)]))
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        model.spic != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: GestureDetector(
                    onTap: () {
                      launchUrlString(model.surl!);
                    },
                    child: Image(image: NetworkImage('https://pay.x50.fun${model.spic}', scale: 1))),
              )
            : const SizedBox(),
        ..._buildCabBlock()
      ],
    );
  }

  List<Widget> _buildChildren(List<Cabinet> cabs) {
    List<Widget> children = [];

    for (Cabinet cab in cabs) {
      String isPaid = cab.pcl == true ? '已投幣' : '未投幣';
      children.add(Expanded(
          child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => _CabSelect(viewModel,
                  label: cab.label, machineId: widget.machineId, machineIndex: cab.num, modes: cab.mode));
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cab.num.toString(), style: const TextStyle(color: Color(0xff404040), fontSize: 34)),
              const SizedBox(height: 8),
              Text(cab.notice, style: const TextStyle(color: Color(0xff808080), fontSize: 12)),
              Text('${cab.nbusy}/$isPaid', style: const TextStyle(color: Color(0xff5a5a5a), fontSize: 12)),
            ],
          ),
        ),
      )));
      if (cab != cabs.last) children.add(const SizedBox(width: 8));
    }
    return children;
  }
}

class _CabSelect extends StatefulWidget {
  final CabDatailViewModel viewModel;
  final String machineId;
  final String label;
  final int machineIndex;
  final List<List> modes;
  const _CabSelect(this.viewModel,
      {Key? key,
      required this.machineId,
      required this.label,
      required this.machineIndex,
      required this.modes})
      : super(key: key);

  @override
  State<_CabSelect> createState() => _CabSelectState();
}

class _CabSelectState extends State<_CabSelect> {
  bool isSelectPayment = false;
  String paymentType = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.hardEdge,
      contentPadding: isSelectPayment ? const EdgeInsets.only(top: 14) : const EdgeInsets.only(bottom: 20),
      content: isSelectPayment ? confirmPayment() : selectPayment(),
    );
  }

  Column confirmPayment() {
    paymentType = paymentType == 'point' ? '點數' : '遊玩券';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('注意！請確認是否有玩家正在遊玩。', style: TextStyle(fontSize: 18, color: Color(0xff404040))),
              const SizedBox(height: 14),
              Text('機種：${widget.label}', style: const TextStyle(fontSize: 18, color: Color(0xff404040))),
              Text('編號：${widget.machineIndex}號機',
                  style: const TextStyle(fontSize: 18, color: Color(0xff404040))),
              Text('消費：$paymentType', style: const TextStyle(fontSize: 18, color: Color(0xff404040))),
              const SizedBox(height: 12.6),
              const Text('請勿影響他人權益。如投幣扣點後機台無動作請聯絡粉專！請勿再次點擊',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xff5a5a5a))),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const Divider(color: Color(0xffd9d9d9), thickness: 1, height: 0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: Themes.grey(),
                  child: const Text('取消')),
              const SizedBox(width: 8),
              TextButton(
                  onPressed: () async {
                    final nav = Navigator.of(context);
                    final isInsertSuccess = await widget.viewModel.doInsert(
                        machineId: widget.machineId,
                        isTicket: paymentType == 'ticket',
                        mode: widget.modes[0].first);
                    if (isInsertSuccess) {
                      final code = widget.viewModel.response!.code;
                      String msg = '';
                      String describe = '';
                      bool is200 = false;
                      switch (code) {
                        case 200:
                          is200 = true;
                          msg = '投幣成功，感謝您的惠顧！';
                          describe = '請等候約三秒鐘，若機台仍無反應請盡速與X50粉絲專頁聯絡';
                          break;
                        case 601:
                          msg = '機台鎖定中';
                          describe = '目前機台正在遊玩中   請稍候再投幣';
                          break;
                        case 602:
                          msg = '投幣失敗';
                          describe = '請確認您的網路環境，再次重試，如多次無法請回報粉專';
                          break;
                        case 603:
                          msg = '餘額不足';
                          describe = '您的餘額不足，無法遊玩   請加值';
                          break;
                        case 604:
                          msg = '請重新登入';
                          describe = '請等候約三秒鐘，若機台仍無反應請盡速與X50粉絲專頁聯絡';
                          break;
                        case 609:
                          msg = '請驗證電話';
                          describe = '您的帳號並沒有電話驗證   請先驗證電話方可用遊玩券';
                          break;
                        case 698:
                          msg = '遊玩券使用失敗';
                          describe = '此機不開放使用遊玩券';
                          break;
                        case 699:
                          msg = '遊玩券使用失敗';
                          describe = '請等候約三秒鐘，若機台仍無反應請盡速與X50粉絲專頁聯絡';
                          break;
                        case 6099:
                          msg = '請先填寫實聯驗證';
                          describe = '尚未實聯';
                          break;
                      }
                      is200
                          ? await EasyLoading.showSuccess('$msg\n$describe')
                          : await EasyLoading.showError('$msg\n$describe');
                    } else {
                      await EasyLoading.showError('投幣失敗\n請確認您的網路環境，再次重試，如多次無法請回報粉專');
                    }
                    await Future.delayed(const Duration(seconds: 2));
                    await GlobalSingleton.instance.checkUser(force: true);
                    nav.popUntil(ModalRoute.withName(AppRoute.game));
                  },
                  style: Themes.confirm(),
                  child: const Text('確認'))
            ],
          ),
        )
      ],
    );
  }

  SizedBox selectPayment() {
    return SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                Positioned.fill(child: Image(image: _getBackground(widget.machineId), fit: BoxFit.fitWidth)),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.1, 1]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              shadows: [Shadow(color: Colors.black, blurRadius: 18)])),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Text('${widget.machineIndex}號機',
                            style: const TextStyle(
                                color: Color(0xffbcbfbf),
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 15)])),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          _buildPlayMenu()
        ],
      ),
    );
  }

  Widget _buildPlayMenu() {
    List<Widget> children = [];

    for (List mode in widget.modes) {
      final double price = mode.last;
      children
        ..add(const SizedBox(height: 20))
        ..add(Text(mode[1], style: const TextStyle(color: Color(0xff5a5a5a))))
        ..add(ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  isSelectPayment = true;
                  paymentType = 'point';
                  setState(() {});
                },
                style: Themes.severe(),
                child: Text('${price.toInt()}P')),
            TextButton(
                onPressed: () {
                  isSelectPayment = true;
                  paymentType = 'ticket';
                  setState(() {});
                },
                style: Themes.confirm(),
                child: const Text('遊玩券')),
          ],
        ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
