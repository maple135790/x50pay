import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState
    extends BaseStatefulState<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final oldPwd = TextEditingController();
  final newPwd = TextEditingController();
  final renewPwd = TextEditingController();
  String? _errorText;
  String buttonText = '請輸入密碼';
  bool isEnabled = false;

  Widget confirmButton(SettingsViewModel viewModel) {
    return TextButton(
      style: buttonStyle,
      onPressed: isEnabled
          ? () async {
              final nav = GoRouter.of(context);
              if (await viewModel.changePassword(
                  oldPwd: oldPwd.text, pwd: newPwd.text, debugFlag: 200)) {
                switch (viewModel.response!.code) {
                  case 200:
                    _errorText = null;
                    await EasyLoading.showSuccess('密碼變更成功，請重新登入',
                        dismissOnTap: false,
                        duration: const Duration(seconds: 2));
                    await Future.delayed(const Duration(seconds: 2));
                    await EasyLoading.show(dismissOnTap: false);
                    nav.goNamed(AppRoutes.login.routeName);
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
                    showServiceError();
                }
              } else {
                showServiceError();
              }
            }
          : null,
      child: Text(buttonText, style: const TextStyle(color: Color(0xff1e1e1e))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, viewModel, child) => PageDialog.ios(
          title: '密碼變更',
          customConfirmButton: confirmButton(viewModel),
          content: (showButtonBar) {
            showButtonBar(true);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
                child: CupertinoFormSection.insetGrouped(
                  footer: Text(_errorText ?? '',
                      style: const TextStyle(
                          color: CupertinoColors.destructiveRed)),
                  key: _formKey,
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: oldPwd,
                      prefix: const Text('您的舊密碼'),
                      placeholder: '請輸入舊的密碼以確認身分',
                      obscureText: true,
                    ),
                    CupertinoTextFormFieldRow(
                      controller: newPwd,
                      prefix: const Text('新密碼'),
                      placeholder: '請輸入密碼',
                      obscureText: true,
                      onChanged: (s) {
                        if (s.isEmpty) {
                          setState(() {
                            buttonText = '請輸入密碼';
                            isEnabled = false;
                          });
                        } else if (s != renewPwd.text) {
                          setState(() {
                            buttonText = '兩次輸入的密碼不同';
                            isEnabled = false;
                          });
                        } else {
                          setState(() {
                            buttonText = '送出';
                            isEnabled = true;
                          });
                        }
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: renewPwd,
                      prefix: const Text('再次輸入一次'),
                      placeholder: '請重複輸入密碼',
                      obscureText: true,
                      onChanged: (s) {
                        if (s.isEmpty) {
                          setState(() {
                            buttonText = '請輸入密碼';
                            isEnabled = false;
                          });
                        } else if (s != newPwd.text) {
                          setState(() {
                            buttonText = '兩次輸入的密碼不同';
                            isEnabled = false;
                          });
                        } else {
                          setState(() {
                            buttonText = '送出';
                            isEnabled = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
