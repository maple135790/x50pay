part of '../account.dart';

class QuickPayDialog extends StatefulWidget {
  final AccountViewModel viewModel;
  const QuickPayDialog(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<QuickPayDialog> createState() => _QuickPayDialogState();
}

class _QuickPayDialogState extends State<QuickPayDialog> {
  late bool isNfcAutoPayEnabled;
  late bool isQuiCPayEnabled;
  late bool isUseTicketEnabled;
  late NVSVPayment nvsvP;
  late SDVXPayment sdvxP;
  late DPPayment dpP;
  late DefaultCabPayment defaultCabP;

  void confirmQuickPay() {
    widget.viewModel.confirmQuickPay(
        autoPay: isNfcAutoPayEnabled,
        autoQuicPay: isQuiCPayEnabled,
        autoTicket: isUseTicketEnabled,
        autoTwo: dpP.value,
        autoNVSV: nvsvP.value,
        mtp: defaultCabP.value,
        autoSDVX: sdvxP.value);
  }

  @override
  Widget build(BuildContext context) {
    return _Dialog.ios(
      title: '快速付款偏好設定',
      scrollable: true,
      onConfirm: confirmQuickPay,
      content: FutureBuilder<bool>(
        future: widget.viewModel.getQuicSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Text('loading'));
          }
          if (snapshot.data != true) {
            EasyLoading.dismiss();
            return const Center(child: Text('failed'));
          } else {
            final model = widget.viewModel.quicSettingModel!;
            isNfcAutoPayEnabled = model.nfcAuto;
            isQuiCPayEnabled = model.nfcQuic;
            isUseTicketEnabled = model.nfcTicket;
            nvsvP = NVSVPayment.values
                .firstWhere((element) => element.value == model.nfcNVSV);
            sdvxP = SDVXPayment.values
                .firstWhere((element) => element.value == model.nfcSDVX);
            dpP = DPPayment.values
                .firstWhere((element) => element.value == model.nfcTwo);
            defaultCabP = DefaultCabPayment.values
                .firstWhere((element) => element.value == model.mtpMode);

            return Column(
              children: [
                CupertinoListSection.insetGrouped(
                  children: [
                    _DialogSwitch.ios(
                      title: '啟用 QuiC 靠卡扣款',
                      value: isQuiCPayEnabled,
                      onChanged: (value) {
                        isQuiCPayEnabled = value;
                      },
                    ),
                    _DialogSwitch.ios(
                      title: '啟用 NFC 自動扣款',
                      value: isNfcAutoPayEnabled,
                      onChanged: (value) {
                        isNfcAutoPayEnabled = value;
                      },
                    ),
                    _DialogSwitch.ios(
                      title: '啟用預設扣券',
                      value: isUseTicketEnabled,
                      onChanged: (value) {
                        isUseTicketEnabled = value;
                      },
                    ),
                  ],
                ),
                CupertinoListSection.insetGrouped(
                  children: [
                    _DialogDropdown.ios(
                      title: '機台付款碼預設',
                      value: defaultCabP.name,
                      avaliList:
                          DefaultCabPayment.values.map((e) => e.name).toList(),
                      onChanged: (value) {
                        defaultCabP = DefaultCabPayment.values
                            .firstWhere((element) => element.name == value);
                      },
                    ),
                    _DialogDropdown.ios(
                        title: '女武神預設扣款模式',
                        value: nvsvP.name,
                        avaliList:
                            NVSVPayment.values.map((e) => e.name).toList(),
                        onChanged: (value) {
                          nvsvP = NVSVPayment.values
                              .firstWhere((element) => element.name == value);
                        }),
                    _DialogDropdown.ios(
                        title: '雙人遊玩機種預設扣款模式',
                        value: dpP.name,
                        avaliList: DPPayment.values.map((e) => e.name).toList(),
                        onChanged: (value) {
                          dpP = DPPayment.values
                              .firstWhere((element) => element.name == value);
                        }),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
