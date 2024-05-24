import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/repository/repository.dart';

enum _MpassProgressState {
  info(1),
  choosePlan(2),
  // ignore: unused_field
  donePurchase(3);

  final int step;
  const _MpassProgressState(this.step);
}

enum _MpassProgram {
  loner(
      name: '邊緣人',
      price: 99,
      priceDesc: '1人1個月',
      ticAmount: 3,
      icon: Icons.person_rounded,
      discountTimeDesc: '較長',
      raisingBounsAmount: 2),
  partyPeople(
      name: '人際帝',
      price: 399,
      priceDesc: '5人1個月',
      isAllowMultiPeople: true,
      ticAmount: 4,
      icon: Icons.people_rounded,
      discountTimeDesc: '較長',
      raisingBounsAmount: 2),
  monthlyRaising(
      name: '月養成',
      price: 349,
      priceDesc: '1人1個月',
      ticAmount: 3,
      icon: Icons.confirmation_number_rounded,
      discountTimeDesc: '全日',
      raisingBounsAmount: 40);

  final int ticAmount;
  final String name;
  final String discountTimeDesc;
  final int raisingBounsAmount;
  final int price;
  final String priceDesc;
  final IconData icon;
  final bool isAllowMultiPeople;

  const _MpassProgram({
    required this.ticAmount,
    required this.name,
    required this.discountTimeDesc,
    required this.raisingBounsAmount,
    required this.price,
    required this.priceDesc,
    required this.icon,
    this.isAllowMultiPeople = false,
  });
}

class BuyMPass extends StatefulWidget {
  const BuyMPass({super.key});

  @override
  State<BuyMPass> createState() => _BuyMPassState();
}

