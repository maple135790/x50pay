import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/game/cab_select_view_model.dart';
import 'package:x50pay/page/game/game_mixin.dart';
import 'package:x50pay/page/scan/scan_pay_data.dart';

enum PaymentType {
  point('點數'),
  ticket('遊玩券'),
  reloadCoin('點數');

  final String text;
  const PaymentType(this.text);
}

class CabSelect extends StatefulWidget {
  final String caboid;
  final Cabinet cabinetData;
  final int cabIndex;
  final ScanPayData scanPayData;
  final bool _isFromCabDetail;
  final bool _isFromScanPay;
  static const _emptyScanPayData = ScanPayData.empty();

  const CabSelect({
    super.key,
    required this.caboid,
    required this.cabIndex,
    required this.cabinetData,
  })  : _isFromCabDetail = false,
        _isFromScanPay = false,
        scanPayData = _emptyScanPayData;

  const CabSelect.fromCabDetail({
    super.key,
    required this.caboid,
    required this.cabIndex,
    required this.cabinetData,
  })  : _isFromCabDetail = true,
        _isFromScanPay = false,
        scanPayData = _emptyScanPayData;

  const CabSelect.fromScanPay({
    super.key,
    required this.scanPayData,
  })  : _isFromCabDetail = false,
        _isFromScanPay = true,
        caboid = '',
        cabIndex = -1,
        cabinetData = const Cabinet.empty();

  @override
  State<CabSelect> createState() => _CabSelectState();
}

class _CabSelectState extends State<CabSelect> with GameMixin {
  final viewModel = CabSelectViewModel();
  late final cabData = widget.cabinetData;
  late PaymentType paymentType;
  late bool isUseRewardPoint = isUseRewardPoint =
      GlobalSingleton.instance.userNotifier.value?.givebool == 1;
  String selectedRawPayUrl = '';
  bool isSelectPayment = false;
  bool isPayPressed = false;
  List? selectedMode;

  String get gameCabImage => widget._isFromScanPay
      ? widget.scanPayData.gameCabImageUrl
      : getGameCabImage(cabData.id);

  int get cabNum =>
      widget._isFromScanPay ? widget.scanPayData.cabNum : cabData.num;

  List<List<dynamic>> get cabModes =>
      widget._isFromScanPay ? widget.scanPayData.mode : cabData.mode;

  String get cabLabel =>
      widget._isFromScanPay ? widget.scanPayData.cabLabel : cabData.label;

  void onUseRewardPointChanged(bool? value) {
    if (value == null) return;
    isUseRewardPoint = value;
    setState(() {});
  }

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

  Widget buildUseRewardPointCheckBox() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox.adaptive(
          value: isUseRewardPoint,
          onChanged: onUseRewardPointChanged,
          activeColor: const Color(0xff0e52a5),
          checkColor: Colors.white,
        ),
        GestureDetector(
          onTap: () {
            onUseRewardPointChanged(!isUseRewardPoint);
          },
          child: const Text.rich(TextSpan(text: '用回饋', children: [
            TextSpan(
                text: '(無法集計道數/參與部分活動)',
                style: TextStyle(color: Color(0xffffec3d)))
          ])),
        ),
      ],
    );
  }

  Column confirmPayment() {
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
              Text('機種：$cabLabel', style: const TextStyle(fontSize: 18)),
              Text('編號：$cabNum號機', style: const TextStyle(fontSize: 18)),
              Text('消費：${paymentType.text}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12.6),
              const Text('請勿影響他人權益。如投幣扣點後機台無動作請聯絡粉專！請勿再次點擊',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 13)),
              if (paymentType != PaymentType.ticket)
                buildUseRewardPointCheckBox(),
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
                      onPressed: isPayPressed ? null : onPayConfirmPressed,
                      style: Themes.severe(isV4: true),
                      child:
                          isPayPressed ? const Text('請稍等') : const Text('確認')),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void onPayConfirmPressed() async {
    final router = GoRouter.of(context);
    isPayPressed = true;
    setState(() {});

    late final BasicResponse? serverResponse;
    if (widget._isFromScanPay) {
      serverResponse = await viewModel.doInsertScanPay(url: selectedRawPayUrl);
    } else {
      serverResponse = await viewModel.doInsert(
        isUseRewardPoint: isUseRewardPoint,
        id: widget.caboid,
        index: widget.cabIndex,
        isTicket: paymentType == PaymentType.ticket,
        mode:
            paymentType != PaymentType.reloadCoin ? selectedMode!.first : 9999,
      );
    }
    if (widget._isFromCabDetail) router.pop();
    if (serverResponse != null) {
      String msg = '';
      String describe = '';
      bool is200 = false;
      switch (serverResponse.code) {
        case 200:
          is200 = true;
          msg = '投幣成功，感謝您的惠顧！';
          describe = '請等候約三秒鐘，若機台仍無反應請盡速與X50粉絲專頁聯絡';
          if (!widget._isFromScanPay) {
            GlobalSingleton.instance.recentPlayedCabinetData = (
              cabinet: widget.cabinetData,
              cabIndex: widget.cabIndex,
              caboid: widget.caboid
            );
          }
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
      await EasyLoading.showError('投幣失敗\n請確認您的網路環境，再次重試，如多次無法請回報粉專');
    }
    await Future.delayed(const Duration(seconds: 2));
    await GlobalSingleton.instance.checkUser(force: true);
    router.pop(true);
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
                    child: CachedNetworkImage(
                        imageUrl: gameCabImage,
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
                        Text(cabLabel,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 18)
                                ])),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('$cabNum號機',
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

    for (List mode in cabModes) {
      final double price = double.parse(mode.last.toString());
      children
        ..add(const SizedBox(height: 20))
        ..add(Text(mode[1], style: const TextStyle(color: Color(0xfffafafa))))
        ..add(ButtonBar(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
                onPressed: () {
                  if (widget._isFromScanPay) {
                    selectedRawPayUrl = mode.first[0].toString();
                  }
                  selectedMode = mode;
                  isSelectPayment = true;
                  paymentType = PaymentType.point;
                  setState(() {});
                },
                style: Themes.severe(isV4: true),
                child: Text('${price.toInt()}P')),
            ValueListenableBuilder(
              valueListenable: GlobalSingleton.instance.userNotifier,
              builder: (context, user, child) {
                return TextButton(
                    onPressed: user?.hasTicket ?? false
                        ? () {
                            if (widget._isFromScanPay) {
                              selectedRawPayUrl = mode.first[1].toString();
                            }
                            selectedMode = mode;
                            isSelectPayment = true;
                            paymentType = PaymentType.ticket;
                            setState(() {});
                          }
                        : null,
                    style: Themes.pale(),
                    child: const Text('遊玩券'));
              },
            ),
          ],
        ));
    }
    return Column(mainAxisSize: MainAxisSize.min, children: [
      ...children,
      ValueListenableBuilder(
        valueListenable: GlobalSingleton.instance.userNotifier,
        builder: (context, user, child) {
          if (!(user?.isStaff ?? false)) return const SizedBox();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text('工作人員補幣', style: TextStyle(color: Color(0xfffafafa))),
              const SizedBox(height: 5),
              TextButton(
                  onPressed: () {
                    isSelectPayment = true;
                    paymentType = PaymentType.reloadCoin;
                    setState(() {});
                  },
                  style: Themes.severe(isV4: true),
                  child: const Text('補幣')),
            ],
          );
        },
      ),
    ]);
  }
}
