import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';

enum _MpassState { info, choosePlan }

class BuyMPass extends StatefulWidget {
  const BuyMPass({Key? key}) : super(key: key);

  @override
  State<BuyMPass> createState() => _BuyMPassState();
}

class _BuyMPassState extends BaseStatefulState<BuyMPass> with BaseLoaded {
  _MpassState currentState = _MpassState.info;
  int stateIndex = 1;

  @override
  BaseViewModel? baseViewModel() => BaseViewModel();

  @override
  String? get subPageOf => 'home';

  // @override
  // Color? get customBackgroundColor => Colors.white;

  @override
  Widget body() {
    Color bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.calendar_today, size: 51, color: Color(0xfffafafa)),
          const SizedBox(height: 5),
          const Align(alignment: Alignment.center, child: Text('月票 Pass', style: TextStyle(fontSize: 17))),
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
                        decoration: const BoxDecoration(color: Color(0xfffafafa), shape: BoxShape.circle),
                        child: Icon(Icons.format_list_bulleted, size: 20, color: bgColor)),
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
                            color: stateIndex >= 2 ? const Color(0xfffafafa) : null,
                            border: stateIndex >= 2
                                ? null
                                : Border.all(color: const Color(0xff3e3e3e), width: 2)),
                        child: Icon(Icons.badge,
                            size: 20, color: stateIndex >= 2 ? bgColor : const Color(0xfffafafa))),
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
                            color: stateIndex >= 3 ? const Color(0xfffafafa) : null,
                            shape: BoxShape.circle,
                            border: stateIndex >= 3
                                ? null
                                : Border.all(color: const Color(0xff3e3e3e), width: 2)),
                        child: Icon(Icons.shopping_cart,
                            size: 20, color: stateIndex >= 3 ? bgColor : const Color(0xfffafafa))),
                    const SizedBox(width: 5),
                    const Text('買買買'),
                    const SizedBox(width: 5),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 45),
          currentState == _MpassState.info ? _previlleges() : _plans(),
          // currentState == _MpassState.info ? const SizedBox() : _mPassRule(),
        ],
      ),
    );
  }

  // Widget _mPassRule() {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(5), side: const BorderSide(width: 1, color: Color(0xffe9e9e9))),
  //     child: Padding(
  //       padding: const EdgeInsets.all(28),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           const Icon(Icons.edit, size: 35, color: Color(0xff919191)),
  //           const SizedBox(width: 18),
  //           Flexible(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: const [
  //                 Text('月費條款', style: TextStyle(color: Color(0xff5a5a5a))),
  //                 Text('1. 依付款日之有效期爲 30日x月', style: TextStyle(color: Color(0xffb7b7b7))),
  //                 Text('2. 付款後不可變更參加者資訊', style: TextStyle(color: Color(0xffb7b7b7))),
  //                 Text('3. 人氣帝方案爲付款當下填入四位邀請人，期間開始後不可變更成員', style: TextStyle(color: Color(0xffb7b7b7))),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Column _plans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        _planTile(
            '邊緣人方案',
            '掉落遊玩券數量 : 3張',
            Icons.person,
            TextButton(
                style: Themes.severe(
                    isV4: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    outlinedBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () {},
                child: const Text('99P / 1人1個月'))),
        _planTile(
            '人際帝方案',
            '掉落遊玩券數量 : 4張',
            Icons.people,
            TextButton(
                style: Themes.severe(
                    isV4: true,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    outlinedBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                onPressed: () {},
                child: const Text('399P / 5人1個月'))),
      ],
    );
  }

  Widget _planTile(String title, String describe, IconData trailIcon, Widget button) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 45),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xff2a2a2a), borderRadius: BorderRadius.circular(5)),
        child: Stack(alignment: Alignment.center, clipBehavior: Clip.hardEdge, children: [
          Positioned(
              bottom: -26, right: -24, child: Icon(trailIcon, size: 120, color: const Color(0xff3f3f3f))),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 22.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xffdcdcdc), fontSize: 17)),
                  const SizedBox(height: 5),
                  Text(describe, style: const TextStyle(color: Color(0xffb4b4b4))),
                  const SizedBox(height: 14),
                  button
                ],
              ),
            ),
          ),
        ]),
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
            border: Border.all(color: Themes.borderColor),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff2a2a2a),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.redeem, color: Color(0xfffafafa), size: 34),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: const [
                    Icon(Icons.add_circle, color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('天上掉下來的遊玩券')
                  ]),
                  const SizedBox(height: 5),
                  Row(children: const [
                    Icon(Icons.add_circle, color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('比別人更長的優惠時段')
                  ]),
                  const SizedBox(height: 5),
                  Row(children: const [
                    Icon(Icons.add_circle, color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('養成每日增加兩次加成')
                  ]),
                  const SizedBox(height: 5),
                  Row(children: const [
                    Icon(Icons.add_circle, color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('月票會員專屬活動')
                  ]),
                  const SizedBox(height: 5),
                  Row(children: const [
                    Icon(Icons.do_not_disturb_on, color: Color(0xffd60000), size: 22),
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
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Themes.borderColor),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff2a2a2a),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.card_membership, color: Color(0xfffafafa), size: 34),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: const [
                    Icon(Icons.check_circle, color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('邊緣人專屬 : 99P / mo')
                  ]),
                  const SizedBox(height: 5),
                  Row(children: const [
                    Icon(Icons.check_circle, color: Color(0xff92d34f), size: 22),
                    SizedBox(width: 5),
                    Text('人際帝專屬 : 399P / mo')
                  ]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: Themes.borderColor),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xff2a2a2a),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.edit, color: Color(0xfffafafa), size: 34),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: const [
                    Icon(Icons.cancel, color: Color(0xffd60000), size: 22),
                    SizedBox(width: 5),
                    Text('嚴禁多人共享/代投幣')
                  ]),
                  const SizedBox(height: 5),
                  Row(children: const [
                    Icon(Icons.cancel, color: Color(0xffd60000), size: 22),
                    SizedBox(width: 5),
                    Text('違約將取消方案且不可重新加入')
                  ]),
                  const SizedBox(height: 5),
                  Row(children: const [
                    Icon(Icons.cancel, color: Color(0xffd60000), size: 22),
                    SizedBox(width: 5),
                    Text('違約者養成系統將取消養成權限')
                  ]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 45),

        // _privillegeRow(
        //     title: '限定優惠',
        //     icon: const Icon(Icons.redeem, color: Color(0xffce5f57), size: 35),
        //     describes: ['1. 每月贈送多張無期限遊玩卷', '2. 專屬優惠時段，打機更優惠 (本期： 延長至19:00)', '3. 專屬遊玩券特惠購買方案 (待商城開放)']),
        // _privillegeRow(
        //     title: '關於價格',
        //     icon: const Icon(Icons.local_atm, color: Color(0xff919191), size: 35),
        //     describes: ['1. 邊緣人方案：99p / 1個月', '2. 人際帝方案：399p / 1個月']),
        // _privillegeRow(
        //     title: '限定優惠',
        //     icon: const Icon(Icons.edit, color: Color(0xff919191), size: 35),
        //     describes: ['1. 月票帳戶嚴禁共享/代投幣', '2. 如違約將取消方案永不可加入', '3. 遊玩券需要電話驗證']),
        TextButton(
            onPressed: () async {
              await EasyLoading.show();
              await Future.delayed(const Duration(milliseconds: 200));
              await EasyLoading.dismiss();
              currentState = _MpassState.choosePlan;
              stateIndex += 1;
              setState(() {});
            },
            style: Themes.severe(
                isV4: true,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                outlinedBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('選方案')),
      ],
    );
  }

  // Widget _privillegeRow({
  //   required String title,
  //   required Icon icon,
  //   required List<String> describes,
  // }) {
  //   List<Widget> _buildChildren() => describes.map((e) => Text(e)).toList();

  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 40),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //             alignment: Alignment.center,
  //             color: const Color(0xfff7f7f7),
  //             width: 70,
  //             height: 70,
  //             child: icon),
  //         const SizedBox(width: 16.8),
  //         Flexible(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(title, style: const TextStyle(fontSize: 18, color: Color(0xff404040))),
  //               DefaultTextStyle(
  //                 style: const TextStyle(fontSize: 14, color: Color(0xffb7b7b7)),
  //                 child: Flexible(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: _buildChildren(),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
