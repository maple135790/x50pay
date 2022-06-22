part of 'game.dart';

class _GameCabs extends StatelessWidget {
  final Gamelist games;
  final String storeName;

  const _GameCabs({required this.games, required this.storeName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MachineList> machineList = games.machineList!;
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
            decoration: BoxDecoration(
              color: const Color(0xfffbfbfb),
              border: Border.all(color: const Color(0xffededed), width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const Icon(Icons.pin_drop, color: Color(0xff5a5a5a), size: 16),
                Text('  目前所在「$storeName」', style: const TextStyle(color: Color(0xff5a5a5a))),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      final nav = Navigator.of(context);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      nav.pushReplacementNamed(AppRoute.game);
                    },
                    style: Themes.confirm(),
                    child: const Text('切換店鋪'))
              ],
            )),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: machineList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) => _GameCabItem(machineList[index]),
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
  final MachineList machine;
  const _GameCabItem(this.machine, {Key? key}) : super(key: key);

  ImageProvider _getBackground(String gameId) {
    if (gameId == 'chu') {
      return R.image.chu();
    }
    if (gameId == 'ddr') {
      return R.image.ddr();
    }
    if (gameId == 'gc') {
      return R.image.gc();
    }
    if (gameId == 'ju') {
      return R.image.ju();
    }
    if (gameId == 'mmdx') {
      return R.image.mmdx();
    }
    if (gameId == 'nvsv') {
      return R.image.nvsv();
    }
    if (gameId == 'pop') {
      return R.image.pop();
    }
    if (gameId == 'sdvx') {
      return R.image.sdvx();
    }
    if (gameId == 'tko') {
      return R.image.tko();
    }
    if (gameId == 'wac') {
      return R.image.wac();
    }
    if (gameId == 'x40chu') {
      return R.image.x40chu();
    }
    if (gameId == 'x40ddr') {
      return R.image.x40ddr();
    }
    if (gameId == 'x40maidx') {
      return R.image.x40maidx();
    }
    if (gameId == 'x40sdvx') {
      return R.image.x40sdvx();
    }
    if (gameId == 'x40tko') {
      return R.image.x40tko();
    }
    if (gameId == 'x40wac') {
      return R.image.x40wac();
    }
    return R.image.logo_150_jpg();
  }

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
        onTap: () async {},
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
