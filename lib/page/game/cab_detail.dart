part of "game.dart";

extension on Color {
  Color invert(double value) {
    assert(value >= 0 && value <= 1, 'value must be between 0 and 1');
    final intensity = value * 255;
    final r = (intensity - red).abs();
    final g = (intensity - green).abs();
    final b = (intensity - blue).abs();
    return Color.fromARGB(alpha, r.toInt(), g.toInt(), b.toInt());
  }
}

class CabDetail extends StatefulWidget {
  final String machineId;
  const CabDetail(this.machineId, {Key? key}) : super(key: key);

  @override
  State<CabDetail> createState() => _CabDetailState();
}

class _CabDetailState extends BaseStatefulState<CabDetail> {
  final viewModel = CabDatailViewModel();

  void onCabSelect({
    required String caboid,
    required String label,
    required int index,
    required List<List<dynamic>> mode,
  }) {
    showDialog(
        context: context,
        builder: (context) => _CabSelect(
              viewModel,
              caboid: caboid,
              label: label,
              id: widget.machineId,
              machineIndex: index,
              modes: mode,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder(
        future: viewModel.getSelGameCab(widget.machineId),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }
          if (snapshot.data == true) {
            final cabDetail = viewModel.cabinetModel!;
            return cabDetailLoaded(cabDetail);
          } else {
            return const Text('failed');
          }
        },
      ),
    );
  }

  Widget cabDetailLoaded(CabinetModel model) {
    List<Cabinet> cabs = model.cabinets;
    final tagLabel = model.cabinets.first.isBool == true
        ? model.cabinets.first.vipbool == true
            ? '月票'
            : '離峰'
        : '通常';
    final price = double.parse(model.cabinets.first.mode[0][2].toString());
    final note = model.note;
    final revbool = note.reversed.elementAt(1) as bool;
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
    List<Widget> buildCabBlock({required String caboid}) {
      List<Widget> widgets = [];
      double gi = double.parse(note.first.toString());
      int cabGroupIndex = gi.toInt();
      int blockCount = 0;

      for (var e in note.getRange(0, note.length - 1)) {
        if (e is String) blockCount++;
      }
      for (int divIndex = 0; divIndex < blockCount; divIndex++) {
        String divText = note[1 + divIndex];
        List<Cabinet> cabGroup1 = cabs.sublist(
            0,
            cabGroupIndex + 1 > cabs.length
                ? cabGroupIndex
                : cabGroupIndex + 1);
        List<Cabinet>? cabGroup2;
        if (cabGroupIndex != cabs.length) {
          cabGroup2 = cabs.sublist(cabGroupIndex + 1);
        }

        widgets
          ..add(const SizedBox(height: 15))
          ..add(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  const Expanded(child: Divider(thickness: 1, endIndent: 15)),
                  Text(divText,
                      style: const TextStyle(color: Color(0xfffafafa))),
                  const Expanded(child: Divider(thickness: 1, indent: 15))
                ],
              )))
          ..add(const SizedBox(height: 15))
          ..add(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 110,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildCabs(divIndex == 0 ? cabGroup1 : cabGroup2!,
                      caboid: caboid)),
            ),
          ));
      }
      return widgets;
    }

    Widget buildPadLineUp() {
      if (viewModel.lineupCount == -1) return const SizedBox();
      return Container(
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
          padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Themes.borderColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Row(
            children: [
              Text('  X50Pad 排隊狀況：${viewModel.lineupCount} 人等待中',
                  style: const TextStyle(color: Color(0xfffafafa))),
              const Spacer(),
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xfffafafa),
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child:
                        const Icon(Icons.tablet_mac, color: Color(0xff1e1e1e)),
                  ))
            ],
          ));
    }

    void showRSVPPopup() {
      showDialog(
          context: context,
          builder: (context) => _RSVPDialog(model.reservations));
    }

    Widget buildRSVP(List<List<String>?> reservations) {
      if (reservations.isEmpty) return const SizedBox();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color(0xffa8071a),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Container(
                width: 15,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: const Text('!',
                    style: TextStyle(color: Color(0xffcf1322)))),
            const SizedBox(width: 15),
            const Text('該機種當周有無限制台預約'),
            const Spacer(),
            GestureDetector(
              onTap: showRSVPPopup,
              child: Container(
                padding: const EdgeInsets.all(4.5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: const Icon(Icons.calendar_month,
                    color: Color(0xffa8071a), size: 16),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          buildRSVP(model.reservations),
          const SizedBox(height: 10),
          buildPadLineUp(),
          const SizedBox(height: 8),
          buildCabInfo(
              price: price,
              tagName: tagLabel,
              cabLabel: model.cabinets.first.label),
          ...buildStreamPic(model.spic, model.surl),
          ...buildCabBlock(caboid: model.caboid),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget buildCabInfo(
      {required double price,
      required String tagName,
      required String cabLabel}) {
    return Container(
      height: 150,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: const Color(0xff505050),
            strokeAlign: BorderSide.strokeAlignOutside),
      ),
      child: Stack(
        children: [
          Positioned.fill(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image(
              image: _getGameCabImage(widget.machineId),
              alignment: const Alignment(0, -0.25),
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) {
                log('',
                    name: 'err cabDetailLoaded',
                    error: 'error loading gamecab image: $error');
                return Image(
                  image: _getGameCabImageFallback(widget.machineId),
                );
              },
            ),
          )),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  colors: [Colors.black, Colors.transparent],
                  transform: GradientRotation(12),
                  stops: [0, 0.6],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 6,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cabLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 18)
                        ])),
                Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Icon(Icons.sell, size: 18, color: Color(0xe6ffffff)),
                  Text('  $tagName',
                      style: const TextStyle(
                          height: 0,
                          color: Color(0xffbcbfbf),
                          fontSize: 16,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 15)
                          ])),
                  const SizedBox(width: 5),
                  const Icon(Icons.attach_money,
                      size: 18, color: Color(0xe6ffffff)),
                  Text('${price.toInt()}P',
                      style: const TextStyle(
                          height: 0,
                          color: Color(0xffbcbfbf),
                          fontSize: 16,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 15)
                          ]))
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildStreamPic(List<String>? spic, List<String>? surl) {
    if (spic == null || surl == null) return [const SizedBox()];
    if (spic.length != surl.length) {
      log('',
          name: 'err buildStreamPic', error: 'spic and surl length not equal');
      return [const SizedBox()];
    }
    var list = <Widget>[];
    for (var i = 0; i < surl.length; i++) {
      list.add(GestureDetector(
          onTap: () {
            launchUrlString(surl[i].replaceAll('\'', ''),
                mode: LaunchMode.externalNonBrowserApplication);
          },
          child: Container(
            width: double.maxFinite,
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xff505050),
                    strokeAlign: BorderSide.strokeAlignOutside),
                borderRadius: BorderRadius.circular(6)),
            child: CachedNetworkImage(
              imageUrl: 'https://pay.x50.fun${spic[i]}',
              height: 55,
              fit: BoxFit.fill,
            ),
          )));
    }

    return list;
  }

  List<Widget> _buildCabs(List<Cabinet> cabs, {required String caboid}) {
    List<Widget> children = [];

    for (Cabinet cab in cabs) {
      String isPaid = cab.pcl == true ? '已投幣' : '未投幣';
      children.add(Expanded(
          child: GestureDetector(
        onTap: () {
          onCabSelect(
            caboid: caboid,
            label: cab.label,
            index: cab.num,
            mode: cab.mode,
          );
        },
        child: LayoutBuilder(
          builder: (context, constraint) {
            final top = constraint.biggest.height * 0.25;
            final right = constraint.biggest.width * 0.05 * -1;

            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Themes.borderColor,
                      strokeAlign: BorderSide.strokeAlignOutside)),
              child: Stack(
                children: [
                  Positioned(
                      right: right,
                      top: top,
                      child: CachedNetworkImage(
                        imageUrl: getMachineIcon(widget.machineId),
                        errorWidget: (context, url, error) => const SizedBox(),
                        height: 95,
                        color: Colors.white.withOpacity(0.15).invert(0.28),
                      )),
                  Positioned.fill(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(cab.num.toString(),
                            style: const TextStyle(fontSize: 34)),
                        const SizedBox(height: 5),
                        Text(cab.notice,
                            style: const TextStyle(
                                color: Color(0xff808080), fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${cab.nbusy}/$isPaid',
                            style: const TextStyle(
                                color: Color(0xfffafafa), fontSize: 12)),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )));
      if (cab != cabs.last) children.add(const SizedBox(width: 8));
    }
    return children;
  }
}

class _CabSelect extends StatefulWidget {
  final CabDatailViewModel viewModel;
  final String id;
  final String label;
  final int machineIndex;
  final String caboid;
  final List<List> modes;
  const _CabSelect(this.viewModel,
      {Key? key,
      required this.id,
      required this.label,
      required this.machineIndex,
      required this.modes,
      required this.caboid})
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
      contentPadding: isSelectPayment
          ? const EdgeInsets.only(top: 14)
          : const EdgeInsets.only(bottom: 20),
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
              const Text('注意！請確認是否有玩家正在遊玩。', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 14),
              Text('機種：${widget.label}', style: const TextStyle(fontSize: 18)),
              Text('編號：${widget.machineIndex}號機',
                  style: const TextStyle(fontSize: 18)),
              Text('消費：$paymentType', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12.6),
              const Text('請勿影響他人權益。如投幣扣點後機台無動作請聯絡粉專！請勿再次點擊',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
              const SizedBox(height: 16),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 0),
        Container(
          color: const Color(0xff2a2a2a),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: Themes.pale(),
                      child: const Text('取消')),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextButton(
                      onPressed: () async {
                        final router = GoRouter.of(context);
                        final isInsertSuccess = await widget.viewModel.doInsert(
                            id: widget.caboid,
                            machineNum: widget.machineIndex - 1,
                            isTicket: paymentType == 'ticket',
                            mode: widget.modes[0].first);
                        router.pop();
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
                              msg = '未知錯誤';
                              describe = '反正就是錯誤';
                              break;
                            case 609:
                              msg = '請驗證電話';
                              describe = '您的帳號並沒有電話驗證   請先驗證電話方可用遊玩券';
                              break;
                            case 698:
                              msg = '遊玩券使用失敗';
                              describe = '您的遊玩券此機種不適用 請進入會員中心 -> 獲券紀錄 檢閱';
                              break;
                            case 699:
                              msg = '遊玩券使用失敗';
                              describe = '此機不開放使用遊玩券';
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
                          await EasyLoading.showError(
                              '投幣失敗\n請確認您的網路環境，再次重試，如多次無法請回報粉專');
                        }
                        await Future.delayed(const Duration(seconds: 2));
                        await GlobalSingleton.instance.checkUser(force: true);
                        router.pop(true);
                      },
                      style: Themes.severe(isV4: true),
                      child: const Text('確認')),
                )
              ],
            ),
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
                Positioned.fill(
                    child: Image(
                        image: _getGameCabImage(widget.id),
                        alignment: const Alignment(0, -0.25),
                        fit: BoxFit.fitWidth)),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [Colors.black, Colors.transparent],
                        transform: GradientRotation(12),
                        stops: [0, 0.6],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xffdcdcdc),
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Color(0xff2a2a2a),
                          ),
                        ))),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.label,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 18)
                                ])),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${widget.machineIndex}號機',
                                  style: const TextStyle(
                                      color: Color(0xffbcbfbf),
                                      fontSize: 16,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black, blurRadius: 15)
                                      ])),
                            ]),
                      ],
                    ),
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
      final double price = double.parse(mode.last.toString());
      children
        ..add(const SizedBox(height: 20))
        ..add(Text(mode[1], style: const TextStyle(color: Color(0xfffafafa))))
        ..add(ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  isSelectPayment = true;
                  paymentType = 'point';
                  setState(() {});
                },
                style: Themes.severe(isV4: true),
                child: Text('${price.toInt()}P')),
            TextButton(
                onPressed: () {
                  isSelectPayment = true;
                  paymentType = 'ticket';
                  setState(() {});
                },
                style: Themes.pale(),
                child: const Text('遊玩券')),
          ],
        ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}

