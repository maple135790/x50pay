part of "gift_system.dart";

class _ClaimedGift extends StatelessWidget {
  final List<AlChange> claimedList;
  const _ClaimedGift({Key? key, required this.claimedList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: claimedList.length,
      prototypeItem: ListTile(
        visualDensity: VisualDensity.comfortable,
        title: const Text('', style: TextStyle(color: Color(0xfffafafa), fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 4),
            Text('', style: TextStyle(color: Color(0xfffafafa), fontSize: 14))
          ],
        ),
        trailing: ElevatedButton(onPressed: null, style: Themes.grey(), child: const Text('已領取')),
      ),
      itemBuilder: (context, index) {
        late String subtitle;
        if (claimedList[index].auto) {
          subtitle = '已自動發送至會員帳號';
        } else if (claimedList[index].name.contains('抽選')) {
          subtitle = '請於想抽的月份自助兌換';
        } else {
          subtitle = '粉絲專頁預約';
        }

        return ListTile(
          visualDensity: VisualDensity.comfortable,
          leading: Image(image: NetworkImage(claimedList[index].pic)),
          title:
              Text(claimedList[index].name, style: const TextStyle(color: Color(0xfffafafa), fontSize: 14)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Color(0xfffafafa), fontSize: 14)),
            ],
          ),
          trailing: ElevatedButton(onPressed: null, style: Themes.grey(), child: const Text('已領取')),
        );
      },
    );
  }
}
