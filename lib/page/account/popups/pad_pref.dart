part of '../account.dart';

class PadPrefDialog extends StatefulWidget {
  final AccountViewModel viewModel;

  const PadPrefDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<PadPrefDialog> createState() => _PadPrefDialogState();
}

class _PadPrefDialogState extends State<PadPrefDialog> {
  late Future<bool> getPadSettings;
  Color? shColor;

  @override
  void initState() {
    getPadSettings = widget.viewModel.getPadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _Dialog(
      saveCallback: () {},
      content: FutureBuilder(
          future: getPadSettings,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: Text('loading'));
            }
            if (snapshot.data != true) {
              return const Center(child: Text('failed'));
            } else {
              final model = widget.viewModel.padSettingsModel!;
              final name = TextEditingController(text: model.shname);
              bool isNameShown = model.shid;
              shColor ??= _HexColor(model.shcolor);

              return _DialogBody(
                title: 'x50Pad 西門排隊平板偏好選項',
                children: [
                  _DialogSwitch(value: isNameShown, title: '不顯示暱稱'),
                  const SizedBox(height: 22.4),
                  _DialogWidget(
                      title: '選擇暱稱顯示顏色',
                      child: GestureDetector(
                        onTap: () {
                          _showColorPicker(context);
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                            width: double.infinity,
                            height: 40,
                            decoration: BoxDecoration(
                              color: shColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: const Color(0xffd9d9d9), width: 1),
                            )),
                      )),
                  _DialogWidget(
                      title: '平板上顯示不同暱稱',
                      child: Row(children: [Expanded(child: TextField(controller: name))])),
                ],
              );
            }
          }),
    );
  }

  Future<dynamic> _showColorPicker(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: shColor!,
                enableAlpha: false,
                onColorChanged: (color) {
                  shColor = color;
                  setState(() {});
                },
              ),
            ),
          );
        });
  }
}

class _HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  _HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
