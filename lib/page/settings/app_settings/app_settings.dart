import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/page/settings/app_settings/app_settings_view_model.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final focus = FocusNode();
  final viewModel = AppSettingsViewModel();

  void onFastQRPayChanged(bool value) async {
    if (viewModel.isEnabledFastQRPay == false) {
      enableFastQRPayDialog();
    } else {
      viewModel.disableFastQRPay();
    }
  }

  void onBiometricsLoginChanged(bool value) async {
    if (viewModel.isEnabledBiometricsLogin == false) {
      final useBiometrics = await enableBiometricsDialog() ?? false;
      if (!useBiometrics) return;
      await reloginDialog();
    } else {
      disableBiometricsDialog();
    }
  }

  void enableFastQRPayDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('開啟快速支付流程'),
          content: const Text('''
快速支付流程有別於網頁版的支付流程，投幣時不會做 Token 驗證

確定開啟快速支付流程？'''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                viewModel.enableFastQRPay();
                Navigator.of(context).pop();
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  void disableBiometricsDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('取消生物辨識登入'),
          content: const Text('''
確定要取消生物辨識登入嗎？
再次開啟需要重新輸入登入資訊'''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                viewModel.disableBiometricsLogin();
                Navigator.of(context).pop();
              },
              child: const Text('確定'),
            ),
          ],
        );
      },
    );
  }

  Future<void> reloginDialog() async {
    final email = TextEditingController();
    final password = TextEditingController();
    final loginViewModel = LoginViewModel();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: loginViewModel,
          child: AlertDialog(
            title: const Text('登入資訊'),
            content: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('再次輸入帳號密碼'),
                  const SizedBox(height: 15),
                  Consumer<LoginViewModel>(
                    builder: (context, vm, child) => Visibility(
                      visible: vm.errorMsg != null,
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: Colors.red),
                          const SizedBox(width: 5),
                          Text(
                            vm.errorMsg ?? '',
                            style: const TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                      focusNode: focus,
                      controller: email,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person))),
                  const SizedBox(height: 15),
                  TextField(
                      controller: password,
                      focusNode: focus,
                      textInputAction: TextInputAction.send,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      decoration:
                          const InputDecoration(prefixIcon: Icon(Icons.lock))),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  loginViewModel.login(
                    email: email.text,
                    password: password.text,
                    isShowSuccessLogin: false,
                    onLoginSuccess: () {
                      Navigator.of(context).pop();
                      viewModel.enableBiometricsLogin(
                          email.text, password.text);
                    },
                  );
                },
                child: const Text('嘗試登入'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> enableBiometricsDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('生物辨識登入'),
          content: const Text('''注意:
此功能會將您的帳號密碼加密儲存於手機中，用生物辨識登入時會自動填入帳號密碼。

Android 使用 KeyStore 儲存
iOS 使用 KeyChain 儲存。

如果帳號密碼有更換，需要再次重新設定。

確定使用此功能嗎？'''),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('下一步'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) => FutureBuilder(
          future: viewModel.getAppSettings(),
          builder: (context, snapshot) {
            return PageDialog.ios(
              title: 'X50Pay App 設定',
              onConfirm: null,
              content: (showButtonBar) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                return CupertinoListSection.insetGrouped(
                  children: [
                    Consumer<AppSettingsViewModel>(
                      builder: (context, vm, child) => FutureBuilder(
                          future: vm.isBiomerticsAvailable(),
                          initialData: false,
                          builder: (context, snapshot) {
                            return CupertinoListTile.notched(
                              title: const Text('生物辨識登入'),
                              trailing: CupertinoSwitch(
                                activeColor: const Color(0xff005eb0),
                                value: vm.isEnabledBiometricsLogin,
                                onChanged: snapshot.data!
                                    ? onBiometricsLoginChanged
                                    : null,
                              ),
                            );
                          }),
                    ),
                    Consumer<AppSettingsViewModel>(
                        builder: (context, vm, child) {
                      return CupertinoListTile.notched(
                        title: const Text('快速支付流程'),
                        trailing: CupertinoSwitch(
                          activeColor: const Color(0xff005eb0),
                          value: vm.isEnabledFastQRPay,
                          onChanged: onFastQRPayChanged,
                        ),
                      );
                    }),
                  ],
                );
              },
            );
          }),
    );
  }
}
