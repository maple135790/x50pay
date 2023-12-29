import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/quest_campaign/campaign.dart';
import 'package:x50pay/common/models/quest_campaign/redeem_item.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/common/theme/svg_path.dart';
import 'package:x50pay/page/quest_campaign/quest_campaign_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class QuestCampaign extends StatefulWidget {
  final String campaignId;
  const QuestCampaign({super.key, required this.campaignId});

  @override
  State<QuestCampaign> createState() => _QuestCampaignState();
}

class _QuestCampaignState extends BaseStatefulState<QuestCampaign> {
  static const stampSlotSize = 40.0;
  final repo = Repository();
  late final viewModel =
      QuestCampaignViewModel(repository: repo, campaignId: widget.campaignId);
  late Future<Campaign?> init;
  int ownedPoints = 0;

  Color get stampSlotColor =>
      isDarkTheme ? const Color(0xfffafafa) : const Color(0xffb2b2b2);
  Color get stampColor => isDarkTheme
      ? const Color(0xff373737)
      : const Color(0xff373737).withOpacity(0.2);

  Future<void> onAddStampRowTap() async {
    viewModel.onAddStampRowTap();
    context.goNamed(
      AppRoutes.questCampaign.routeName,
      pathParameters: {'couid': widget.campaignId},
      extra: true,
    );
  }

