part of "gift_system.dart";

class _LotteBox extends StatelessWidget {
  final LotteListModel lotteList;
  const _LotteBox({Key? key, required this.lotteList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff2a2a2a),
      padding: const EdgeInsets.symmetric(vertical: 52.2, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.how_to_vote_rounded,
              size: 92, color: Color(0xff5e5e5e)),
          const SizedBox(height: 15),
          const Text('立即參與抽獎',
              style: TextStyle(color: Color(0xffdcdcdc), fontSize: 17)),
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
