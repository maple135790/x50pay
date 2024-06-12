import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/mixins/game_mixin.dart';
import 'package:x50pay/page/game/cab_select_view_model.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_data.dart';
import 'package:x50pay/providers/coin_insertion_provider.dart';
import 'package:x50pay/providers/entry_provider.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/repository.dart';

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
  final int cabNum;
  final QRPayData qrPayData;
  final bool _isFromCabDetail;
  final bool _isFromQRPay;
  final VoidCallback? onDestroy;
  final VoidCallback? onCreated;
  static const _emptyQRPayData = QRPayData.empty();

  const CabSelect({
    super.key,
    required this.caboid,
    required this.cabNum,
    required this.cabinetData,
    this.onCreated,
    this.onDestroy,
  })  : _isFromCabDetail = false,
        _isFromQRPay = false,
        qrPayData = _emptyQRPayData;

  const CabSelect.fromCabDetail({
    super.key,
    required this.caboid,
    required this.cabNum,
    required this.cabinetData,
    this.onCreated,
    this.onDestroy,
  })  : _isFromCabDetail = true,
        _isFromQRPay = false,
        qrPayData = _emptyQRPayData;

  const CabSelect.fromQRPay({
    super.key,
    required this.qrPayData,
    this.onCreated,
    this.onDestroy,
  })  : _isFromCabDetail = false,
        _isFromQRPay = true,
        caboid = '',
        cabNum = -1,
        cabinetData = const Cabinet.empty();

  @override
  State<CabSelect> createState() => _CabSelectState();
}

class _CabSelectState extends BaseStatefulState<CabSelect> with GameMixin {
  final repo = Repository();
  late final CabSelectViewModel viewModel;
  late final cabData = widget.cabinetData;
  late bool isUseRewardPoint;
  PaymentType? paymentType;
  String selectedRawPayUrl = '';
  bool isPayPressed = false;
  List? selectedMode;

  String get gameCabImage => widget._isFromQRPay
      ? widget.qrPayData.gameCabImageUrl
      : getGameCabImage(cabData.id);

  int get cabNum => widget._isFromQRPay ? widget.qrPayData.cabNum : cabData.num;

  List<List<dynamic>> get cabModes =>
      widget._isFromQRPay ? widget.qrPayData.mode : cabData.mode;

  String get cabLabel =>
      widget._isFromQRPay ? widget.qrPayData.cabLabel : cabData.label;

  void onSelectPaymentType(
    List<dynamic> mode,
    String qrPayUrl, {
    required PaymentType type,
  }) {
    selectedRawPayUrl = qrPayUrl;
    selectedMode = mode;
    paymentType = type;
    setState(() {});
  }

  void onUseRewardPointChanged(bool? value) {
    if (value == null) return;
    isUseRewardPoint = value;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.onCreated?.call();
    isUseRewardPoint = context.read<UserProvider>().user?.givebool == 1;
    viewModel = CabSelectViewModel(
      repository: repo,
      onInsertSuccess: () {
        GlobalSingleton.instance.recentPlayedCabinetData = (
          cabinet: widget.cabinetData,
          cabNum: widget.cabNum,
          caboid: widget.caboid
        );
      },
      onAfterInserted: () async {
        final userProvider = context.read<UserProvider>();
        final entryProvider = context.read<EntryProvider>();
        await userProvider.checkUser();
        await entryProvider.checkEntry();
      },
    );
  }

  @override
  void dispose() {
    widget.onDestroy?.call();
    super.dispose();
  }