class _RSVPDialog extends StatefulWidget {
  final List<List<String>?> rsvp;

  const _RSVPDialog(this.rsvp);

  @override
  State<_RSVPDialog> createState() => _RSVPDialogState();
}

class _RSVPDialogState extends State<_RSVPDialog> {
  String get title => widget.rsvp[0]![1];

  List<Widget> buildRSVPs() {
    var widgets = <Widget>[];
    for (var r in widget.rsvp) {
      widgets.add(Text(r?[0] ?? ''));
    }
    return widgets;
  }

  void doRSVP() {
    launchUrlString('https://m.me/X50MGS',
        mode: LaunchMode.externalNonBrowserApplication);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      contentPadding: EdgeInsets.zero,
      content: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 22.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: const TextStyle(fontSize: 17)),
                  const SizedBox(height: 5),
                  const Text(' 已預約時段: '),
                  const SizedBox(height: 5),
                  ...buildRSVPs(),
                ],
              ),
            ),
            const Divider(thickness: 1, height: 0, color: Color(0xff3e3e3e)),
            Container(
              color: const Color(0xff2a2a2a),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: Themes.cancel(),
                        child: const Text('關閉')),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextButton(
                      onPressed: doRSVP,
                      style: Themes.severe(isV4: true),
                      child: const Text('馬上預約'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
