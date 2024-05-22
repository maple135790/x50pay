import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';

class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends BaseStatefulState<ChangeEmailDialog> {
  String? errorText;
  bool isEnabled = false;
  final newEmail = TextEditingController();

  void changeEmail(SettingsViewModel viewModel) async {
    final nav = GoRouter.of(context);
    final isServerResponded = await viewModel.changeEmail(email: newEmail.text);
    if (isServerResponded) {
      switch (viewModel.response!.code) {
        case 200:
          errorText = null;
          await EasyLoading.showSuccess('信箱變更成功，請至您的 Email 信箱收取驗證信',
              dismissOnTap: false, duration: const Duration(seconds: 2));
          await Future.delayed(const Duration(seconds: 2));
          await EasyLoading.show(dismissOnTap: false);
          nav.goNamed(AppRoutes.home.routeName);
          break;
        case 700:
          errorText = '新信箱與舊信箱相同';
          break;
        case 701:
          errorText = '這個信箱已被使用過';
          break;
        default:
          showServiceError();
      }
      setState(() {});
    } else {
      showServiceError();
    }
  }

  Widget confirmButton(SettingsViewModel vm) {
    return TextButton(
      style: buttonStyle,
      onPressed: isEnabled
          ? () {
              changeEmail(vm);
            }
          : null,
      child: isEnabled ? const Text('確認') : const Text('請輸入信箱'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, vm, child) {
        return PageDialog.ios(
          title: '更改信箱',
          customConfirmButton: confirmButton(vm),
          content: (showButtonBar) {
            showButtonBar(true);

            return CupertinoListSection.insetGrouped(
              footer: Text(
                errorText ?? '',
                style: const TextStyle(color: Colors.red),
              ),
              children: [
                CupertinoTextFormFieldRow(
                  prefix: const Text('新的 Email'),
                  controller: newEmail,
                  textAlign: TextAlign.end,
                  placeholder: '請輸入欲更改的 Email 信箱地址',
                  onChanged: (value) {
                    isEnabled = newEmail.text.isNotEmpty;
                    setState(() {});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