  void onPayConfirmPressed() async {
    final router = GoRouter.of(context);
    final coinProvider = context.read<CoinInsertionProvider>();
    bool insertSuccess = false;
    isPayPressed = true;
    setState(() {});

    if (widget._isFromQRPay) {
      insertSuccess = await viewModel.doInsertQRPay(url: selectedRawPayUrl);
    } else {
      insertSuccess = await viewModel.doInsert(
        isUseRewardPoint: isUseRewardPoint,
        id: widget.caboid,
        index: widget.cabNum,
        isTicket: paymentType == PaymentType.ticket,
        mode:
            paymentType != PaymentType.reloadCoin ? selectedMode!.first : 9999,
      );
    }
    if (widget._isFromCabDetail) router.pop();
    if (insertSuccess) {
      coinProvider.isCoinInserted = true;
      router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final paymentOptions = <Widget>[];

    final staffOption = Selector<UserProvider, bool>(
      selector: (context, provider) => provider.user?.isStaff ?? false,
      builder: (context, isStaff, child) {
        if (!isStaff) return const SizedBox();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Text('工作人員補幣'),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                paymentType = PaymentType.reloadCoin;
                setState(() {});
              },
              style: CustomButtonThemes.severe(isV4: true),
              child: const Text('補幣'),
            ),
          ],
        );
      },
    );

    for (final mode in cabModes) {
      final double price = double.parse(mode.last.toString());
      paymentOptions
        ..add(const SizedBox(height: 20))
        ..add(Text(
          mode[1],
          textAlign: TextAlign.center,
        ))
        ..add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  var qrPayUrl = '';
                  if (widget._isFromQRPay) {
                    qrPayUrl = mode.first[0].toString();
                  }
                  onSelectPaymentType(
                    mode,
                    qrPayUrl,
                    type: PaymentType.point,
                  );
                },
                style: CustomButtonThemes.severe(isV4: true),
                child: Text('${price.toInt()}P'),
              ),
              const SizedBox(width: 15),
              Selector<UserProvider, bool>(
                selector: (context, provider) =>
                    provider.user?.hasTicket ?? false,
                builder: (context, hasTicket, child) {
                  return TextButton(
                    onPressed: hasTicket
                        ? () {
                            var qrPayUrl = '';
                            if (widget._isFromQRPay) {
                              qrPayUrl = mode.first[1].toString();
                            }
                            onSelectPaymentType(
                              mode,
                              qrPayUrl,
                              type: PaymentType.ticket,
                            );
                          }
                        : null,
                    style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                    child: Text(i18n.gameTicket),
                  );
                },
              ),
            ],
          ),
        );
    }
    final cabImage = SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: gameCabImage,
              alignment: const Alignment(0, -0.25),
              fit: BoxFit.fitWidth,
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
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cabLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          blurRadius: 18,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$cabNum號機',
                        style: const TextStyle(
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    final selectPayment = SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          cabImage,
          const SizedBox(height: 15),
          ...paymentOptions,
          staffOption,
        ],
      ),
    );

    final useRewardPointCheckBox = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox.adaptive(
          value: isUseRewardPoint,
          onChanged: onUseRewardPointChanged,
        ),
        GestureDetector(
          onTap: () {
            onUseRewardPointChanged(!isUseRewardPoint);
          },
          child: const Text.rich(
            TextSpan(
              text: '用回饋',
              children: [
                TextSpan(
                  text: ' (無法集計道數/參與部分活動)',
                  style: TextStyle(
                    color: Color(0xFFEAC912),
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );

    final confirmPayment = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '注意！請確認是否有玩家正在遊玩。',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 14),
              Text(
                '機種：$cabLabel',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '編號：$cabNum號機',
                style: const TextStyle(fontSize: 18),
              ),
              if (paymentType != null)
                Text(
                  '消費：${paymentType!.text}',
                  style: const TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 12.6),
              const Text(
                '請勿影響他人權益。如投幣扣點後機台無動作請聯絡粉專！請勿再次點擊',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
              if (paymentType != PaymentType.ticket) useRewardPointCheckBox,
              const SizedBox(height: 16),
            ],
          ),
        ),
        const Divider(thickness: 1, height: 0),
        Container(
          color: dialogButtomBarColor,
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
                    style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextButton(
                    onPressed: isPayPressed ? null : onPayConfirmPressed,
                    style: CustomButtonThemes.severe(isV4: true),
                    child: isPayPressed ? const Text('請稍等') : const Text('確認'),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.hardEdge,
      contentPadding: paymentType != null
          ? const EdgeInsets.only(top: 14)
          : const EdgeInsets.only(bottom: 20),
      content: paymentType != null ? confirmPayment : selectPayment,
    );
  }
}
