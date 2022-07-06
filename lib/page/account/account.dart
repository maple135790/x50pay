import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/main.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/r.g.dart';

part 'popups/quick_pay.dart';
part 'popups/quiC_pay_pref.dart';
part 'popups/pad_pref.dart';
part 'popups/change_password.dart';
part 'popups/change_email.dart';
part 'popups/change_phone.dart';
part 'recordBid/bid_record.dart';
part 'recordTicket/ticket_record.dart';
part 'recordUsedTicket/ticket_used_record.dart';
part 'recordPlay/play_record.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends BaseStatefulState<Account> with BaseLoaded {
  final user = GlobalSingleton.instance.user!;
  final viewModel = AccountViewModel();
  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffe9e9e9), width: 1), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  user.userimg != null
                      ? CircleAvatar(foregroundImage: NetworkImage(user.userimg!), radius: 30)
                      : CircleAvatar(foregroundImage: R.image.logo_150_jpg(), radius: 30),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.8, 8, 0, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name!, style: const TextStyle(color: Color(0xff404040), fontSize: 18)),
                        const SizedBox(height: 10),
                        Text(user.email!, style: const TextStyle(color: Color(0xff919191))),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        _AccountBlock(children: [
          _SettingTile(
              iconData: Icons.remember_me,
              title: '修改頭像',
              subtitle: '外連至 Gravator 更換大頭貼相片',
              color: _SettingTileColor.green,
              onTap: () {
                launchUrlString('https://en.gravatar.com/');
              }),
          _SettingTile(
              iconData: Icons.rss_feed,
              title: '快速付款設定',
              subtitle: 'NFC / QuiC 喜愛選項設定',
              color: _SettingTileColor.red,
              onTap: () async {
                await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return QuickPayDialog(viewModel);
                    });
              }),
          _SettingTile(
              iconData: Icons.badge_outlined,
              title: 'QuiC 卡片管理',
              subtitle: 'QuiC 靠卡系統刪除/鎖定/管理',
              color: _SettingTileColor.red,
              onTap: () async {
                await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return QuiCPayPrefDialog(viewModel);
                    });
              }),
          _SettingTile(
              iconData: Icons.tablet_mac,
              title: '線上排隊設定',
              subtitle: 'X50Pad 西門線上排隊系統偏好設定',
              color: _SettingTileColor.red,
              onTap: () async {
                await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return PadPrefDialog(viewModel);
                    });
              }),
        ]),
        _AccountBlock(children: [
          _SettingTile(
              iconData: Icons.key,
              title: '更改密碼',
              subtitle: '密碼不夠安全嗎？點我更改！',
              color: _SettingTileColor.red,
              onTap: () async {
                await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ChangePasswordDialog(viewModel);
                    });
              }),
          _SettingTile(
              iconData: Icons.email_outlined,
              title: '更改信箱',
              subtitle: '換信箱了嗎，點我修改信箱。',
              color: _SettingTileColor.blue,
              onTap: () async {
                await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ChangeEmailDialog(viewModel);
                    });
              }),
          _SettingTile(
              iconData: Icons.tablet_mac,
              title: '更改手機',
              subtitle: '換手機號碼了嗎，點我修改號碼重新驗證。',
              color: _SettingTileColor.blue,
              onTap: () async {
                if (user.tphone != 0 && !user.phoneactive!) {
                  await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => _ChangePhoneConfirmedDialog(viewModel, context));
                }
                await showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ChangePhoneDialog(
                        viewModel,
                        callback: (isOk) async {
                          Navigator.of(context).pop();
                          if (isOk) {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => _ChangePhoneConfirmedDialog(viewModel, context));
                          } else {
                            await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50',
                                dismissOnTap: false, duration: const Duration(seconds: 2));
                          }
                        },
                      );
                    });
              }),
        ]),
        _AccountBlock(children: [
          _SettingTile(
              iconData: Icons.local_atm,
              title: '儲值紀錄',
              subtitle: '查詢加值相關記錄。',
              color: _SettingTileColor.yellow,
              onTap: () async {
                Navigator.of(context).push(NoTransitionRouter(_BidRecord(viewModel)));
              }),
          _SettingTile(
              iconData: Icons.redeem,
              title: '獲券紀錄',
              subtitle: '查詢可用遊玩券詳情 可用店鋪/機種/過期日。',
              color: _SettingTileColor.yellow,
              onTap: () async {
                Navigator.of(context).push(NoTransitionRouter(_TicketRecord(viewModel)));
              }),
          _SettingTile(
              iconData: Icons.format_list_bulleted,
              title: '付費明細',
              subtitle: '查詢點數付款明細。',
              color: _SettingTileColor.yellow,
              onTap: () async {
                Navigator.of(context).push(NoTransitionRouter(_PlayRecord(viewModel)));
              }),
          _SettingTile(
              iconData: Icons.confirmation_num,
              title: '扣券明細',
              subtitle: '查詢遊玩券使用明細。',
              color: _SettingTileColor.yellow,
              onTap: () async {
                Navigator.of(context).push(NoTransitionRouter(_TicketUsedRecord(viewModel)));
              }),
        ]),
        _AccountBlock(children: [
          _SettingTile(
              iconData: Icons.person_remove,
              title: '登出帳號',
              subtitle: '就是個登出',
              color: _SettingTileColor.black,
              onTap: () async {
                showDialog(context: context, builder: (context) => _askLogout());
              }),
        ]),
      ],
    );
  }

  Widget _askLogout() {
    return AlertDialog(
      title: const Text('登出'),
      content: const Text('確定要登出?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: Themes.grey(),
            child: const Text('取消')),
        TextButton(
            onPressed: () async {
              if (await viewModel.logout()) {
                final nav = Navigator.of(context);
                GlobalSingleton.instance.clearUser();
                final prefs = await SharedPreferences.getInstance();
                await EasyLoading.showSuccess('感謝\n登出成功！歡迎再光臨本小店',
                    dismissOnTap: false, duration: const Duration(seconds: 2));
                await prefs.remove('session');
                await Future.delayed(const Duration(seconds: 2));
                nav.pushReplacementNamed(AppRoute.login);
              } else {
                await EasyLoading.showError('伺服器錯誤，請嘗試重新整理或回報X50',
                    dismissOnTap: false, duration: const Duration(seconds: 2));
              }
            },
            style: Themes.severe(),
            child: const Text('登出'))
      ],
    );
  }
}

