import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/page/settings/app_settings/app_settings_view_model.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends BaseStatefulState<AppSettings> {
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
          title: Text(i18n.userAppSettingsFastPaymentEnableTitle),
          content: Text(i18n.userAppSettingsFastPaymentEnableContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(i18n.dialogCancel),
            ),
            TextButton(
              onPressed: () {
                viewModel.enableFastQRPay();
                Navigator.of(context).pop();
              },
              child: Text(i18n.dialogConfirm),
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
          title: Text(i18n.userAppSettingsBiometricsDisable),
          content: Text(i18n.userAppSettingsBiometricsDisableContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(i18n.dialogCancel),
            ),
            TextButton(
              onPressed: () {
                viewModel.disableBiometricsLogin();
                Navigator.of(context).pop();
              },
              child: Text(i18n.dialogConfirm),
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
            title: Text(i18n.userAppSettingsBiometricsLoginCred),
            content: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(i18n.userAppSettingsBiometricsLoginCredContent),
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
                      controller: email,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.username],
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person))),
                  const SizedBox(height: 15),
                  TextField(
                      controller: password,
                      textInputAction: TextInputAction.done,
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
                child: Text(i18n.dialogCancel),
              ),
              TextButton(
                onPressed: () {
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
                child: Text(i18n.userAppSettingsBiometricsLoginTry),
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
          title: Text(i18n.userAppSettingsBiometrics),
          content: Text(i18n.userAppSettingsBiometricsEnableContent),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(i18n.dialogCancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(i18n.dialogNext),
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
              title: i18n.userInAppSetting,
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
                              title: Text(i18n.userAppSettingsBiometrics),
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
                        title: Text(i18n.userAppSettingsFastPayment),
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
