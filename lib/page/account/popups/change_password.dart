part of '../account.dart';

class ChangePasswordDialog extends StatefulWidget {
  final AccountViewModel viewModel;
  const ChangePasswordDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  late AccountViewModel model;
  String? _errorText;
  String buttonText = '請輸入密碼';
  bool isEnabled = false;
  final oldPwd = TextEditingController();
  final newPwd = TextEditingController();
  final renewPwd = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return _Dialog(
      saveCallback: () {},
      customSaveButton: TextButton(
        style: Themes.confirm(),
        onPressed: isEnabled
            ? () async {
                final nav = Navigator.of(context);
                if (await model.changePassword(oldPwd: oldPwd.text, pwd: newPwd.text, debugFlag: 200)) {
                  switch (model.response!.code) {
                    case 200:
                      _errorText = null;
                      await EasyLoading.showSuccess('密碼變更成功，請重新登入',
                          dismissOnTap: false, duration: const Duration(seconds: 2));
                      await Future.delayed(const Duration(seconds: 2));
                      await EasyLoading.show(dismissOnTap: false);
                      nav.pushNamedAndRemoveUntil(AppRoute.login, (route) => false);
                      break;
                    case 700:
                      setState(() {
                        _errorText = '新密碼與舊密碼相同';
                      });
                      break;
                    case 701:
                      setState(() {
                        _errorText = '舊密碼輸入錯誤';
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
            : null,
        child: Text(buttonText),
      ),
      content: Form(
        key: _formKey,
        child: _DialogBody(
          title: '密碼變更',
          children: [
            RichText(text: TextSpan(text: _errorText, style: const TextStyle(color: Colors.red))),
            _DialogWidget(
              title: '您的舊密碼',
              isRequired: true,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  obscureText: true,
                  controller: oldPwd,
                  decoration: const InputDecoration(hintText: '請輸入舊的密碼以確認身分'),
                ))
              ]),
            ),
            _DialogWidget(
              title: '新密碼',
              isRequired: true,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  obscureText: true,
                  controller: newPwd,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(hintText: '請輸入密碼'),
                  onChanged: (s) {
                    if (s.isEmpty) {
                      setState(() {
                        buttonText = '請輸入密碼';
                        isEnabled = false;
                      });
                    } else if (s != renewPwd.text) {
                      setState(() {
                        buttonText = '兩次不同';
                        isEnabled = false;
                      });
                    } else {
                      setState(() {
                        buttonText = '送出';
                        isEnabled = true;
                      });
                    }
                  },
                ))
              ]),
            ),
            _DialogWidget(
              title: '重複輸入新密碼',
              isRequired: true,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: renewPwd,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: '請重複輸入密碼'),
                  onChanged: (s) {
                    if (s.isEmpty) {
                      setState(() {
                        buttonText = '請輸入密碼';
                        isEnabled = false;
                      });
                    } else if (s != newPwd.text) {
                      setState(() {
                        buttonText = '兩次不同';
                        isEnabled = false;
                      });
                    } else {
                      setState(() {
                        buttonText = '送出';
                        isEnabled = true;
                      });
                    }
                  },
                ))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