class _BuyMPassState extends BaseStatefulState<BuyMPass> {
  _MpassProgressState currentState = _MpassProgressState.info;
  int stateIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.calendar_today_rounded, size: 51),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  '月票 Pass',
                  style: TextStyle(fontSize: 17),
                ),
              ),
              const SizedBox(height: 45),
              IntrinsicWidth(
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: iconColor,
                            shape: BoxShape.circle,
                          ),
                          child: currentState.step > 1
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: scaffoldBackgroundColor,
                                )
                              : Icon(
                                  Icons.format_list_bulleted_rounded,
                                  size: 20,
                                  color: scaffoldBackgroundColor,
                                ),
                        ),
                        const SizedBox(width: 5),
                        const Text('讀條款'),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const Expanded(child: Divider(thickness: 2)),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: stateIndex >= 2 ? iconColor : null,
                                border: stateIndex >= 2
                                    ? null
                                    : Border.all(color: borderColor, width: 2)),
                            child: currentState.step > 2
                                ? Icon(Icons.check_rounded,
                                    size: 20, color: scaffoldBackgroundColor)
                                : Icon(Icons.badge_rounded,
                                    size: 20,
                                    color: stateIndex >= 2
                                        ? scaffoldBackgroundColor
                                        : iconColor)),
                        const SizedBox(width: 5),
                        const Text('選方案'),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const Expanded(child: Divider(thickness: 2)),
                    const SizedBox(width: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: stateIndex >= 3 ? iconColor : null,
                                shape: BoxShape.circle,
                                border: stateIndex >= 3
                                    ? null
                                    : Border.all(color: borderColor, width: 2)),
                            child: Icon(
                              Icons.shopping_cart_rounded,
                              size: 20,
                              color: stateIndex >= 3
                                  ? scaffoldBackgroundColor
                                  : iconColor,
                            )),
                        const SizedBox(width: 5),
                        const Text('買買買'),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              currentState == _MpassProgressState.info
                  ? _previlleges()
                  : _plans(),
            ],
          ),
        ),
      ),
    );
  }

  Column _plans() {
    void showPurchaseDialog(_MpassProgram program) {
      showDialog(
        context: context,
        builder: (context) => _MpassPurchaseDialog(program),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: _MpassProgram.values
          .map((program) => _planTile(
                '${program.name}方案',
                '掉落遊玩券數量 : ${program.ticAmount}',
                program.icon,
                TextButton(
                    style: CustomButtonThemes.severe(
                      isV4: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: () {
                      showPurchaseDialog(program);
                    },
                    child: Text('${program.price} / ${program.priceDesc}')),
              ))
          .toList(),
    );
  }

  Widget _planTile(
    String title,
    String describe,
    IconData trailIcon,
    Widget selectButton,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 45),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(color: cardColor),
          child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                    bottom: -26,
                    right: -24,
                    child: Icon(trailIcon,
                        size: 120, color: iconColor.withOpacity(0.1))),
                Positioned(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 22.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 17)),
                        const SizedBox(height: 5),
                        Text(describe),
                        const SizedBox(height: 14),
                        selectButton
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Column _previlleges() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
            color: cardColor,
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.redeem_rounded, size: 34),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Icon(Icons.add_circle_rounded,
                        color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('天上掉下來的遊玩券')
                  ]),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.add_circle_rounded,
                        color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('比別人更長的優惠時段')
                  ]),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.add_circle_rounded,
                        color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('養成每日增加兩次加成')
                  ]),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.add_circle_rounded,
                        color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('月票會員專屬活動')
                  ]),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.do_not_disturb_on_rounded,
                        color: Color(0xffd60000), size: 22),
                    SizedBox(width: 5),
                    Text('沒有專屬停車位')
                  ]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
            color: cardColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.card_membership_rounded, color: iconColor, size: 34),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _MpassProgram.values.map((program) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Color(0xff92d34f), size: 22),
                      const SizedBox(width: 5),
                      Text('${program.name}專屬 : ${program.price} / mo')
                    ]),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8),
            color: cardColor,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.edit_rounded, color: iconColor, size: 34),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    Icon(Icons.cancel_rounded,
                        color: Color(0xffd60000), size: 22),
                    SizedBox(width: 5),
                    Text('嚴禁多人共享/代投幣')
                  ]),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.cancel_rounded,
                        color: Color(0xffd60000), size: 22),
                    SizedBox(width: 5),
                    Text('違約將取消方案且不可重新加入')
                  ]),
                  SizedBox(height: 5),
                  Row(children: [
                    Icon(Icons.cancel_rounded,
                        color: Color(0xffd60000), size: 22),
                    SizedBox(width: 5),
                    Text('違約者養成系統將取消養成權限')
                  ]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        TextButton(
            onPressed: () async {
              await EasyLoading.show();
              await Future.delayed(const Duration(milliseconds: 200));
              await EasyLoading.dismiss();
              currentState = _MpassProgressState.choosePlan;
              stateIndex += 1;
              setState(() {});
            },
            style: CustomButtonThemes.severe(
              isV4: true,
              padding: const EdgeInsets.symmetric(horizontal: 25),
            ),
            child: const Text('選方案')),
      ],
    );
  }
}

class _MpassPurchaseDialog extends StatefulWidget {
  final _MpassProgram program;
  const _MpassPurchaseDialog(this.program);

  @override
  State<_MpassPurchaseDialog> createState() => _MpassPurchaseDialogState();
}

