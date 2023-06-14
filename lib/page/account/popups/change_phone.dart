part of '../account.dart';

class ChangePhoneDialog extends StatefulWidget {
  final AccountViewModel viewModel;
  final Function(bool) callback;
  const ChangePhoneDialog(this.viewModel, {Key? key, required this.callback}) : super(key: key);

  @override
  State<ChangePhoneDialog> createState() => _ChangePhoneDialogState();
}

class _ChangePhoneDialogState extends State<ChangePhoneDialog> {
  late AccountViewModel model;
  final newEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 15),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error, size: 50, color: Color(0xfffafafa)),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                    text: const TextSpan(text: '此選項會', style: TextStyle(fontSize: 16), children: [
                  TextSpan(text: "解除您的帳戶的手機綁定", style: TextStyle(color: Color(0xfffad814))),
                  TextSpan(text: '，並且讓原先的手機號碼可以被再次使用')
                ])),
                const Text('且您的帳戶會變成尚未簡訊驗證的狀況，直到您驗證完新的電話號碼。'),
                const SizedBox(height: 20),
                const Text('您確定要取消手機綁定並重新驗證？',
                    style: TextStyle(color: Color(0xfffad814), fontWeight: FontWeight.bold)),
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
                        widget.callback(await model.detachPhone());
                      },
                      style: Themes.severe(isV4: true),
                      child: const Text('確認')),
                ),
              ],
            ),
          ),
        ],
      ),
      // actionsAlignment: MainAxisAlignment.spaceBetween,
      // actions:,
    );
  }
}

class _ChangePhoneConfirmedDialog extends StatefulWidget {
  final BuildContext context;
  final AccountViewModel viewModel;

  const _ChangePhoneConfirmedDialog(this.viewModel, this.context, {Key? key}) : super(key: key);

  @override
  State<_ChangePhoneConfirmedDialog> createState() => _ChangePhoneConfirmedDialogState();
}

class _ChangePhoneConfirmedDialogState extends State<_ChangePhoneConfirmedDialog> {
  final textController = TextEditingController();
  String? _errorText;
  bool isEnteredNewPhone = false;

  @override
  void initState() {
    super.initState();
  }

  void _doChangePhone() async {
    final nav = Navigator.of(context);
    final model = widget.viewModel;
    if (await model.doChangePhone(phone: textController.text)) {
      switch (model.response!.code) {
        case 200:
          scaffoldKey.currentState!.showSnackBar(const SnackBar(content: Text('資料已送出，等候簡訊驗證')));
          isEnteredNewPhone = true;
          textController.clear();
          setState(() {});
          break;
        default:
          await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50', duration: const Duration(seconds: 2));
          await Future.delayed(const Duration(seconds: 2));
          nav.pop();
      }
    }
  }

  void _smsActivate() async {
    final model = widget.viewModel;
    final nav = Navigator.of(context);
    if (await model.smsActivate(smsCode: textController.text)) {
      switch (model.response!.code) {
        case 200:
          await EasyLoading.showSuccess('簡訊驗證成功！', duration: const Duration(seconds: 2));
          await Future.delayed(const Duration(seconds: 2));
          nav.pop();
          break;
        case 700:
          await EasyLoading.showError('驗證碼輸入錯誤，請檢查', duration: const Duration(seconds: 2));
          break;
        default:
          await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50', duration: const Duration(seconds: 2));
          await Future.delayed(const Duration(seconds: 2));
          nav.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Dialog(
      onConfirm: () async {
        if (isEnteredNewPhone) {
          _smsActivate();
        } else {
          bool isCorrectPhone = RegExp("^09\\d{2}-?\\d{3}-?\\d{3}\$").hasMatch(textController.text);
          if (!isCorrectPhone) {
            _errorText = '手機號碼格式錯誤';
            setState(() {});
          } else {
            _errorText = null;
            FocusManager.instance.primaryFocus?.unfocus();
            _doChangePhone();
          }
        }
      },
      content: _DialogBody(
        title: '更改手機',
        children: [
          const Text('請注意！只能發送一次簡訊驗證碼。若手機號碼輸入錯誤或30分鐘仍未收到請聯絡粉絲專頁',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _DialogWidget(
            titleIcon: isEnteredNewPhone ? Icons.email : Icons.phone,
            title: isEnteredNewPhone ? '請輸入您的簡訊認證碼' : '請欲更改的手機號碼',
            isRequired: true,
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                maxLength: isEnteredNewPhone ? 6 : null,
                buildCounter: (context, {currentLength = 0, isFocused = true, maxLength}) => null,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                controller: textController,
                decoration: InputDecoration(hintText: isEnteredNewPhone ? '六位數字' : '送出後，我們將會寄送簡訊驗證'),
              ))
            ]),
          ),
          _errorText != null
              ? Text(_errorText!, style: const TextStyle(color: Colors.red))
              : const SizedBox(),
        ],
      ),
    );
  }
}
