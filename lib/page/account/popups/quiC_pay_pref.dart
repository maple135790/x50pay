part of '../account.dart';

class QuiCPayPrefDialog extends StatelessWidget {
  final AccountViewModel viewModel;

  const QuiCPayPrefDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Dialog(
      scrollable: true,
      saveCallback: () {},
      content: FutureBuilder(
          future: viewModel.getQuicSettings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: Text('loading'));
            }
            if (snapshot.data != true) {
              return const Center(child: Text('failed'));
            } else {
              final model = viewModel.quicSettingModel!;
              Map<int, String> intervalMap = {
                15: "15秒",
                30: "30秒",
                60: "60秒",
                300: "5分鐘",
                600: "10分鐘",
                0: "不限制"
              };
              bool isQuiCPayEnabled = model.nfcQuic;
              int nfcQlock = model.nfcQlock;

              return _DialogBody(
                title: 'QuiC 快速付款偏好設定',
                children: [
                  _DialogSwitch(value: isQuiCPayEnabled, title: '啟用 QuiC 靠卡扣款'),
                  const SizedBox(height: 22.4),
                  _DialogDropdown(
                      title: 'QuiC 刷卡間隔鎖',
                      value: intervalMap[nfcQlock],
                      avaliList: intervalMap.values.toList())
                ],
              );
            }
          }),
    );
  }
}
