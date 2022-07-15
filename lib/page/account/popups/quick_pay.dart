part of '../account.dart';

class QuickPayDialog extends StatelessWidget {
  final AccountViewModel viewModel;
  const QuickPayDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NVSVPayment? _toNVSVPayment(String str) {
      switch (str) {
        case '0':
          return NVSVPayment.light;
        case '1':
          return NVSVPayment.standard;
        case '2':
          return NVSVPayment.blaster;
        default:
          return null;
      }
    }

    SDVXPayment? _toSDVXPayment(String str) {
      switch (str) {
        case '0':
          return SDVXPayment.standard;
        case '1':
          return SDVXPayment.blaster;
        default:
          return null;
      }
    }

    DPPayment? _toDPPayment(String str) {
      switch (str) {
        case '0':
          return DPPayment.single;
        case '1':
          return DPPayment.double;
        default:
          return null;
      }
    }

    return _Dialog(
      scrollable: true,
      saveCallback: () {},
      content: FutureBuilder<bool>(
        future: viewModel.getQuicSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Text('loading'));
          }
          if (snapshot.data != true) {
            return const Center(child: Text('failed'));
          } else {
            final model = viewModel.quicSettingModel!;
            bool isNfcAutoPayEnabled = model.nfcAuto;
            bool isQuiCPayEnabled = model.nfcQuic;
            bool isUseTicketEnabled = model.nfcTicket;
            NVSVPayment? nvsvP = _toNVSVPayment(model.nfcNVSV);
            SDVXPayment? sdvxP = _toSDVXPayment(model.nfcSDVX);
            DPPayment? dpP = _toDPPayment(model.nfcTwo);

            return _DialogBody(
              title: '快速付款偏好選項',
              children: [
                _DialogSwitch(value: isQuiCPayEnabled, title: '啟用 QuiC 靠卡扣款'),
                _DialogSwitch(value: isNfcAutoPayEnabled, title: '啟用 NFC 自動扣款'),
                _DialogSwitch(value: isUseTicketEnabled, title: '啟用預設扣券'),
                const SizedBox(height: 22.4),
                _DialogDropdown(title: '女武神預設扣款模式 ? ', value: nvsvP, avaliList: NVSVPayment.values),
                _DialogDropdown(title: 'SDVX 預設扣款模式 ? ', value: sdvxP, avaliList: SDVXPayment.values),
                _DialogDropdown(title: '雙人遊玩機種預設扣款模式 ? ', value: dpP, avaliList: DPPayment.values)
              ],
            );
          }
        },
      ),
    );
  }
}
