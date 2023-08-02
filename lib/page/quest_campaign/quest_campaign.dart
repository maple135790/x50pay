import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/models/quest_campaign/campaign.dart';
import 'package:x50pay/common/models/quest_campaign/redeem_item.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/quest_campaign/quest_campaign_view_model.dart';

class QuestCampaign extends StatefulWidget {
  final String campaignId;
  const QuestCampaign({super.key, required this.campaignId});

  @override
  State<QuestCampaign> createState() => _QuestCampaignState();
}

class _QuestCampaignState extends State<QuestCampaign> {
  final viewModel = QuestCampaignViewModel();
  late Future<Campaign?> init;

  Future<void> onAddStampRowTap() async {
    viewModel.onAddStampRowTap(campaignId: widget.campaignId);
    context.goNamed(
      AppRoutes.questCampaign.routeName,
      pathParameters: {'couid': widget.campaignId},
      extra: true,
    );
  }

  @override
  void initState() {
    super.initState();
    init = viewModel.init(campaignId: widget.campaignId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error'));
          }
          final model = snapshot.data as Campaign;
          return SingleChildScrollView(child: campaignLoaded(model));
        });
  }

  Widget divider() => const Divider(color: Color(0xff3e3e3e), height: 16);

  void showRedeemItemDialog({
    required String? imgUrl,
    required String? name,
    required List<String>? extras,
    required List<String>? redeemRecords,
  }) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) {
        return _RedeemItemDetail(
          imgUrl: imgUrl,
          name: name,
          extras: extras,
          redeemRecords: redeemRecords,
        );
      },
    ));
  }

  Widget buildStampRow(int stampRowCounts) {
    return Column(
      children: [
        SizedBox(
            height: ((35 + 16) * stampRowCounts).toDouble(),
            child: Column(
              children: List.filled(
                stampRowCounts,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.circle_rounded,
                          size: 35,
                          color: const Color(0xfffafafa).withOpacity(0.2),
                        ),
                        ...List.filled(
                            5,
                            Container(
                              margin: const EdgeInsets.only(left: 7.5),
                              padding: const EdgeInsets.only(left: 15),
                              decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Color(0xff5a5a5a))),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.circle_rounded,
                                  size: 35,
                                  color:
                                      const Color(0xfffafafa).withOpacity(0.2),
                                ),
                              ),
                            ))
                      ],
                    ),
                    divider(),
                  ],
                ),
              ),
            )),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onAddStampRowTap,
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xfffafafa)),
                ),
                child: const Text(
                  '增加一行欄位',
                  style: TextStyle(
                      color: Color(0xff1e1e1e),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  List<Widget> buildRedeemItems(List<RedeemItem> items) {
    List<Widget> widgets = [];
    for (var item in items) {
      widgets.add(
        Container(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff3e3e3e)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox.square(
                  dimension: 80,
                  child: CachedNetworkImage(imageUrl: item.imgUrl),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                  child: Text(
                '${item.name}\n所需點數 ${item.points} 點',
                style: const TextStyle(color: Color(0xfffafafa), height: 2),
              )),
              const SizedBox(width: 15),
              SizedBox(
                width: 75,
                child: Center(
                  child: TextButton(
                    style: Themes.severe(isV4: true),
                    onPressed: () {
                      showRedeemItemDialog(
                        imgUrl: item.imgUrl,
                        name: item.name,
                        extras: item.extra,
                        redeemRecords: item.recentRedeemTime,
                      );
                    },
                    child: const Text('查看'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  Widget campaignLoaded(Campaign data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 150,
            width: 367,
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff3e3e3e)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: data.campaignImageUrl,
                    fit: BoxFit.fitWidth,
                    alignment: const Alignment(0, -0.25),
                  ),
                ),
                Positioned.fill(
                  top: 34.0156,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black54, Colors.transparent],
                        transform: GradientRotation(0.20944),
                        stops: [0, 0.6],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(data.campaignTitle ?? '',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule_rounded, size: 14),
                            const SizedBox(width: 8),
                            Text(data.campaignGoodThruDate ?? '',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(width: 10.281),
                            const Icon(Icons.workspace_premium_rounded,
                                size: 14),
                            const SizedBox(width: 8),
                            Text(data.minQuestPoints ?? '',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff3e3e3e)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: buildStampRow(data.stampRowCounts ?? 1),
          ),
          divider(),
          Center(
            child: Text(
              data.pointInfo ?? '',
              style: const TextStyle(
                  fontSize: 14, color: Color(0xfffafafa), height: 1.75),
            ),
          ),
          divider(),
          if (data.redeemItems != null) ...buildRedeemItems(data.redeemItems!),
        ],
      ),
    );
  }
}

class _RedeemItemDetail extends StatefulWidget {
  final String? imgUrl;
  final String? name;
  final List<String>? extras;
  final List<String>? redeemRecords;

  const _RedeemItemDetail({
    required this.imgUrl,
    required this.name,
    required this.extras,
    required this.redeemRecords,
  });

  @override
  State<_RedeemItemDetail> createState() => _RedeemItemDetailState();
}

class _RedeemItemDetailState extends State<_RedeemItemDetail> {
  static const _kMaxBottomSheetHeight = 80.0;
  double bottomSheetHeight = 0;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 450), () {
      bottomSheetHeight = _kMaxBottomSheetHeight;
      setState(() {});
    });
  }

  final buttonStyle = ButtonStyle(
    shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
    backgroundColor: MaterialStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xfffafafa).withOpacity(0.5);
      return const Color(0xfffafafa);
    }),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
          onClosing: () {},
          backgroundColor: const Color(0xff2a2a2a),
          enableDrag: false,
          shape: const RoundedRectangleBorder(),
          builder: (context) => AnimatedContainer(
                height: bottomSheetHeight,
                curve: Curves.easeOutCubic,
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xff3e3e3e)),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: null,
                          style: buttonStyle,
                          child: const Text('點數不足',
                              style: TextStyle(color: Color(0xff1e1e1e)))),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: buttonStyle,
                          child: const Text('思考一下',
                              style: TextStyle(color: Color(0xff1e1e1e)))),
                    ),
                  ],
                ),
              )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 22.5),
          child: Column(
            children: [
              Container(
                height: 157,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xff3e3e3e)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.imgUrl ?? '',
                      fit: BoxFit.fitHeight,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image_rounded),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(25, 5, 5, 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Text(widget.name ?? '',
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500))),
                            if (widget.extras != null)
                              const SizedBox(height: 5),
                            if (widget.extras != null)
                              ...widget.extras!
                                  .map((e) => Text(
                                        e,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 12),
                                      ))
                                  .toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 27.5),
              const SizedBox(
                height: 24.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                          height: 0, color: Color(0xff3e3e3e), thickness: 1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('近期被兌換時間',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: Divider(
                          height: 0, color: Color(0xff3e3e3e), thickness: 1),
                    ),
                  ],
                ),
              ),
              if (widget.redeemRecords != null)
                Column(
                    children:
                        widget.redeemRecords!.map((e) => Text(e)).toList()),
            ],
          ),
        ),
      ),
    );
  }
}
