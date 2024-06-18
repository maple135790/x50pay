import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/settings/popups/change_phone_view_model.dart';
import 'package:x50pay/repository/setting_repository.dart';

class ChangePhoneDialog extends StatefulWidget {
  final void Function(bool isRemoved) onPhoneRemoved;

  const ChangePhoneDialog({
    super.key,
    required this.onPhoneRemoved,
  });

  @override
  State<ChangePhoneDialog> createState() => _ChangePhoneDialogState();
}

class _ChangePhoneDialogState extends BaseStatefulState<ChangePhoneDialog> {
  late final ChangePhoneViewModel viewModel;
  final newEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settingRepo = SettingRepository();
    viewModel = ChangePhoneViewModel(settingRepo);
  }

  void onRemovePhonePressed() async {
    if (!kReleaseMode) {
      widget.onPhoneRemoved(true);
      log('dev onRemovePhone: true', name: 'ChangePhoneDialog');
      return;
    }
    final isRemoved = await viewModel.removePhone();
    log('onRemovePhone: $isRemoved', name: 'ChangePhoneDialog');
    widget.onPhoneRemoved(isRemoved);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          scrollable: true,
          contentPadding: const EdgeInsets.only(top: 15),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, size: 50),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      TextSpan(
                        text: '此選項會',
                        children: [
                          TextSpan(
                            text: "解除您的帳戶的手機綁定",
                            style: TextStyle(color: Color(0xFFEAC912)),
                          ),
                          TextSpan(text: '，並且讓原先的手機號碼可以被再次使用')
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('且您的帳戶會變成尚未簡訊驗證的狀況，直到您驗證完新的電話號碼。'),
                    SizedBox(height: 20),
                    Text(
                      '您確定要取消手機綁定並重新驗證？',
                      style: TextStyle(
                        color: Color(0xFFEAC912),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, height: 0),
              Container(
                color: dialogButtomBarColor,
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style:
                            CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                        child: const Text('取消'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextButton(
                        onPressed: onRemovePhonePressed,
                        style: CustomButtonThemes.severe(isV4: true),
                        child: const Text('確認'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChangePhoneConfirmedDialog extends StatefulWidget {
  const ChangePhoneConfirmedDialog({super.key});

  @override
  State<ChangePhoneConfirmedDialog> createState() =>
      _ChangePhoneConfirmedDialogState();
}

class _ChangePhoneConfirmedDialogState
    extends BaseStatefulState<ChangePhoneConfirmedDialog> {
  final textController = TextEditingController();
  late final ChangePhoneViewModel viewModel;

  @override
  void initState() {
    super.initState();
    final settingRepo = SettingRepository();
    viewModel = ChangePhoneViewModel(settingRepo);
  }

  void changePhone() async {
    final isValidPhone = viewModel.checkPhoneFormat(textController.text);
    if (!isValidPhone) return;

    final nav = Navigator.of(context);

    await viewModel.changePhone(
      phone: textController.text,
      onChangeFailed: () async {
        showServiceError();
        await Future.delayed(const Duration(milliseconds: 2300));
        nav.pop();
      },
      onChangeSuccess: () {
        EasyLoading.showSuccess('資料已送出，等候簡訊驗證');
        textController.clear();
      },
    );
  }

  void smsActivate() async {
    final nav = Navigator.of(context);

    await viewModel.smsActivate(
      smsCode: textController.text,
      onActivateFailed: () async {
        showServiceError();
        await Future.delayed(const Duration(milliseconds: 2300));
        nav.pop();
      },
      onActivateSuccess: () {
        nav.pop();
      },
    );
  }

  Widget? noCounterBuilder(
    BuildContext context, {
    required int currentLength,
    required int? maxLength,
    required bool isFocused,
  }) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return Selector<ChangePhoneViewModel, bool>(
          selector: (context, vm) => vm.isSentSmsCode,
          builder: (context, isSentSmsCode, child) {
            late VoidCallback onConfirmPressed;
            late IconData textFieldIcon;
            late String textFieldName;
            late String hintText;
            late int? textmaxLength;

            if (isSentSmsCode) {
              onConfirmPressed = smsActivate;
              textFieldIcon = Icons.email_rounded;
              textFieldName = '請輸入您的簡訊認證碼';
              textmaxLength = 6;
              hintText = '六位數字';
            } else {
              onConfirmPressed = changePhone;
              textFieldIcon = Icons.phone_rounded;
              textFieldName = '請欲更改的手機號碼';
              textmaxLength = 10;
              hintText = '送出後，我們將會寄送簡訊驗證';
            }

            return _Dialog(
              onConfirm: onConfirmPressed,
              content: _DialogBody(
                title: '更改手機',
                children: [
                  const Text(
                    '請注意！只能發送一次簡訊驗證碼。若手機號碼輸入錯誤或30分鐘仍未收到請聯絡粉絲專頁',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _DialogWidget(
                    icon: textFieldIcon,
                    name: textFieldName,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: textmaxLength,
                            buildCounter: noCounterBuilder,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            controller: textController,
                            decoration: InputDecoration(hintText: hintText),
                          ),
                        )
                      ],
                    ),
                  ),
                  Selector<ChangePhoneViewModel, String>(
                    selector: (context, vm) => vm.errorText ?? '',
                    builder: (context, errorText, child) {
                      return Text(
                        errorText,
                        style: const TextStyle(color: Colors.red),
                      );
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Dialog extends StatefulWidget {
  final Widget content;
  final VoidCallback onConfirm;

  const _Dialog({
    required this.content,
    required this.onConfirm,
  });

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends BaseStatefulState<_Dialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(28, 28, 28, 14),
      actionsPadding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
      content: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: widget.content,
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: () {
            primaryFocus?.unfocus();
            widget.onConfirm.call();
          },
          style: CustomButtonThemes.severe(isV4: true),
          child: const Text('保存'),
        )
      ],
    );
  }
}

class _DialogBody extends StatelessWidget {
  final List<Widget> children;
  final String title;
  const _DialogBody({required this.children, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 30),
        ...children,
      ],
    );
  }
}

class _DialogWidget extends StatefulWidget {
  final String name;
  final Widget child;
  final IconData icon;

  const _DialogWidget({
    required this.name,
    required this.child,
    required this.icon,
  });

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
          child: Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    widget.icon,
                    size: 18,
                  ),
                ),
                const WidgetSpan(child: SizedBox(width: 5)),
                TextSpan(text: widget.name),
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
          child: widget.child,
        ),
        const SizedBox(height: 22.4),
      ],
    );
  }
}
