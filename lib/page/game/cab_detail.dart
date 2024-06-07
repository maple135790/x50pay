import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/mixins/game_mixin.dart';
import 'package:x50pay/page/game/cab_detail_view_model.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/repository/repository.dart';

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
  const CabDetail(this.machineId, {super.key});

  @override
  State<CabDetail> createState() => _CabDetailState();
}

class _CabDetailState extends BaseStatefulState<CabDetail> {
  final repo = Repository();
  late final viewModel = CabDatailViewModel(
    repository: repo,
    machineId: widget.machineId,
  );
  late Future<bool> cabInit;
  var key = GlobalKey();

  @override
  void initState() {
    super.initState();
    cabInit = viewModel.getSelGameCab();
  }

  Future<void> onRefresh() async {
    key = GlobalKey();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: Container(
          key: key,
          color: scaffoldBackgroundColor,
          child: ChangeNotifierProvider.value(
            value: viewModel,
            builder: (context, child) {
              return FutureBuilder(
                future: cabInit,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox();
                  }

                  if (snapshot.data != true) {
                    return const Text('failed');
                  }

                  final cabDetail = viewModel.cabinetModel!;
                  return CabDetailLoaded(cabDetail);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RSVPDialog extends StatefulWidget {
  final List<List<String>?> rsvp;

  const _RSVPDialog(this.rsvp);

  @override
  State<_RSVPDialog> createState() => _RSVPDialogState();
}

class _RSVPDialogState extends BaseStatefulState<_RSVPDialog> {
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
                  Text(' ${i18n.gameUnlimitTitle} '),
                  const SizedBox(height: 5),
                  ...buildRSVPs(),
                ],
              ),
            ),
            Divider(thickness: 1, height: 0, color: borderColor),
            Container(
              color: dialogButtomBarColor,
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style:
                            CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                        child: const Text('關閉')),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextButton(
                      onPressed: doRSVP,
                      style: CustomButtonThemes.severe(isV4: true),
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

class CabDetailLoaded extends StatefulWidget {
  final CabinetModel model;

  const CabDetailLoaded(this.model, {super.key});

  @override
  State<CabDetailLoaded> createState() => _CabDetailLoadedState();
}

class _CabDetailLoadedState extends BaseStatefulState<CabDetailLoaded>
    with GameMixin {
  void onCabSelect({
    required String caboid,
    required Cabinet cabData,
  }) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CabSelect.fromCabDetail(
        caboid: caboid,
        cabNum: cabData.num - 1,
        cabinetData: cabData,
      ),
    );
  }

  void onEventBannerPressed(String url) {
    if (url.startsWith('http')) {
      launchUrlString(
        url.replaceAll('\'', ''),
        mode: LaunchMode.externalNonBrowserApplication,
      );
      return;
    }
    context.pushNamed(
      AppRoutes.questCampaign.routeName,
      pathParameters: {'couid': url.replaceAll('\'', '')},
    );
  }

  void onLineupPressed(String padmid, String padlid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        clipBehavior: Clip.hardEdge,
        contentPadding: const EdgeInsets.only(top: 15),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_rounded, size: 50),
            const Text('注意 請確認是否在平板前', style: TextStyle(fontSize: 17)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: const Text.rich(
                TextSpan(
                  text: '請確認本人',
                  children: [
                    TextSpan(
                      text: '在平板前',
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(text: ' 平板會跳出排隊確認請於 180 秒內確認，如接受再點 '),
                    TextSpan(
                      text: '『排隊』',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1, height: 0),
            Container(
              color: dialogButtomBarColor,
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          context
                              .read<CabDatailViewModel>()
                              .confirmPadCheck(padmid, padlid);
                          Navigator.of(context).pop();
                        },
                        style: CustomButtonThemes.severe(isV4: true),
                        child: const Text('排隊')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCabInfo({
    required double price,
    required String tagName,
    required String cabLabel,
  }) {
    final machineId = context.read<CabDatailViewModel>().machineId;
    return Container(
      height: 150,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: borderColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CachedNetworkImage(
                imageUrl: getGameCabImage(machineId),
                alignment: const Alignment(0, -0.25),
                fit: BoxFit.fitWidth,
                errorWidget: (context, url, error) {
                  log('',
                      name: 'err cabDetailLoaded',
                      error: 'error loading gamecab image: $error');
                  return const SizedBox();
                },
              ),
            ),
          ),
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
                Text(
                  cabLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    shadows: [
                      Shadow(color: Colors.black, blurRadius: 18),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      size: 13.5,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    Text(
                      '  $tagName',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        shadows: const [
                          Shadow(color: Colors.black, blurRadius: 15)
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.attach_money_rounded,
                      size: 18,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    Text(
                      '${price.toInt()}P',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13.5,
                        shadows: const [
                          Shadow(color: Colors.black, blurRadius: 15)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildEventPic(List<String>? spic, List<String>? surl) {
    if (spic == null || surl == null) return [const SizedBox()];
    if (spic.length != surl.length) {
      log('',
          name: 'err buildStreamPic', error: 'spic and surl length not equal');
      return [const SizedBox()];
    }
    final list = <Widget>[];

    for (var i = 0; i < surl.length; i++) {
      final url = surl[i];
      final pic = spic[i];
      list.add(
        Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: 'https://pay.x50.fun$pic}',
                fit: BoxFit.fill,
                height: 55,
                width: MediaQuery.sizeOf(context).width,
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      onEventBannerPressed(url);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return list;
  }

  List<Widget> _buildCabs(
    List<Cabinet> cabs, {
    required String caboid,
    required int group1Length,
    required bool isGroup1,
  }) {
    final machineId = context.read<CabDatailViewModel>().machineId;
    List<Widget> children = [];
    for (int i = 0; i < cabs.length; i++) {
      final cab = cabs[i];
      final rawNbusy = cab.nbusy;
      final nbusy = rawNbusy.contains('s1')
          ? i18n.nbusyS1
          : rawNbusy.contains('s2')
              ? i18n.nbusyS2
              : i18n.nbusyS3;
      final isPaid = cab.pcl == true ? i18n.nbusyCoin : i18n.nbusyNoCoin;

      children.add(
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraint) {
              final top = constraint.biggest.height * 0.25;
              final right = constraint.biggest.width * 0.05 * -1;

              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: borderColor,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: right,
                      top: top,
                      child: CachedNetworkImage(
                        imageUrl: getMachineIcon(machineId),
                        errorWidget: (context, url, error) => const SizedBox(),
                        height: 95,
                        color: iconColor.withOpacity(0.15).invert(0.28),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            cab.num.toString(),
                            style: const TextStyle(fontSize: 34),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            cab.notice,
                            style: const TextStyle(
                              color: Color(0xff808080),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$nbusy/$isPaid',
                            textAlign: TextAlign.center,
                            textScaler: const TextScaler.linear(0.85),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    Positioned.fill(
                        child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onCabSelect(
                            caboid: caboid,
                            cabData: cab,
                          );
                        },
                      ),
                    )),
                  ],
                ),
              );
            },
          ),
        ),
      );
      if (cab != cabs.last) children.add(const SizedBox(width: 8));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    List<Cabinet> cabs = widget.model.cabinets;

    final isWeekend =
        DateTime.now().weekday == 6 || DateTime.now().weekday == 7;
    final tagLabel = widget.model.cabinets.first.isBool == true
        ? widget.model.cabinets.first.vipbool == true
            ? i18n.gameMPass
            : i18n.gameDiscountHour
        : i18n.gameNormalHour;
    final addition = widget.model.cabinets.first.vipbool == true
        ? " [${i18n.gameMPass}]"
        : tagLabel == i18n.gameNormalHour
            ? ''
            : isWeekend
                ? " [${i18n.gameWeekends}]"
                : " [${i18n.gameWeekday}]";
    final price =
        double.parse(widget.model.cabinets.first.mode[0][2].toString());
    final note = widget.model.note;
    final revbool = note.reversed.elementAt(1) as bool;
    var rrbool = note.reversed.elementAt(2);
    if (note[note.length - 1] == "twor") {
      note[note.length - 1] = "two";
      var nwcabinet = widget.model.cabinets[0];
      var nwcabinet1 = widget.model.cabinets[1];
      widget.model.cabinets[1] = nwcabinet;
      widget.model.cabinets[0] = nwcabinet1;
    }
    if (revbool == true) cabs = List.from(cabs.reversed.toList());
    if (rrbool is bool) {
      var nwcabinet = widget.model.cabinets[4];
      var nwcabinet1 = widget.model.cabinets[5];
      widget.model.cabinets[5] = nwcabinet;
      widget.model.cabinets[4] = nwcabinet1;
    }

    List<Widget> buildCabBlock({required String caboid}) {
      final widgets = <Widget>[];
      final gi = double.parse(note.first.toString());
      final cabGroupIndex = gi.toInt();
      int blockCount = 0;

      for (var e in note.getRange(0, note.length - 1)) {
        if (e is String) blockCount++;
      }
      for (int divIndex = 0; divIndex < blockCount; divIndex++) {
        final divText = note[1 + divIndex];
        List<Cabinet> cabGroup1 = cabs.sublist(
          0,
          cabGroupIndex + 1 > cabs.length ? cabGroupIndex : cabGroupIndex + 1,
        );
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
                  Text(divText),
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
                  children: _buildCabs(
                    divIndex == 0 ? cabGroup1 : cabGroup2!,
                    group1Length: cabGroup1.length,
                    isGroup1: divIndex == 0,
                    caboid: caboid,
                  )),
            ),
          ));
      }
      return widgets;
    }

    Widget buildPadLineUp() {
      final lineUpCount = context.read<CabDatailViewModel>().lineupCount;
      if (lineUpCount == -1) return const SizedBox();
      return Container(
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
        padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
        decoration: BoxDecoration(
            color: scaffoldBackgroundColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Text('  ${i18n.gameWait(lineUpCount)}'),
            const Spacer(),
            GestureDetector(
              onTap: () {
                onLineupPressed(widget.model.padmid, widget.model.padlid);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfffafafa),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Icon(
                  Icons.tablet_mac_rounded,
                  color: Color(0xff1e1e1e),
                ),
              ),
            )
          ],
        ),
      );
    }

    void showRSVPPopup() {
      showDialog(
        context: context,
        builder: (context) => _RSVPDialog(widget.model.reservations),
      );
    }

    Widget buildRSVP(List<List<String>?> reservations) {
      if (reservations.isEmpty) return const SizedBox();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xffa8071a),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 15,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                '!',
                style: TextStyle(color: Color(0xffcf1322)),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              i18n.gameUnlimit,
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            GestureDetector(
              onTap: showRSVPPopup,
              child: Container(
                padding: const EdgeInsets.all(4.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Color(0xffa8071a),
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        const SizedBox(height: 15),
        buildRSVP(widget.model.reservations),
        const SizedBox(height: 10),
        buildPadLineUp(),
        const SizedBox(height: 8),
        buildCabInfo(
          price: price,
          tagName: "$tagLabel$addition",
          cabLabel: widget.model.cabinets.first.label,
        ),
        ...buildEventPic(widget.model.spic, widget.model.surl),
        ...buildCabBlock(caboid: widget.model.caboid),
        const SizedBox(height: 12),
      ],
    );
  }
}
