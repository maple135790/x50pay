part of '../account.dart';

class PadPrefDialog extends StatefulWidget {
  final AccountViewModel viewModel;

  const PadPrefDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<PadPrefDialog> createState() => _PadPrefDialogState();
}

class _PadPrefDialogState extends State<PadPrefDialog> {
  bool gotModel = false;
  _PadPrefModalValue? modalValue;
  late Future<PadSettingsModel?> getPadSettings;

  @override
  void initState() {
    getPadSettings = widget.viewModel.getPadSettings();
    super.initState();
  }

  void savePadPref() {
    if (gotModel == false || modalValue == null) return;
    widget.viewModel.setPadSettings(
      isNicknameShown: modalValue!.isNameShown,
      nickname: modalValue!.nickname,
      showColor: modalValue!.showColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AccountDialog.ios(
      title: 'X50Pad 西門排隊平板偏好選項',
      onConfirm: savePadPref,
      content: (showButtonBar) => FutureBuilder(
          future: getPadSettings,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return kDebugMode
                  ? const Center(child: Text('loading'))
                  : const SizedBox();
            }
            if (snapshot.data == null) {
              return kDebugMode
                  ? const Center(child: Text('failed'))
                  : const SizedBox();
            } else {
              showButtonBar(true);

              gotModel = true;
              return _PadPrefLoaded(
                model: widget.viewModel.padSettingsModel!,
                getValues: (value) {
                  modalValue = value;
                },
              );
            }
          }),
    );
  }
}

typedef _PadPrefModalValue = ({
  String nickname,
  String showColor,
  bool isNameShown
});

class _PadPrefLoaded extends StatefulWidget {
  final PadSettingsModel model;
  final void Function(_PadPrefModalValue value) getValues;

  const _PadPrefLoaded({required this.model, required this.getValues, Key? key})
      : super(key: key);

  @override
  State<_PadPrefLoaded> createState() => __PadPrefLoadedState();
}

class __PadPrefLoadedState extends State<_PadPrefLoaded> {
  late String nickname;
  late bool isNameShown;
  Color? showColor;

  void changeNicknamePage() async {
    final nameController = TextEditingController(text: nickname);

    final newNickname =
        await Navigator.of(context).push<String?>(CupertinoPageRoute(
      builder: (context) => WillPopScope(
        onWillPop: () async {
          log(nameController.text, name: 'changeNicknamePage');
          Navigator.of(context)
              .pop(nameController.text.isEmpty ? null : nameController.text);
          nameController.dispose();
          return true;
        },
        child: AccountDialog.ios(
          title: '平板上顯示不同暱稱',
          content: (showButtonBar) {
            showButtonBar(true);

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: CupertinoTextField(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff1c1c1e),
                  borderRadius: BorderRadius.circular(11),
                ),
                placeholder: nickname,
                controller: nameController,
                autofocus: true,
                style: const TextStyle(
                    color: CupertinoColors.white, fontWeight: FontWeight.w500),
              ),
            );
          },
        ),
      ),
    ));
    if (newNickname == null) return;
    nickname = newNickname;
    log(nickname, name: 'changeNicknamePage nickname');
    setState(() {});
    return;
  }

  Future<dynamic> showColorPicker() {
    return showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: showColor!,
                enableAlpha: false,
                onColorChanged: (color) {
                  showColor = color;
                  setState(() {});
                },
              ),
            ),
          );
        });
  }

  void updateValue() {
    widget.getValues.call((
      nickname: nickname,
      isNameShown: isNameShown,
      showColor: showColor!.value.toRadixString(16).substring(2),
    ));
  }

  @override
  void initState() {
    super.initState();
    nickname = widget.model.shname;
    isNameShown = widget.model.shid;
    showColor ??= _HexColor(widget.model.shcolor);
  }

  @override
  Widget build(BuildContext context) {
    updateValue();
    return Column(
      children: [
        CupertinoListSection.insetGrouped(
          children: [
            DialogSwitch.ios(
              value: isNameShown,
              title: '不顯示暱稱',
              onChanged: (value) {
                isNameShown = value;
                setState(() {});
                updateValue();
              },
            ),
          ],
        ),
        CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile.notched(
              title: const Text('選擇暱稱顯示顏色'),
              onTap: showColorPicker,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: showColor,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: const Color(0xffd9d9d9), width: 1),
                      )),
                  const SizedBox(width: 10),
                  const CupertinoListTileChevron(),
                ],
              ),
            ),
            CupertinoListTile.notched(
              title: const Text('平板上顯示不同暱稱'),
              onTap: changeNicknamePage,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(nickname,
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontWeight: FontWeight.w500,
                      )),
                  const SizedBox(width: 10),
                  const CupertinoListTileChevron(),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";

    return int.parse(hexColor, radix: 16);
  }

  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
