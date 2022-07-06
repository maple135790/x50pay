import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';

class BuyMPass extends StatefulWidget {
  const BuyMPass({Key? key}) : super(key: key);

  @override
  State<BuyMPass> createState() => _BuyMPassState();
}

class _BuyMPassState extends BaseStatefulState<BuyMPass> with BaseLoaded {
  @override
  BaseViewModel? baseViewModel() => BaseViewModel()..isFunctionalHeader = true;

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
            angle: 15,
            child: const Icon(Icons.local_activity, size: 74, color: Color(0xff404040)),
          ),
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('X50MGS 會員月票訂閱', style: TextStyle(fontSize: 25, color: Color(0xff404040)))),
          const Text('關於訂閱制月票會員方案', style: TextStyle(color: Color(0xff5a5a5a))),
          const SizedBox(height: 40),
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
          TextButton(onPressed: hasVip ? null : () {}, style: Themes.confirm(), child: const Text('我要續費/購買')),
        ],
      ),
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
            child: icon,
          ),
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
