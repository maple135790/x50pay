part of 'game.dart';

class GameCabs extends StatefulWidget {
  final Gamelist games;
  final String storeName;

  const GameCabs({required this.games, required this.storeName, super.key});

  @override
  State<GameCabs> createState() => _GameCabsState();
}

class _GameCabsState extends State<GameCabs> {
  late List<Machine> machine = widget.games.machine!;

  void onChangeStoreTap() async {
    final router = GoRouter.of(context);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('store_name');
    await prefs.remove('store_id');
    router.goNamed(AppRoutes.game.routeName, extra: true);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              padding: const EdgeInsets.fromLTRB(15, 8, 10, 8),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border.all(color: Themes.borderColor, width: 1),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  const Icon(Icons.push_pin,
                      color: Color(0xfffafafa), size: 16),
                  Text('  目前所在「 ${widget.storeName} 」',
                      style: const TextStyle(color: Color(0xfffafafa))),
                  const Spacer(),
                  GestureDetector(
                    onTap: onChangeStoreTap,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xfffafafa)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Icon(Icons.sync,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 26),
                    ),
                  ),
                ],
              )),
          Column(children: machine.map((e) => _GameCabItem(e)).toList()),
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
                    child: const Text('離峰時段',
                        style:
                            TextStyle(color: Color(0xfffafafa), fontSize: 13)),
                  )),
              const Positioned(
                top: 40,
                left: 35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('●   部分機種不提供離峰方案',
                        style: TextStyle(color: Color(0xfffafafa))),
                    SizedBox(height: 5),
                    Text('●   詳情請見粉絲專業更新貼文',
                        style: TextStyle(color: Color(0xfffafafa))),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _GameCabItem extends StatelessWidget {
  final Machine machine;
  const _GameCabItem(this.machine, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWeekend =
        DateTime.now().weekday == 6 || DateTime.now().weekday == 7;
    final time = machine.mode![0][3] == true ? "離峰時段" : "通常時段";
    final addition = machine.vipb == true
        ? " [月票]"
        : isWeekend
            ? " [假日]"
            : " [平日]";

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      child: GestureDetector(
        onTap: () async {
          final router = GoRouter.of(context);
          final bool? isTokenInserted = await router.pushNamed(
            AppRoutes.gameCab.routeName,
            pathParameters: {'mid': machine.id!},
          );
          if (isTokenInserted == true) {
            log('isTokenInserted: $isTokenInserted');
            router.goNamed(
              AppRoutes.game.routeName,
              extra: true,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: Themes.borderColor,
                  strokeAlign: BorderSide.strokeAlignOutside)),
          height: 155,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image(
                  image: _getGameCabImage(machine.id!),
                  color: const Color.fromARGB(35, 0, 0, 0),
                  colorBlendMode: BlendMode.srcATop,
                  fit: BoxFit.fitWidth,
                  alignment: const Alignment(0, -0.25),
                )),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [Colors.black, Colors.transparent],
                        transform: GradientRotation(12),
                        stops: [0, 0.6],
                      ),
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
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 18)
                              ])),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(Icons.schedule,
                                size: 15, color: Color(0xe6ffffff)),
                            Text('  $time$addition',
                                style: const TextStyle(
                                    color: Color(0xffffffe6),
                                    fontSize: 13,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black, blurRadius: 15)
                                    ]))
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
