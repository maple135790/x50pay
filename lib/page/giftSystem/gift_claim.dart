part of "gift_system.dart";

class _GiftClaim extends StatelessWidget {
  final List<CanChange> canChangeList;
  const _GiftClaim({Key? key, required this.canChangeList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: canChangeList.length,
      prototypeItem: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.comfortable,
          title: const Text('',
              style: TextStyle(color: Color(0xfffafafa), fontSize: 14)),
          subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Text('', style: TextStyle(color: Color(0xfffafafa), fontSize: 14))
            ],
          ),
          trailing: ElevatedButton(
              onPressed: null, style: Themes.grey(), child: const Text('已領取')),
        ),
      ),
      itemBuilder: (context, index) {
        late String subtitle, buttonText;
        if (canChangeList[index].name.contains('抽選')) {
          subtitle = '請於想抽的月份自助兌換';
          buttonText = '馬上抽';
        } else {
          subtitle = '粉絲專頁預約';
          buttonText = '領禮物';
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.comfortable,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                  imageUrl: canChangeList[index].pic, width: 50),
            ),
            title: Text(canChangeList[index].name,
                style: const TextStyle(color: Color(0xfffafafa), fontSize: 14)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xfffafafa), fontSize: 14)),
              ],
            ),
            trailing: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _ConfirmChangeDialog(
                            gid: canChangeList[index].gid);
                      });
                  getGiftDialog(canChangeList[index].gid);
                },
                style: Themes.severe(isV4: true),
                child: Text(buttonText)),
          ),
        );
      },
    );
  }

  void getGiftDialog(String gid) {}
}

class _ConfirmChangeDialog extends StatelessWidget {
  final String gid;

  const _ConfirmChangeDialog({Key? key, required this.gid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 60, color: Color(0xfffafafa)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('請確認已經出示給工作人員看過'),
                SizedBox(height: 16),
                Text('您確定要兌換禮物嗎？',
                    style: TextStyle(
                        color: Color(0xfffad814), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(thickness: 1, height: 0),
          Container(
            color: const Color(0xff2a2a2a),
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: Themes.cancel(),
                      child: const Text('取消')),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextButton(
                      onPressed: () async {
                        final nav = GoRouter.of(context);
                        kDebugMode
                            ? null
                            : await Repository().giftExchange(gid);
                        await EasyLoading.showSuccess('成功兌換,將會回到首頁',
                            duration: const Duration(milliseconds: 800));
                        await Future.delayed(const Duration(milliseconds: 800));

                        nav.goNamed(AppRoutes.home.routeName);
                      },
                      style: Themes.severe(isV4: true),
                      child: const Text('確認')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