enum NVSVPayment { light, standard, blaster }

enum SDVXPayment { standard, blaster }

enum DPPayment { single, double }

class _AccountBlock extends StatelessWidget {
  final List<_SettingTile> children;
  const _AccountBlock({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe9e9e9), width: 1), color: Colors.white),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: children.length,
            separatorBuilder: (context, index) =>
                const Divider(color: Color(0xffe9e9e9), thickness: 1, height: 1, endIndent: 15, indent: 15),
            itemBuilder: (context, index) {
              final tile = children[index];
              return _SettingTile(
                iconData: tile.iconData,
                title: tile.title,
                subtitle: tile.subtitle,
                color: tile.color,
                onTap: tile.onTap,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

enum _SettingTileColor { green, red, yellow, blue, black }

class _SettingTile extends StatelessWidget {
  final IconData iconData;
  final _SettingTileColor color;
  final String title;
  final String subtitle;
  final void Function()? onTap;

  const _SettingTile(
      {required this.iconData,
      Key? key,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color boxColor;
    Color? iconColor;

    switch (color) {
      case _SettingTileColor.green:
        boxColor = const Color(0xff8bb96e);
        break;
      case _SettingTileColor.red:
        boxColor = const Color(0xffce5f58);
        break;
      case _SettingTileColor.yellow:
        boxColor = const Color(0xffE8F562);
        iconColor = const Color(0xffB59120);
        break;
      case _SettingTileColor.blue:
        boxColor = const Color(0xff79A8B9);
        break;
      case _SettingTileColor.black:
        boxColor = const Color(0xff333333);
        break;
    }
    iconColor ??= const Color(0xfffffefa);

    return ListTile(
      onTap: onTap,
      leading: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(color: boxColor, borderRadius: BorderRadius.circular(5)),
          child: Icon(iconData, color: iconColor)),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      subtitle: Text(subtitle, style: const TextStyle(color: Color(0xffb7b7b7))),
    );
  }
}

class _Dialog extends StatelessWidget {
  final Widget content;
  final void Function() saveCallback;
  final Widget? customSaveButton;
  const _Dialog({required this.content, required this.saveCallback, Key? key, this.customSaveButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(top: 28, left: 28, right: 28, bottom: 14),
      actionsPadding: const EdgeInsets.only(top: 0, left: 28, right: 28, bottom: 28),
      content: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(child: content)),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: Themes.grey(),
            child: const Text('取消')),
        customSaveButton == null
            ? TextButton(onPressed: saveCallback, style: Themes.confirm(), child: const Text('保存'))
            : customSaveButton!
      ],
    );
  }
}

