import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/mixins/color_picker_mixin.dart';
import 'package:x50pay/page/settings/popups/pad_pref_view_model.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/repository/setting_repository.dart';

class PadPrefDialog extends StatefulWidget {
  const PadPrefDialog({super.key});

  @override
  State<PadPrefDialog> createState() => _PadPrefDialogState();
}

class _PadPrefDialogState extends BaseStatefulState<PadPrefDialog> {
  final settingRepo = SettingRepository();
  late final Future<void> getPadPrefs;
  late final PadPrefsViewModel viewModel;

  void showNicknameNotSetSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
        closeIconColor: Theme.of(context).colorScheme.error,
        content: const Text('暱稱未設定'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showNicknameHasSetSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        closeIconColor: Theme.of(context).colorScheme.primary,
        content: const Text('暱稱已設定'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void savePadPref() {
    viewModel.setPadSettings(
      onNotSet: showNicknameNotSetSnackbar,
      onSet: showNicknameHasSetSnackbar,
    );
  }

  @override
  void initState() {
    super.initState();
    viewModel = PadPrefsViewModel(settingRepo);
    getPadPrefs = viewModel.getPadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return PageDialog.ios(
      title: 'X50Pad 西門排隊平板偏好選項',
      onConfirm: savePadPref,
      content: (showButtonBar) => FutureBuilder(
        future: getPadPrefs,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox();
          }
          if (snapshot.hasError) {
            return const Center(child: Text('failed'));
          } else {
            showButtonBar(true);

            return ChangeNotifierProvider.value(
              value: viewModel,
              builder: (context, child) => const _PadPrefLoaded(),
            );
          }
        },
      ),
    );
  }
}

class _PadPrefLoaded extends StatefulWidget {
  const _PadPrefLoaded();

  @override
  State<_PadPrefLoaded> createState() => __PadPrefLoadedState();
}

class __PadPrefLoadedState extends BaseStatefulState<_PadPrefLoaded>
    with ColorPickerMixin {
  Color? showColor;

  void changeNicknamePage() async {
    final viewModel = context.read<PadPrefsViewModel>();
    final nickname = viewModel.nickname;

    final newNickname = await Navigator.of(context).push<String?>(
      CupertinoPageRoute(
        builder: (context) {
          return _ChangeNicknameDialog(nickname: nickname);
        },
      ),
    );
    if (newNickname == null) return;
    viewModel.onNicknameChanged(newNickname);
  }

  @override
  void onColorChanged(Color color) {
    context.read<PadPrefsViewModel>().onShowColorChanged(color);
  }

  @override
  Color pickerColor() => showColor ?? Colors.transparent;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<PadPrefsViewModel>();

    showColor ??= viewModel.showColor;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<PadPrefsViewModel>();
    return Column(
      children: [
        CupertinoListSection.insetGrouped(
          children: [
            Selector<PadPrefsViewModel, bool>(
              selector: (context, viewModel) => viewModel.isNameHidden,
              builder: (context, isNameHidden, child) {
                return DialogSwitch.ios(
                  value: isNameHidden,
                  title: '不顯示暱稱',
                  onChanged: viewModel.onIsNameShownChanged,
                );
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
                  Selector<PadPrefsViewModel, Color>(
                    selector: (context, vm) => vm.showColor,
                    builder: (context, showColor, child) {
                      return Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: showColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                      );
                    },
                  ),
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
                    child: Selector<PadPrefsViewModel, String>(
                      selector: (context, vm) => vm.nickname,
                      builder: (context, nickname, child) => Text(
                        nickname,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: const TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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

class _ChangeNicknameDialog extends StatefulWidget {
  final String nickname;
  const _ChangeNicknameDialog({required this.nickname});

  @override
  State<_ChangeNicknameDialog> createState() => _ChangeNicknameDialogState();
}

class _ChangeNicknameDialogState extends State<_ChangeNicknameDialog> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.nickname);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageDialog.ios(
      title: '平板上顯示不同暱稱',
      onConfirm: () {
        Navigator.of(context).pop(
          nameController.text.isEmpty ? null : nameController.text,
        );
      },
      content: (showButtonBar) {
        showButtonBar(true);

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            children: [
              CupertinoTextField(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff1c1c1e),
                  borderRadius: BorderRadius.circular(11),
                ),
                placeholder: widget.nickname,
                controller: nameController,
                autofocus: true,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