class _MpassPurchaseDialogState
    extends BaseStatefulState<_MpassPurchaseDialog> {
  late List<TextEditingController> emails;
  ValueNotifier<String?> errorMsgNotifier = ValueNotifier(null);

  List<Widget> buildTextfields() {
    final widgets = <Widget>[];
    final otherApplicantAmount = int.parse(widget.program.priceDesc[0]) - 1;
    emails = List<TextEditingController>.generate(
        otherApplicantAmount, (index) => TextEditingController());

    int counter = 0;
    for (var emailController in emails) {
      counter++;
      widgets
        ..add(TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_rounded),
              hintText: ' 朋友$counter號的 Email',
            )))
        ..add(const SizedBox(height: 10));
    }
    return widgets;
  }

  List<Widget> buildContent() {
    if (widget.program.isAllowMultiPeople) {
      return [
        const Text('請在此填邀請名單，扣款後無法反悔或修改', style: TextStyle(fontSize: 17)),
        const SizedBox(height: 15),
        Text('扣除 ${widget.program.price} Points，有效期一個月'),
        const SizedBox(height: 15),
        ValueListenableBuilder(
            valueListenable: errorMsgNotifier,
            builder: (context, errorMsg, child) {
              return Text(
                  errorMsg ??
                      '可以三人、兩人甚至只有你一人就購買此方案，購買後無法中途加入，送出後就無法更改了。請確實填寫Email再按送出！',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xffff0000)));
            }),
        const SizedBox(height: 15),
        ...buildTextfields()
      ];
    } else {
      return [
        const Text('下一步就回不去了，即將扣款', style: TextStyle(fontSize: 17)),
        const SizedBox(height: 15),
        Text('扣除 ${widget.program.price} Points，有效期一個月'),
      ];
    }
  }

  void submitEmails() {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    int count = 0;
    bool hasError = false;
    for (var email in emails) {
      if (email.text.isEmpty) break;
      count++;
      if (!emailRegex.hasMatch(email.text)) {
        errorMsgNotifier.value = '朋友$count號 Email格式錯誤';
        hasError = true;
        break;
      }
    }
    if (!hasError) confirmSubmit();
  }

  void confirmSubmit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('購買確認'),
              content: const Text('未填完全部的欄位？真的要送出嗎？沒填滿四人是你的損失喔!!!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('關閉'),
                ),
                TextButton(
                  onPressed: doBuyVip,
                  child: const Text('送出'),
                ),
              ],
            ));
  }

  void doBuyVip() async {
    final repo = Repository();
    final nav = GoRouter.of(context);

    switch (widget.program) {
      case _MpassProgram.loner:
        if (GlobalSingleton.instance.isServiceOnline) {
          final rawResponse = await repo.buyVipOne();
          parseResponse(rawResponse);
        } else {
          EasyLoading.showSuccess('購買成功，感謝您的惠顧');
        }
        break;
      case _MpassProgram.partyPeople:
        List<String>? emailList;
        for (var email in emails) {
          if (email.text.isEmpty) continue;
          emailList ??= [];
          emailList.add(email.text);
        }
        log("email: $emailList", name: "doBuyVip");
        if (GlobalSingleton.instance.isServiceOnline) {
          final rawResponse = await repo.buyVipMany(emailList);
          parseResponse(rawResponse);
        } else {
          EasyLoading.showSuccess('購買成功，感謝您的惠顧');
        }
        break;
      case _MpassProgram.monthlyRaising:
        if (GlobalSingleton.instance.isServiceOnline) {
          final rawResponse = await repo.buyVipGradeOne();
          parseResponse(rawResponse);
        } else {
          EasyLoading.showSuccess('購買成功，感謝您的惠顧');
        }
        break;
    }
    await Future.delayed(const Duration(seconds: 2)).then((_) {
      nav
        ..pop()
        ..goNamed(AppRoutes.home.routeName);
    });
  }

  void parseResponse(http.Response response) {
    final json = jsonDecode(response.body);
    if (json['code'] == 200) {
      EasyLoading.showSuccess('購買成功，感謝您的惠顧');
    } else if (json['code'] == 800) {
      EasyLoading.showError('餘額不足');
    } else if (json['code'] == 801) {
      EasyLoading.showError('朋友的Email填寫錯誤，查無此人');
    } else {
      EasyLoading.showError('投幣失敗，請回報X50');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 15),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_rounded, size: 70),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: buildContent(),
              ),
            ),
            Divider(thickness: 1, height: 0, color: borderColor),
            Container(
              color: dialogButtomBarColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: widget.program.isAllowMultiPeople
                        ? submitEmails
                        : doBuyVip,
                    style: CustomButtonThemes.severe(isV4: true),
                    child: Text('${widget.program.price}P / mo'),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                    child: const Text('取消'),
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