class _DialogBody extends StatelessWidget {
  final List<Widget> children;
  final String title;
  const _DialogBody({Key? key, required this.children, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: const TextStyle(color: Color(0xff5a5a5a)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(title, style: const TextStyle(color: Color(0xffbfbfbf), fontSize: 12))),
          const SizedBox(height: 30),
          ...children,
        ]));
  }
}

class _DialogSwitch extends StatefulWidget {
  final bool value;
  final String title;
  const _DialogSwitch({Key? key, required this.value, required this.title}) : super(key: key);

  @override
  State<_DialogSwitch> createState() => _DialogSwitchState();
}

class _DialogSwitchState extends State<_DialogSwitch> {
  bool v = false;

  @override
  void initState() {
    v = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoSwitch(
            activeColor: const Color(0xff005eb0),
            value: v,
            onChanged: (newValue) {
              setState(() {
                v = newValue;
              });
            }),
        const SizedBox(width: 15),
        Text(widget.title),
      ],
    );
  }
}

class _DialogDropdown<T> extends StatefulWidget {
  final String title;
  final T? value;
  final List<T> avaliList;
  const _DialogDropdown({Key? key, required this.title, required this.value, required this.avaliList})
      : super(key: key);

  @override
  State<_DialogDropdown<T>> createState() => _DialogDropdownState<T>();
}

class _DialogDropdownState<T> extends State<_DialogDropdown<T>> {
  T? v;
  @override
  void initState() {
    v = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(alignment: Alignment.centerLeft, child: Text(widget.title)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffd9d9d9)), borderRadius: BorderRadius.circular(5)),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
            value: v,
            isExpanded: true,
            onChanged: (newValue) {
              v = newValue;
              setState(() {});
            },
            items: widget.avaliList
                .map((e) => DropdownMenuItem<T>(
                    value: e,
                    alignment: Alignment.centerLeft,
                    child: Text("   ${e.toString().split('.').last}")))
                .toList(),
          )),
        ),
      ],
    );
  }
}

class _DialogWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final IconData? titleIcon;
  final bool isRequired;
  const _DialogWidget(
      {Key? key, required this.title, required this.child, this.isRequired = false, this.titleIcon})
      : super(key: key);

  @override
  State<_DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<_DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: RichText(
                text: TextSpan(
              style: const TextStyle(color: Color(0xff5a5a5a)),
              children: widget.isRequired
                  ? [
                      widget.titleIcon == null
                          ? const WidgetSpan(child: SizedBox())
                          : WidgetSpan(
                              child: Icon(widget.titleIcon!, color: const Color(0xff5a5a5a), size: 18)),
                      TextSpan(text: widget.title),
                      const TextSpan(text: ' *', style: TextStyle(color: Colors.red))
                    ]
                  : [
                      widget.titleIcon == null
                          ? const WidgetSpan(child: SizedBox())
                          : WidgetSpan(child: Icon(widget.titleIcon!, color: const Color(0xff5a5a5a))),
                      TextSpan(text: widget.title)
                    ],
            ))),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffd9d9d9)), borderRadius: BorderRadius.circular(5)),
          child: widget.child,
        ),
        const SizedBox(height: 22.4),
      ],
    );
  }
}
