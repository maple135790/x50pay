part of "collab.dart";

class _CollabShopList extends StatefulWidget {
  /// 商家清單/兌換頁面
  const _CollabShopList();

  @override
  State<_CollabShopList> createState() => __CollabShopListState();
}

class __CollabShopListState extends BaseStatefulState<_CollabShopList> {
  final repo = Repository();
  late final viewModel = CollabShopListViewModel(repository: repo);

  void showQRCodeScan() async {
    var status = await Permission.camera.status;
    if (status.isDenied) await Permission.camera.request();
    if (context.mounted) {
      context.pushNamed(
        AppRoutes.scanQRCode.routeName,
        extra: status,
      );
    }
  }

  Widget buildSponserTiles(List<Sponser> sponserData) {
    List<Widget> tiles = [];

    for (var data in sponserData) {
      tiles.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: SizedBox(
            height: 86.812,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: CachedNetworkImageProvider(data.sponserImgUrl),
                    fit: BoxFit.fill,
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image(
                            image: R.svg.shop_solid(width: 19.25, height: 15),
                            color: const Color(0xfffafafa)),
                        const SizedBox(width: 10),
                        Text(data.sponserName,
                            style: const TextStyle(height: 2))
                      ],
                    ),
                    ...data.meta
                        .map((e) => Text(e, style: const TextStyle(height: 2)))
                        .toList(),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tiles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: viewModel.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: SizedBox());
          }
          if (snapshot.hasError) {
            return Center(child: Text(serviceErrorText));
          }

          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
                  child: GestureDetector(
                    onTap: showQRCodeScan,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: const Color(0xff2a2a2a),
                          borderRadius: BorderRadius.circular(5)),
                      alignment: Alignment.center,
                      height: 93.86,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.qr_code_rounded,
                              size: 28, color: Colors.white),
                          Text('點我掃店鋪 QRCode',
                              style: TextStyle(
                                  color: Color(0xffdcdcdc), fontSize: 17)),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                buildSponserTiles(data),
              ],
            ),
          );
        });
  }
}
