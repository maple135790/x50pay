import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';

enum _MpassState { info, choosePlan }

class BuyMPass extends StatefulWidget {
  const BuyMPass({Key? key}) : super(key: key);

  @override
  State<BuyMPass> createState() => _BuyMPassState();
}

class _BuyMPassState extends BaseStatefulState<BuyMPass> with BaseLoaded {
  _MpassState state = _MpassState.info;

  @override
  BaseViewModel? baseViewModel() => BaseViewModel();

  @override
  String? get subPageOf => 'home';

  @override
  Color? get customBackgroundColor => Colors.white;

  @override
  Widget body() {
    final hasVip = GlobalSingleton.instance.user!.vip!;

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Transform.rotate(
              angle: 15, child: const Icon(Icons.local_activity, size: 74, color: Color(0xff404040))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(state == _MpassState.info ? 'X50MGS 會員月票訂閱' : '立即訂閱月票',
                  style: const TextStyle(fontSize: 25, color: Color(0xff404040)))),
          Text(state == _MpassState.info ? '關於訂閱制月票會員方案' : '關於付費訂閱相關方式',
              style: const TextStyle(color: Color(0xff5a5a5a))),
          const SizedBox(height: 40),
          state == _MpassState.info ? _previlleges(hasVip) : _plans(),
          state == _MpassState.info ? const SizedBox() : _mPassRule(),
        ],
      ),
    );
  }

  Widget _mPassRule() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), side: const BorderSide(width: 1, color: Color(0xffe9e9e9))),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.edit, size: 35, color: Color(0xff919191)),
            const SizedBox(width: 18),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('月費條款', style: TextStyle(color: Color(0xff5a5a5a))),
                  Text('1. 依付款日之有效期爲 30日x月', style: TextStyle(color: Color(0xffb7b7b7))),
                  Text('2. 付款後不可變更參加者資訊', style: TextStyle(color: Color(0xffb7b7b7))),
                  Text('3. 人氣帝方案爲付款當下填入四位邀請人，期間開始後不可變更成員', style: TextStyle(color: Color(0xffb7b7b7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _plans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        _planTile(
            '邊緣人方案', [Icons.local_atm, Icons.redeem], ['方案價格：99p(1人)/1個月', '專屬權益：每月固定贈送3張遊玩券'], Icons.person),
        _planTile('人際帝方案', [Icons.local_atm, Icons.redeem], ['方案價格：399p(1~5人)/1個月', '專屬權益：每月依成員數贈送每人4張遊玩券'],
            Icons.people)
      ],
    );
  }

  Widget _planTile(String title, List<IconData> icons, List<String> describes, IconData trailIcon) {
    List<Widget> contents = [];

    for (int i = 0; i < icons.length; i++) {
      contents.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icons[i], color: const Color(0xff404040), size: 16),
          const SizedBox(width: 8),
          Text(describes[i], style: const TextStyle(color: Color(0xff404040))),
        ],
      ));
      if (i != icons.length - 1) contents.add(const SizedBox(height: 8));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Material(
        elevation: 4,
        type: MaterialType.card,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 14),
            child: Stack(clipBehavior: Clip.hardEdge, children: [
              Positioned(
                  bottom: -26, right: -24, child: Icon(trailIcon, size: 120, color: const Color(0xffdedede))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xff404040), fontSize: 18)),
                  const SizedBox(height: 14),
                  ...contents,
                  const SizedBox(height: 14),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Column _previlleges(bool hasVip) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _privillegeRow(
            title: '限定優惠',
            icon: const Icon(Icons.redeem, color: Color(0xffce5f57), size: 35),
            describes: ['1. 每月贈送多張無期限遊玩卷', '2. 專屬優惠時段，打機更優惠 (本期： 延長至19:00)', '3. 專屬遊玩券特惠購買方案 (待商城開放)']),
        _privillegeRow(
            title: '關於價格',
            icon: const Icon(Icons.local_atm, color: Color(0xff919191), size: 35),
            describes: ['1. 邊緣人方案：99p / 1個月', '2. 人際帝方案：399p / 1個月']),
        _privillegeRow(
            title: '限定優惠',
            icon: const Icon(Icons.edit, color: Color(0xff919191), size: 35),
            describes: ['1. 月票帳戶嚴禁共享/代投幣', '2. 如違約將取消方案永不可加入', '3. 遊玩券需要電話驗證']),
        TextButton(
            onPressed: hasVip
                ? null
                : () async {
                    await EasyLoading.show();
                    await Future.delayed(const Duration(milliseconds: 200));
                    state = _MpassState.choosePlan;
                    setState(() {});
                  },
            style: Themes.confirm(),
            child: const Text('我要續費/購買')),
      ],
    );
  }

  Widget _privillegeRow({
    required String title,
    required Icon icon,
    required List<String> describes,
  }) {
    List<Widget> _buildChildren() => describes.map((e) => Text(e)).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              alignment: Alignment.center,
              color: const Color(0xfff7f7f7),
              width: 70,
              height: 70,
              child: icon),
          const SizedBox(width: 16.8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, color: Color(0xff404040))),
                DefaultTextStyle(
                  style: const TextStyle(fontSize: 14, color: Color(0xffb7b7b7)),
                  child: Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: _buildChildren(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
