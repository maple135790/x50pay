import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account_view_model.dart';

class ChangePhoneDialog extends StatefulWidget {
  final AccountViewModel viewModel;
  final Function(bool) callback;
  const ChangePhoneDialog(this.viewModel, {Key? key, required this.callback})
      : super(key: key);

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
                    text: const TextSpan(
                        text: '此選項會',
                        style: TextStyle(fontSize: 16),
                        children: [
                      TextSpan(
                          text: "解除您的帳戶的手機綁定",
                          style: TextStyle(color: Color(0xfffad814))),
                      TextSpan(text: '，並且讓原先的手機號碼可以被再次使用')
                    ])),
                const Text('且您的帳戶會變成尚未簡訊驗證的狀況，直到您驗證完新的電話號碼。'),
                const SizedBox(height: 20),
                const Text('您確定要取消手機綁定並重新驗證？',
                    style: TextStyle(
                        color: Color(0xfffad814), fontWeight: FontWeight.bold)),
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
                        final isDetached = await model.detachPhone();
                        log('isDetached: $isDetached',
                            name: 'ChangePhoneDialog');
                        widget.callback(isDetached);
                      },
                      style: Themes.severe(isV4: true),
                      child: const Text('確認')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangePhoneConfirmedDialog extends StatefulWidget {
  final BuildContext context;
  final AccountViewModel viewModel;

  const ChangePhoneConfirmedDialog(this.viewModel, this.context, {Key? key})
      : super(key: key);

  @override
  State<ChangePhoneConfirmedDialog> createState() =>
      _ChangePhoneConfirmedDialogState();
}

class _ChangePhoneConfirmedDialogState
    extends BaseStatefulState<ChangePhoneConfirmedDialog> {
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
    final gotResponse = await model.doChangePhone(phone: textController.text);
    if (gotResponse) {
      switch (model.response!.code) {
        case 200:
          EasyLoading.showSuccess('資料已送出，等候簡訊驗證');
          isEnteredNewPhone = true;
          textController.clear();
          setState(() {});
          break;
        default:
          showServiceError();
          await Future.delayed(const Duration(milliseconds: 2300));
          nav.pop();
      }
    } else {
      showServiceError();
      await Future.delayed(const Duration(milliseconds: 2300));
      nav.pop();
    }
  }

  void _smsActivate() async {
    final model = widget.viewModel;
    final nav = Navigator.of(context);

    final gotResponse = await model.smsActivate(smsCode: textController.text);
    if (gotResponse) {
      switch (model.response!.code) {
        case 200:
          await EasyLoading.showSuccess('簡訊驗證成功！',
              duration: const Duration(seconds: 2));
          await Future.delayed(const Duration(seconds: 2));
          nav.pop();
          break;
        case 700:
          await EasyLoading.showError('驗證碼輸入錯誤，請檢查',
              duration: const Duration(seconds: 2));
          break;
        default:
          showServiceError();
          await Future.delayed(const Duration(milliseconds: 2300));
          nav.pop();
      }
    } else {
      showServiceError();
      await Future.delayed(const Duration(milliseconds: 2300));
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _Dialog(
        onConfirm: () async {
          if (isEnteredNewPhone) {
            FocusManager.instance.primaryFocus?.unfocus();
            _smsActivate();
          } else {
            bool isCorrectPhone = RegExp("^09\\d{2}-?\\d{3}-?\\d{3}\$")
                .hasMatch(textController.text);
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
        content: (showButtonBar) => _DialogBody(
              title: '更改手機',
              children: [
                const Text('請注意！只能發送一次簡訊驗證碼。若手機號碼輸入錯誤或30分鐘仍未收到請聯絡粉絲專頁',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                _DialogWidget(
                  titleIcon: isEnteredNewPhone ? Icons.email : Icons.phone,
                  title: isEnteredNewPhone ? '請輸入您的簡訊認證碼' : '請欲更改的手機號碼',
                  isRequired: true,
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      maxLength: isEnteredNewPhone ? 6 : null,
                      buildCounter: (context,
                              {currentLength = 0,
                              isFocused = true,
                              maxLength}) =>
                          null,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.phone,
                      controller: textController,
                      decoration: InputDecoration(
                          hintText:
                              isEnteredNewPhone ? '六位數字' : '送出後，我們將會寄送簡訊驗證'),
                    ))
                  ]),
                ),
                _errorText != null
                    ? Text(_errorText!,
                        style: const TextStyle(color: Colors.red))
                    : const SizedBox(),
              ],
            ));
  }
}

