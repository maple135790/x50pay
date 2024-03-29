import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/mixins/color_picker_mixin.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';

class PadPrefDialog extends StatefulWidget {
  const PadPrefDialog({super.key});

  @override
  State<PadPrefDialog> createState() => _PadPrefDialogState();
}

class _PadPrefDialogState extends BaseStatefulState<PadPrefDialog> {
  bool gotModel = false;
  _PadPrefModalValue? modalValue;

  void savePadPref(SettingsViewModel viewModel) {
    if (gotModel == false || modalValue == null) return;
    viewModel.setPadSettings(
      isNicknameShown: modalValue!.isNameShown,
      nickname: modalValue!.nickname,
      showColor: "#${modalValue!.showColor}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(builder: (context, viewModel, child) {
      final getPadSettings = viewModel.getPadSettings();

      return PageDialog.ios(
        title: 'X50Pad 西門排隊平板偏好選項',
        onConfirm: () {
          savePadPref(viewModel);
        },
        content: (showButtonBar) => FutureBuilder(
          future: getPadSettings,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            if (snapshot.hasError) {
              return const Center(child: Text('failed'));
            } else {
              showButtonBar(true);

              gotModel = true;
              final model = snapshot.data!;
              return _PadPrefLoaded(
                model: model,
                getValues: (value) {
                  modalValue = value;
                },
              );
            }
          },
        ),
      );
    });
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

  const _PadPrefLoaded({required this.model, required this.getValues});

  @override
  State<_PadPrefLoaded> createState() => __PadPrefLoadedState();
}

class __PadPrefLoadedState extends BaseStatefulState<_PadPrefLoaded>
    with ColorPickerMixin {
  late String nickname;
  late bool isNameShown;
  Color? showColor;

  void changeNicknamePage() async {
    final nameController = TextEditingController(text: nickname);

    final newNickname =
        await Navigator.of(context).push<String?>(CupertinoPageRoute(
      builder: (context) => PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          nameController.dispose();
        },
        child: PageDialog.ios(
          title: '平板上顯示不同暱稱',
          onConfirm: () {
            Navigator.of(context)
                .pop(nameController.text.isEmpty ? null : nameController.text);
          },
          content: (showButtonBar) {
            showButtonBar(true);

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                children: [
                  CupertinoTextField(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xff1c1c1e),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    placeholder: nickname,
                    controller: nameController,
                    autofocus: true,
                    style: const TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                ],
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

  void updateValue() {
    widget.getValues.call((
      nickname: nickname,
      isNameShown: isNameShown,
      showColor: showColor!.value.toRadixString(16).substring(2),
    ));
  }

  @override
  void onColorChanged(Color color) {
    showColor = color;
    setState(() {});
  }

  @override
  Color pickerColor() => showColor ?? Colors.black;

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
                        border: Border.all(color: borderColor, width: 1),
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
                  LimitedBox(
                    maxWidth: 120,
                    child: Text(nickname,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
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
