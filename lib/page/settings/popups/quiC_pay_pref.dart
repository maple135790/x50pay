import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/page/settings/popups/popup_dialog.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';

class QuiCPayPrefDialog extends StatefulWidget {
  const QuiCPayPrefDialog({super.key});

  @override
  State<QuiCPayPrefDialog> createState() => _QuiCPayPrefDialogState();
}

class _QuiCPayPrefDialogState extends State<QuiCPayPrefDialog> {
  late bool isQuiCPayEnabled;
  late String nfcQlock;
  final intervalMap = {
    "15": "15秒",
    "30": "30秒",
    "60": "60秒",
    "300": "5分鐘",
    "600": "10分鐘",
    "0": "不限制"
  };

  void sendQuicConfirm(SettingsViewModel viewModel) async {
    final isSuccess = await viewModel.quicConfirm(
      autoQlock: nfcQlock,
      autoQuic: isQuiCPayEnabled,
    );
    log('isSuccess: $isSuccess', name: 'sendQuicConfirm');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, vm, child) {
        return PageDialog.ios(
          title: 'QuiC 快速付款偏好設定',
          onConfirm: () {
            sendQuicConfirm(vm);
          },
          content: (showButtonBar) => FutureBuilder(
              future: vm.getPaymentSettings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox();
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('failed'));
                }
                showButtonBar(true);

                final model = snapshot.data!;
                isQuiCPayEnabled = model.nfcQuic;
                nfcQlock = model.nfcQlock.toString();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoListSection.insetGrouped(
                      children: [
                        DialogSwitch.ios(
                          value: isQuiCPayEnabled,
                          title: '啟用 QuiC 靠卡扣款',
                          onChanged: (value) {
                            isQuiCPayEnabled = value;
                          },
                        ),
                        DialogDropdown.ios(
                          title: 'QuiC 刷卡間隔鎖',
                          value: intervalMap[nfcQlock],
                          avaliList: intervalMap.values.toList(),
                          onChanged: (value) {
                            nfcQlock = intervalMap.keys
                                .firstWhere((key) => intervalMap[key] == value);
                          },
                        )
                      ],
                    ),
                    // CupertinoListSection.insetGrouped(
                    //   header: const Text('已綁定卡片管理'),
                    //   children: const [
                    //     CupertinoListTile(
                    //       title: Text('title'),
                    //       additionalInfo: Text('additionalInfo'),
                    //       subtitle: Text('subtitle'),
                    //     ),
                    //   ],
                    // ),
                  ],
                );
              }),
        );
      },
    );
  }
}
