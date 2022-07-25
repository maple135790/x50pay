part of 'game.dart';

class _GameCabs extends StatelessWidget {
  final Gamelist games;
  final String storeName;

  const _GameCabs({required this.games, required this.storeName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    List<Machine> machine = games.machine!;
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
            decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: Themes.borderColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Icon(Icons.push_pin, color: Color(0xfffafafa), size: 16),
                Text('  目前所在「 $storeName 」', style: const TextStyle(color: Color(0xfffafafa))),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    final nav = Navigator.of(context);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('store_name');
                    await prefs.remove('store_id');
                    nav.pushReplacementNamed(AppRoute.game);
                  },
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8), color: const Color(0xfffafafa)),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Icon(Icons.sync, color: bgColor, size: 26),
                  ),
                ),
              ],
            )),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: machine.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => _GameCabItem(machine[index]),
        ),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Themes.borderColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
            ),
            Positioned(
                left: 35,
                top: 12,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: const Text('優惠時段', style: TextStyle(color: Color(0xfffafafa), fontSize: 13)),
                )),
            Positioned(
              top: 40,
              left: 35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('●   WACCA / GC / 女武神 / pop\'n 無提供優惠方案', style: TextStyle(color: Color(0xfffafafa))),
                  SizedBox(height: 5),
                  Text('●   月票： 全日延長至 19:00 優惠時段', style: TextStyle(color: Color(0xfffafafa))),
                ],
              ),
            )
          ],
        ),
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
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), border: Border.all(color: Themes.borderColor)),
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image(
                        image: _getBackground(machine.id!),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter)),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                          colors: [Colors.black54, Colors.transparent],
                          radius: 2.5,
                          focalRadius: 5,
                          center: Alignment(-1, 1.8),
                          stops: [0.3, 1]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(machine.lable!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              shadows: [Shadow(color: Colors.black, blurRadius: 18)])),
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        const Icon(Icons.schedule, size: 15, color: Color(0xe6ffffff)),
                        Text('  $time$addition',
                            style: const TextStyle(
                                color: Color(0xffffffe6),
                                fontSize: 13,
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
