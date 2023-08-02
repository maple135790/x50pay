part of '../account.dart';

class ChangeEmailDialog extends StatefulWidget {
  final AccountViewModel viewModel;
  const ChangeEmailDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  late AccountViewModel viewModel;
  String? _errorText;
  bool isEnabled = false;
  final newEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
  }

  void changeEmail() async {
    final nav = GoRouter.of(context);
    if (await viewModel.changeEmail(email: newEmail.text, debugFlag: 200)) {
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
          await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50',
              dismissOnTap: false, duration: const Duration(seconds: 2));
      }
    } else {
      await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50',
          dismissOnTap: false, duration: const Duration(seconds: 2));
    }
  }

  Widget confirmButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isEnabled ? changeEmail : null,
      child: isEnabled ? const Text('確認') : const Text('請輸入信箱'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _Dialog.ios(
      title: '更改信箱',
      onConfirm: changeEmail,
      customConfirmButton: confirmButton(),
      content: CupertinoListSection.insetGrouped(
        footer:
            Text(_errorText ?? '', style: const TextStyle(color: Colors.red)),
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
      ),
    );
  }
}