  @override
  void initState() {
    super.initState();
    init = viewModel.init();
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
            showServiceError();
            return Center(child: Text(serviceErrorText));
          }
          final model = snapshot.data as Campaign;
          ownedPoints = model.ownedPoints;
          return Scrollbar(
            child: SingleChildScrollView(
              child: campaignLoaded(model),
            ),
          );
        });
  }

  Widget divider() => Divider(color: borderColor, height: 16);

  void showRedeemItemDialog({
    required String? imgUrl,
    required String? name,
    required List<String>? extras,
    required List<String>? redeemRecords,
    required bool exchangeable,
    required VoidCallback onRedeemButtonPressed,
  }) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) {
        return _RedeemItemDetail(
          imgUrl: imgUrl,
          name: name,
          extras: extras,
          redeemRecords: redeemRecords,
          redeemable: exchangeable,
          onRedeemButtonPressed: onRedeemButtonPressed,
        );
      },
    ));
  }

  Widget buildStampRow(int stampRowCount, {required int ownedStampCount}) {
    return Column(
      children: [
        SizedBox(
          height: ((stampSlotSize + 22) * stampRowCount).toDouble(),
          // child: Column(
          //   children: List.generate(
          //     growable: false,
          //     stampRowCounts,
          //     (rowIndex) => Column(
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             ...List.generate(6, (colIndex) {
          //               final hasStamp =
          //                   (rowIndex * 6 + colIndex + 1 > stampCounts);

          //               return Container(
          //                 margin: colIndex != 0
          //                     ? const EdgeInsets.only(left: 7.5)
          //                     : null,
          //                 padding: colIndex != 0
          //                     ? const EdgeInsets.only(left: 15)
          //                     : null,
          //                 decoration: colIndex != 0
          //                     ? const BoxDecoration(
          //                         border: Border(
          //                             left: BorderSide(
          //                           color: Color(0xff5a5a5a),
          //                         )),
          //                       )
          //                     : null,
          //                 child: Center(
          //                   child: hasStamp
          //                       ? Icon(
          //                           Icons.circle_rounded,
          //                           size: 35,
          //                           color: const Color(0xfffafafa)
          //                               .withOpacity(0.2),
          //                         )
          //                       : SizedBox.fromSize(
          //                           size: const Size.square(35),
          //                           child: SvgPicture(
          //                             Svgs.stamp,
          //                             width: 25,
          //                             height: 25,
          //                             colorFilter: SvgsExtension.colorFilter(
          //                                 const Color(0xfffafafa)),
          //                           ),
          //                         ),
          //                 ),
          //               );
          //             })
          //           ],
          //         ),
          //         divider(),
          //       ],
          //     ),
          //   ),
          // ),
          child: GridView.builder(
            itemCount: stampRowCount * 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: index + 6 < stampRowCount * 6
                      ? Border(bottom: BorderSide(color: borderColor))
                      : null,
                ),
                child: Container(
                  margin: const EdgeInsets.all(7.5),
                  child: Center(
                    child: index + 1 > ownedStampCount
                        ? Icon(
                            Icons.circle_rounded,
                            size: stampSlotSize,
                            color: stampSlotColor.withOpacity(0.2),
                          )
                        : SizedBox.fromSize(
                            size: const Size.square(stampSlotSize),
                            child: SvgPicture(
                              Svgs.stamp,
                              width: 25,
                              height: 25,
                              colorFilter:
                                  SvgsExtension.colorFilter(stampColor),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: onAddStampRowTap,
                style: buttonStyle,
                child: const Text(
                  '增加一行欄位',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
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
            border: Border.all(
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
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
                style: const TextStyle(height: 2),
              )),
              const SizedBox(width: 15),
              SizedBox(
                width: 75,
                child: Center(
                  child: TextButton(
                    style: CustomButtonThemes.severe(isV4: true),
                    onPressed: () {
                      showRedeemItemDialog(
                        imgUrl: item.imgUrl,
                        name: item.name,
                        extras: item.extra,
                        redeemRecords: item.recentRedeemTime,
                        exchangeable: ownedPoints >= item.points,
                        onRedeemButtonPressed: () =>
                            viewModel.onRedeemItemPressed(item.id),
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
              border: Border.all(color: borderColor),
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
                            const Icon(
                              Icons.schedule_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(data.campaignGoodThruDate ?? '',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(width: 10.281),
                            const Icon(
                              Icons.workspace_premium_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
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
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6),
            ),
            child: buildStampRow(
              data.stampRowCounts ?? 1,
              ownedStampCount: ownedPoints,
            ),
          ),
          divider(),
          Center(
            child: Text(
              data.pointInfo ?? '',
              style: const TextStyle(fontSize: 14, height: 1.75),
            ),
          ),
          divider(),
          if (data.redeemItems != null) ...buildRedeemItems(data.redeemItems!),
          const SizedBox(height: 15),
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
  final VoidCallback onRedeemButtonPressed;
  final bool redeemable;

  const _RedeemItemDetail({
    required this.imgUrl,
    required this.name,
    required this.extras,
    required this.redeemRecords,
    required this.redeemable,
    required this.onRedeemButtonPressed,
  });

  @override
  State<_RedeemItemDetail> createState() => _RedeemItemDetailState();
}

class _RedeemItemDetailState extends BaseStatefulState<_RedeemItemDetail> {
  static const _kMaxBottomSheetHeight = 80.0;
  Offset _offset = const Offset(0, 1);
  double bottomSheetHeight = 0;

  Widget buildRedeemButton() {
    if (!widget.redeemable) {
      return TextButton(
        onPressed: null,
        style: buttonStyle,
        child: const Text('點數不足'),
      );
    }
    return TextButton(
      onPressed: widget.onRedeemButtonPressed,
      style: buttonStyle,
      child: const Text('兌換'),
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 450), () {
      bottomSheetHeight = _kMaxBottomSheetHeight;
      _offset = const Offset(0, 0);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
        bottomSheet: BottomSheet(
            onClosing: () {},
            enableDrag: false,
            dragHandleSize: Size.zero,
            shape: const RoundedRectangleBorder(),
            builder: (context) => AnimatedSlide(
                  offset: _offset,
                  curve: Curves.easeOutExpo,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: borderColor)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: buildRedeemButton()),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: buttonStyle,
                              child: const Text('思考一下')),
                        ),
                      ],
                    ),
                  ),
                )),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 22.5),
              child: Column(
                children: [
                  Container(
                    height: 157,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
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
                                  ...widget.extras!.map((e) => Text(
                                        e,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(fontSize: 12),
                                      )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 27.5),
                  SizedBox(
                    height: 24.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            height: 0,
                            color: borderColor,
                            thickness: 1,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('近期被兌換時間',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Expanded(
                          child: Divider(
                            height: 0,
                            color: borderColor,
                            thickness: 1,
                          ),
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
        ),
      ),
    );
  }
}
