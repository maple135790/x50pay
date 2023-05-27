part of "collab.dart";

class _CollabShopList extends StatefulWidget {
  const _CollabShopList();

  @override
  State<_CollabShopList> createState() => __CollabShopListState();
}

class __CollabShopListState extends State<_CollabShopList> {
  void showQRCodeScan() async {
    var status = await Permission.camera.status;
    if (status.isDenied) await Permission.camera.request();
    if (context.mounted) {
      showDialog(context: context, builder: (context) => ScanQRCode(status == PermissionStatus.granted));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                decoration:
                    BoxDecoration(color: const Color(0xff2a2a2a), borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                height: 93.86,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_rounded, size: 28, color: Colors.white),
                    Text('點我掃店鋪 QRCode', style: TextStyle(color: Color(0xffdcdcdc), fontSize: 17)),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 19),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.titleHeight,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: 4),
              dense: false,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network('https://pay.x50.fun/static/gc/01.jpg',
                    fit: BoxFit.fill, width: 80, height: 80, cacheHeight: 80, cacheWidth: 80),
              ),
              subtitleTextStyle: const TextStyle(color: Color(0xfffafafa)),
              isThreeLine: true,
              title: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.store_mall_directory_rounded), Text('獅子林冰茶')]),
              subtitle: const Text(
                '萬華區西寧南路36-1號\n每杯折抵5元',
                style: TextStyle(color: Color(0xfffafafa)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