class _Dialog extends StatefulWidget {
  final Widget Function(void Function(bool isShow) showButtonBar) content;
  final bool scrollable;
  final void Function()? onConfirm;
  final Widget? customConfirmButton;
  final String title;

  const _Dialog({
    required this.content,
    required this.onConfirm,
  })  : customConfirmButton = null,
        scrollable = false,
        title = '';

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  static const _kMaxBottomSheetHeight = 80.0;
  ValueNotifier<Offset> offsetNotifier =
      ValueNotifier(const Offset(0, _kMaxBottomSheetHeight));

  void showButtonBar(bool isShow) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (isShow) {
      offsetNotifier.value = Offset.zero;
    } else {
      offsetNotifier.value = const Offset(0, 1);
    }
  }

  final buttonStyle = ButtonStyle(
    shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
    backgroundColor: MaterialStateColor.resolveWith((states) {
      if (states.isDisabled) return const Color(0xfffafafa).withOpacity(0.5);
      return const Color(0xfffafafa);
    }),
  );
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: widget.scrollable,
      contentPadding:
          const EdgeInsets.only(top: 28, left: 28, right: 28, bottom: 14),
      actionsPadding:
          const EdgeInsets.only(top: 0, left: 28, right: 28, bottom: 28),
      content: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: widget.content.call(showButtonBar),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: Themes.pale(),
            child: const Text('取消')),
        widget.customConfirmButton == null
            ? TextButton(
                onPressed: widget.onConfirm,
                style: Themes.severe(isV4: true),
                child: const Text('保存'))
            : widget.customConfirmButton!
      ],
    );
  }
}

class _DialogBody extends StatelessWidget {
  final List<Widget> children;
  final String title;
  const _DialogBody({Key? key, required this.children, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: const TextStyle(color: Color(0xff5a5a5a)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(title,
                  style:
                      const TextStyle(color: Color(0xffbfbfbf), fontSize: 12))),
          const SizedBox(height: 30),
          ...children,
        ]));
  }
}

class _DialogWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final IconData? titleIcon;
  final bool isRequired;
  const _DialogWidget(
      {required this.title,
      required this.child,
      this.isRequired = false,
      this.titleIcon});

  @override
  State<_DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<_DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
                text: TextSpan(
              style: const TextStyle(color: Color(0xfffafafa)),
              children: widget.isRequired
                  ? [
                      widget.titleIcon == null
                          ? const WidgetSpan(child: SizedBox())
                          : WidgetSpan(
                              child: Icon(widget.titleIcon!,
                                  color: const Color(0xff5a5a5a), size: 18)),
                      TextSpan(text: widget.title),
                      const TextSpan(
                          text: ' *', style: TextStyle(color: Colors.red))
                    ]
                  : [
                      widget.titleIcon == null
                          ? const WidgetSpan(child: SizedBox())
                          : WidgetSpan(
                              child: Icon(widget.titleIcon!,
                                  color: const Color(0xff5a5a5a))),
                      TextSpan(text: widget.title)
                    ],
            ))),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffd9d9d9)),
              borderRadius: BorderRadius.circular(5)),
          child: widget.child,
        ),
        const SizedBox(height: 22.4),
      ],
    );
  }
}
