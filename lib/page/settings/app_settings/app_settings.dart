import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/app_lifecycle.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/mixins/color_picker_mixin.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/page/settings/app_settings/app_settings_view_model.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/providers/theme_provider.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({super.key});

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends BaseStatefulState<AppSettings>
    with ColorPickerMixin<AppSettings> {
  final viewModel = AppSettingsViewModel();
  late Future<void> init;
  Color? newSeedColor;

  void onResetThemePressed() {
    context.read<AppThemeProvider>().resetTheme();
  }

  void onFastQRPayChanged(bool value) async {
    log('onFastQRPayChanged: $value', name: 'AppSettings');
    if (viewModel.isEnabledFastQRPay == false) {
      enableFastQRPayDialog();
    } else {
      viewModel.setFastQRPay(false);
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
                viewModel.setFastQRPay(true);
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
                          prefixIcon: Icon(Icons.person_rounded))),
                  const SizedBox(height: 15),
                  TextField(
                      controller: password,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_rounded))),
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

  void onSummarizedRecordChanged(bool value) async {
    if (value == false) {
      viewModel.setSummarizedRecord(false);
      return;
    }
    final confirmChange = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.userAppSettingsSummarizedRecord),
          content: Text(i18n.userAppSettingsSummarizedRecordContent(
              "\n- ${i18n.userPlayLog}\n- ${i18n.userUTicLog}\n- ${i18n.userBidLog}")),
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
              child: Text(i18n.dialogConfirm),
            ),
          ],
        );
      },
    );
    if (confirmChange != true) return;
    viewModel.setSummarizedRecord(true);
  }

  Future<void> onInAppNfcScanChanged(bool value) async {
    if (value == false) {
      viewModel.setInAppNfcScan(false);
      return;
    }
    final confirmChange = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(i18n.userAppSettingsInAppNfc),
          content: Text(i18n.userAppSettingsInAppNfcContent),
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
              child: Text(i18n.dialogConfirm),
            ),
          ],
        );
      },
    );
    if (confirmChange != true) return;
    viewModel.setInAppNfcScan(value);
  }

  void onCEChanged(String ceText) async {
    final ceInterval = CardEmulationIntervals.values
        .firstWhere((element) => element.text == ceText);
    if (ceInterval == CardEmulationIntervals.disabled) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('警告'),
          content: const Text('停用卡片模擬將無法在使用APP時，用手機感應進門(如果有設定)，也無法使用手機感應機台'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(i18n.dialogConfirm),
            ),
          ],
        ),
      );
    }
    viewModel.setCEInterval(ceInterval);
  }

  void onChangeThemeBrightness(bool isDarkTheme) {
    viewModel.onChangeTheme(
      isDarkTheme: isDarkTheme,
      themeProvider: context.read<AppThemeProvider>(),
    );
  }

  @override
  void onColorChanged(Color color) {
    newSeedColor = color;
  }

  @override
  Color pickerColor() {
    return context.read<AppThemeProvider>().seedColor;
  }

  void onChangeAccentColorPressed() async {
    final appThemeProvider = context.read<AppThemeProvider>();
    await showColorPicker();
    if (newSeedColor == null) return;
    appThemeProvider.seedColor = newSeedColor!;
    Prefs.setInt(PrefsToken.seedColor, newSeedColor!.value);
  }

  @override
  void initState() {
    super.initState();
    AppLifeCycles.instance.onPaused();
    init = viewModel.getAppSettings();
  }

  @override
  void dispose() {
    AppLifeCycles.instance.reactivateNFC();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) => FutureBuilder(
          future: init,
          builder: (context, snapshot) {
            return PageDialog.ios(
              title: i18n.userInAppSetting,
              onConfirm: null,
              content: (showButtonBar) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: SizedBox());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(serviceErrorText));
                }

                return Consumer<AppSettingsViewModel>(
                  builder: (context, vm, child) {
                    return Column(
                      children: [
                        CupertinoListSection.insetGrouped(
                          children: [
                            FutureBuilder(
                                future: vm.isBiomerticsAvailable(),
                                initialData: false,
                                builder: (context, snapshot) {
                                  return CupertinoListTile.notched(
                                    title: Text(i18n.userAppSettingsBiometrics),
                                    trailing: CupertinoSwitch(
                                      activeColor: CupertinoColors.activeGreen,
                                      value: vm.isEnabledBiometricsLogin,
                                      onChanged: snapshot.data!
                                          ? onBiometricsLoginChanged
                                          : null,
                                    ),
                                  );
                                }),
                            CupertinoListTile.notched(
                              title: Text(i18n.userAppSettingsFastPayment),
                              trailing: CupertinoSwitch(
                                activeColor: CupertinoColors.activeGreen,
                                value: vm.isEnabledFastQRPay,
                                onChanged: onFastQRPayChanged,
                              ),
                            ),
                            // TODO (kenneth) : 等待0mu web 版寫完後開放
                            if (kDebugMode)
                              CupertinoListTile.notched(
                                title:
                                    Text(i18n.userAppSettingsSummarizedRecord),
                                trailing: CupertinoSwitch(
                                  activeColor: CupertinoColors.activeGreen,
                                  value: vm.isEnableSummarizedRecord,
                                  onChanged: onSummarizedRecordChanged,
                                ),
                              ),
                            CupertinoListTile.notched(
                              title: Text(i18n.userAppSettingsInAppNfc),
                              trailing: CupertinoSwitch(
                                activeColor: CupertinoColors.activeGreen,
                                value: vm.isEnableInAppNfcScan,
                                onChanged: onInAppNfcScanChanged,
                              ),
                            ),
                            if (vm.isSupportCE)
                              DialogDropdown.ios(
                                title:
                                    i18n.userAppSettingsCardEmulationInterval,
                                value: vm.ceInterval,
                                avaliList: CardEmulationIntervals.values
                                    .map((e) => e.text)
                                    .toList(),
                                onChanged: onCEChanged,
                              ),
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          children: [
                            CupertinoListTile.notched(
                              title: Text(i18n.userAppSettingsAccentColor),
                              onTap: onChangeAccentColorPressed,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: context
                                            .read<AppThemeProvider>()
                                            .seedColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: borderColor,
                                          width: 1,
                                        ),
                                      )),
                                  const SizedBox(width: 10),
                                  const CupertinoListTileChevron(),
                                ],
                              ),
                            ),
                            CupertinoListTile.notched(
                              title: Text(i18n.userAppSettingsEnableDarkTheme),
                              trailing: CupertinoSwitch(
                                activeColor: CupertinoColors.activeGreen,
                                value: isDarkTheme,
                                onChanged: onChangeThemeBrightness,
                              ),
                            ),
                            CupertinoListTile.notched(
                              title: Text(
                                i18n.userAppSettingsResetTheme,
                                style: const TextStyle(
                                    color: CupertinoColors.systemBlue),
                              ),
                              onTap: onResetThemePressed,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }),
    );
  }
}
