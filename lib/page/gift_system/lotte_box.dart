import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/models/lotteList/lotte_list.dart';
import 'package:x50pay/page/gift_system/gift_system_view_model.dart';

class LotteBox extends StatelessWidget {
  /// 養成抽獎箱頁面
  const LotteBox({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final lotteList = context.select<GiftSystemViewModel, LotteListModel>(
        (vm) => vm.lotteList ?? LotteListModel.empty());

    return Container(
      color: isDarkTheme ? const Color(0xff2a2a2a) : const Color(0xfff2f2f2),
      padding: const EdgeInsets.symmetric(vertical: 52.2, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.how_to_vote_rounded, size: 92),
          const SizedBox(height: 15),
          const Text('立即參與抽獎', style: TextStyle(fontSize: 17)),
          Text('您擁有的抽獎券 : ${lotteList.self}'),
          const SizedBox(height: 16),
          Text('本次獎品 : ${lotteList.name}'),
          Text('抽獎截止 : ${lotteList.date}'),
          Text('參與票數 : ${lotteList.tic}'),
        ],
      ),
    );
  }
}
