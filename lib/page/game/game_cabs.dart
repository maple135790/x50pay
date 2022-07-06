part of 'game.dart';

class _GameCabs extends StatelessWidget {
  final Gamelist games;
  final String storeName;

  const _GameCabs({required this.games, required this.storeName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Machine> machine = games.machine!;
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
            decoration: BoxDecoration(
                color: const Color(0xfffbfbfb),
                border: Border.all(color: const Color(0xffededed), width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Icon(Icons.pin_drop, color: Color(0xff5a5a5a), size: 16),
                Text('  目前所在「$storeName」', style: const TextStyle(color: Color(0xff5a5a5a))),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('store_name');
                      await prefs.remove('store_id');
                      nav.pushReplacementNamed(AppRoute.game);
                    },
                    style: Themes.confirm(),
                    child: const Text('切換店鋪'))
              ],
            )),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: machine.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => _GameCabItem(machine[index]),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe9e9e9), width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('優惠時段:\n', style: TextStyle(color: Color(0xff5a5a5a), fontSize: 16)),
              Text('●   WACCA / GC / 女武神 / pop\'n 無提供優惠方案\n', style: TextStyle(color: Color(0xff5a5a5a))),
              Text('●   月票： 全日延長至 19:00 優惠時段', style: TextStyle(color: Color(0xff5a5a5a))),
            ],
          ),
        )
      ],
    );
  }
}

class _GameCabItem extends StatelessWidget {
  final Machine machine;
  const _GameCabItem(this.machine, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWeekend = DateTime.now().weekday == 6 || DateTime.now().weekday == 7;
    final time = machine.mode![0][3] == true ? "優惠時段" : "通常時段";
    final addition = machine.vipb == true
        ? " [月票]"
        : isWeekend
            ? " 23:00 ~ 13:00 [假日]"
            : " 22:00 ~ 15:00 [平日]";

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: GestureDetector(
        onTap: () async {
          Navigator.of(context).push(NoTransitionRouter(_CabDetail(machine.id!)));
        },
        child: SizedBox(
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Positioned.fill(child: Image(image: _getBackground(machine.id!), fit: BoxFit.fitWidth)),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.1, 1]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(machine.lable!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              shadows: [Shadow(color: Colors.black, blurRadius: 18)])),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        const Icon(Icons.schedule, size: 16, color: Color(0xe6ffffff)),
                        Text('  | $time$addition',
                            style: const TextStyle(
                                color: Color(0xffbcbfbf),
                                fontSize: 16,
                                shadows: [Shadow(color: Colors.black, blurRadius: 15)]))
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
