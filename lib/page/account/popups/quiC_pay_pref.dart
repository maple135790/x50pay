import 'package:flutter/cupertino.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/account/popups/popup_dialog.dart';

class QuiCPayPrefDialog extends StatefulWidget {
  final AccountViewModel viewModel;

  const QuiCPayPrefDialog(this.viewModel, {Key? key}) : super(key: key);

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

  void sendQuicConfirm() {
    widget.viewModel.quicConfirm(
      autoQlock: nfcQlock,
      autoQuic: isQuiCPayEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AccountDialog.ios(
      title: 'QuiC 快速付款偏好設定',
      onConfirm: sendQuicConfirm,
      content: (showButtonBar) => FutureBuilder(
          future: widget.viewModel.getQuicSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox();
            }
            if (snapshot.data != true) {
              return const Center(child: Text('failed'));
            }
            showButtonBar(true);

            final model = widget.viewModel.quicSettingModel!;
            isQuiCPayEnabled = model.nfcQuic;
            nfcQlock = model.nfcQlock.toString();

            return CupertinoListSection.insetGrouped(
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
            );
          }),
    );
  }
}
