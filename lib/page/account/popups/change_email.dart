part of '../account.dart';

class ChangeEmailDialog extends StatefulWidget {
  final AccountViewModel viewModel;
  const ChangeEmailDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<ChangeEmailDialog> createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  late AccountViewModel model;
  String? _errorText;
  final newEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return _Dialog(
      saveCallback: () async {
        final nav = Navigator.of(context);
        if (await model.changeEmail(email: newEmail.text, debugFlag: 200)) {
          switch (model.response!.code) {
            case 200:
              _errorText = null;
              await EasyLoading.showSuccess('信箱變更成功，請至您的 Email 信箱收取驗證信',
                  dismissOnTap: false, duration: const Duration(seconds: 2));
              await Future.delayed(const Duration(seconds: 2));
              await EasyLoading.show(dismissOnTap: false);
              nav.pushNamedAndRemoveUntil(AppRoute.login, (route) => false);
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
      },
      content: _DialogBody(
        title: '更改信箱',
        children: [
          RichText(text: TextSpan(text: _errorText, style: const TextStyle(color: Colors.red))),
          _DialogWidget(
            title: '新的 Email',
            isRequired: true,
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                controller: newEmail,
                decoration: const InputDecoration(hintText: '請輸入欲更改的 Email 信箱地址'),
              ))
            ]),
          ),
        ],
      ),
    );
  }
}
