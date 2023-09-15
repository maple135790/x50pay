import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';

class ChangeEmailDialog extends StatefulWidget {
  const ChangeEmailDialog({super.key});

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends BaseStatefulState<ChangeEmailDialog> {
  late final SettingsViewModel viewModel;
  String? _errorText;
  bool isEnabled = false;
  final newEmail = TextEditingController();

  void changeEmail() async {
    final nav = GoRouter.of(context);
    if (await viewModel.changeEmail(email: newEmail.text)) {
      switch (viewModel.response!.code) {
        case 200:
          _errorText = null;
          await EasyLoading.showSuccess('信箱變更成功，請至您的 Email 信箱收取驗證信',
              dismissOnTap: false, duration: const Duration(seconds: 2));
          await Future.delayed(const Duration(seconds: 2));
          await EasyLoading.show(dismissOnTap: false);
          nav.goNamed(AppRoutes.login.routeName);
          break;
        case 700:
          setState(() {
            _errorText = '新信箱與舊信箱相同';
          });
          break;
        case 701:
          setState(() {
            _errorText = '這個信箱已被使用過';
          });
          break;
        default:
          showServiceError();
      }
    } else {
      showServiceError();
    }
  }

  final buttonStyle = ButtonStyle(
    shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
    foregroundColor: MaterialStateColor.resolveWith((states) {
      return const Color(0xff1e1e1e);
    }),
    backgroundColor: MaterialStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xfffafafa).withOpacity(0.5);
      return const Color(0xfffafafa);
    }),
  );

  Widget confirmButton() {
    return TextButton(
      style: buttonStyle,
      onPressed: isEnabled ? changeEmail : null,
      child: isEnabled ? const Text('確認') : const Text('請輸入信箱'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, vm, child) {
        viewModel = vm;

        return PageDialog.ios(
          title: '更改信箱',
          onConfirm: changeEmail,
          customConfirmButton: confirmButton(),
          content: (showButtonBar) {
            showButtonBar(true);

            return CupertinoListSection.insetGrouped(
              footer: Text(_errorText ?? '',
                  style: const TextStyle(color: Colors.red)),
              children: [
                CupertinoTextFormFieldRow(
                  prefix: const Text('新的 Email'),
                  controller: newEmail,
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
