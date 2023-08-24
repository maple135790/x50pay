import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/page/account/account.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/account/popups/popup_dialog.dart';

class PaymentPrefDialog extends StatefulWidget {
  const PaymentPrefDialog({super.key});

  @override
  State<PaymentPrefDialog> createState() => _PaymentPrefDialogState();
}

class _PaymentPrefDialogState extends State<PaymentPrefDialog> {
  late bool isNfcAutoPayEnabled;
  late bool isQuiCPayEnabled;
  late bool isUseTicketEnabled;
  late bool isUseRewardPoint;
  late NVSVPayment nvsvP;
  late SDVXPayment sdvxP;
  late DPPayment dpP;
  late DefaultCabPayment defaultCabP;

  void confirmQuickPay(AccountViewModel viewModel) {
    viewModel.confirmQuickPay(
      autoPay: isNfcAutoPayEnabled,
      autoQuicPay: isQuiCPayEnabled,
      autoTicket: isUseTicketEnabled,
      autoTwo: dpP.value,
      autoNVSV: nvsvP.value,
      autoRewardPoint: isUseRewardPoint,
      mtp: defaultCabP.value,
      autoSDVX: sdvxP.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountViewModel>(
      builder: (context, viewModel, child) => PageDialog.ios(
          title: '快速付款偏好設定',
          onConfirm: () {
            confirmQuickPay(viewModel);
          },
          content: (showButtonBar) => FutureBuilder<bool>(
                future: viewModel.getPaymentSettings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox();
                  }
                  if (snapshot.data != true) {
                    EasyLoading.dismiss();
                    return const Center(child: Text('failed'));
                  } else {
                    showButtonBar(true);

                    final model = viewModel.paymentSettingModel!;
                    isNfcAutoPayEnabled = model.nfcAuto;
                    isQuiCPayEnabled = model.nfcQuic;
                    isUseTicketEnabled = model.nfcTicket;
                    isUseRewardPoint = model.aGV;
                    nvsvP = NVSVPayment.values.firstWhere(
                        (element) => element.value == model.nfcNVSV);
                    sdvxP = SDVXPayment.values.firstWhere(
                        (element) => element.value == model.nfcSDVX);
                    dpP = DPPayment.values
                        .firstWhere((element) => element.value == model.nfcTwo);
                    defaultCabP = DefaultCabPayment.values.firstWhere(
                        (element) => element.value == model.mtpMode);

                    return Column(
                      children: [
                        CupertinoListSection.insetGrouped(
                          children: [
                            DialogSwitch.ios(
                              title: '啟用 NFC 自動扣款',
                              value: isNfcAutoPayEnabled,
                              onChanged: (value) {
                                isNfcAutoPayEnabled = value;
                              },
                            ),
                            DialogSwitch.ios(
                              title: '啟用 QuiC 靠卡扣款',
                              value: isQuiCPayEnabled,
                              onChanged: (value) {
                                isQuiCPayEnabled = value;
                              },
                            ),
                            DialogSwitch.ios(
                              title: '預設使用回饋點數',
                              value: isUseRewardPoint,
                              onChanged: (value) {
                                isUseRewardPoint = value;
                              },
                            ),
                            DialogSwitch.ios(
                              title: '預設扣遊玩券',
                              value: isUseTicketEnabled,
                              onChanged: (value) {
                                isUseTicketEnabled = value;
                              },
                            ),
                          ],
                        ),
                        CupertinoListSection.insetGrouped(
                          children: [
                            DialogDropdown.ios(
                              title: '機台付款碼預設',
                              value: defaultCabP.name,
                              avaliList: DefaultCabPayment.values
                                  .map((e) => e.name)
                                  .toList(),
                              onChanged: (value) {
                                defaultCabP = DefaultCabPayment.values
                                    .firstWhere(
                                        (element) => element.name == value);
                              },
                            ),
                            DialogDropdown.ios(
                                title: '女武神預設扣款模式',
                                value: nvsvP.name,
                                avaliList: NVSVPayment.values
                                    .map((e) => e.name)
                                    .toList(),
                                onChanged: (value) {
                                  nvsvP = NVSVPayment.values.firstWhere(
                                      (element) => element.name == value);
                                }),
                            DialogDropdown.ios(
                                title: '雙人遊玩機種預設扣款模式',
                                value: dpP.name,
                                avaliList: DPPayment.values
                                    .map((e) => e.name)
                                    .toList(),
                                onChanged: (value) {
                                  dpP = DPPayment.values.firstWhere(
                                      (element) => element.name == value);
                                }),
                          ],
                        ),
                      ],
                    );
                  }
                },
              )),
    );
  }
}
