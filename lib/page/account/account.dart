import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/bid/bid.dart';
import 'package:x50pay/common/models/padSettings/pad_settings.dart';
import 'package:x50pay/common/models/play/play.dart';
import 'package:x50pay/common/models/ticDate/tic_date.dart';
import 'package:x50pay/common/models/ticUsed/tic_used.dart';
import 'package:x50pay/common/route_generator.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/main.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

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
  late String avatarUrl;
  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    if (user.userimg!.contains('size')) {
      avatarUrl =
          '${user.userimg!.split('size').first}size=80&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg';
    } else {
      avatarUrl = user.userimg! + r"&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg";
    }
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Themes.borderColor, width: 0),
                  color: bgColor),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    user.userimg != null
                        ? CircleAvatar(
                            foregroundImage: NetworkImage(avatarUrl),
                            radius: 30,
                            backgroundImage: R.image.logo_150_jpg())
                        : CircleAvatar(foregroundImage: R.image.logo_150_jpg(), radius: 30),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.8, 8, 0, 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.name!, style: const TextStyle(color: Color(0xfffafafa))),
                          const SizedBox(height: 5),
                          Text(user.email!, style: const TextStyle(color: Color(0xfffafafa))),
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
                  launchUrlString('https://en.gravatar.com/', mode: LaunchMode.externalApplication);
                }),
            _SettingTile(
                iconData: Icons.rss_feed,
                title: '多元付款設定',
                subtitle: 'X50MGS 多元付款喜好設定',
                color: _SettingTileColor.blue,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return QuickPayDialog(viewModel);
                  }));
                }),
            _SettingTile(
                iconData: Icons.badge_outlined,
                title: 'QuiC Pay 設定',
                subtitle: 'QuiC 喜愛選項設定',
                color: _SettingTileColor.blue,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return QuiCPayPrefDialog(viewModel);
                  }));
                }),
            _SettingTile(
                iconData: Icons.tablet_mac,
                title: '線上排隊設定',
                subtitle: 'X50Pad 西門線上排隊系統偏好設定',
                color: _SettingTileColor.blue,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return PadPrefDialog(viewModel);
                  }));
                }),
          ]),
          _AccountBlock(children: [
            _SettingTile(
                iconData: Icons.key,
                title: '更改密碼',
                subtitle: '密碼不夠安全嗎？點我更改！',
                color: _SettingTileColor.red,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return ChangePasswordDialog(viewModel);
                  }));
                }),
            _SettingTile(
                iconData: Icons.email_outlined,
                title: '更改信箱',
                subtitle: '換信箱了嗎，點我修改信箱。',
                color: _SettingTileColor.white,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return ChangeEmailDialog(viewModel);
                  }));
                }),
            _SettingTile(
                iconData: Icons.call,
                title: '更改手機',
                subtitle: '換手機號碼了嗎，點我修改號碼重新驗證。',
                color: _SettingTileColor.white,
                onTap: () async {
                  if (user.tphone != 0 && !user.phoneactive!) {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => _ChangePhoneConfirmedDialog(viewModel, context));
                  }
                  showDialog(
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
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return _BidRecord(viewModel);
                  }));
                }),
            _SettingTile(
                iconData: Icons.redeem,
                title: '獲券紀錄',
                subtitle: '查詢可用遊玩券詳情 可用店鋪/機種/過期日。',
                color: _SettingTileColor.yellow,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return _TicketRecord(viewModel);
                  }));
                }),
            _SettingTile(
                iconData: Icons.format_list_bulleted,
                title: '付費明細',
                subtitle: '查詢點數付款明細。',
                color: _SettingTileColor.yellow,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return _PlayRecord(viewModel);
                  }));
                }),
            _SettingTile(
                iconData: Icons.confirmation_num,
                title: '扣券明細',
                subtitle: '查詢遊玩券使用明細。',
                color: _SettingTileColor.yellow,
                onTap: () async {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) {
                    return _TicketUsedRecord(viewModel);
                  }));
                }),
          ]),
          _AccountBlock(children: [
            _SettingTile(
                iconData: Icons.home,
                title: '西門一店開門',
                subtitle: '就是個一店開門按鈕',
                color: _SettingTileColor.white,
                onTap: () {
                  checkRemoteOpen(shop: RemoteOpenShop.firstShop);
                }),
            _SettingTile(
                iconData: Icons.home,
                title: '西門二店開門',
                subtitle: '就是個二店開門按鈕',
                color: _SettingTileColor.white,
                onTap: () {
                  checkRemoteOpen(shop: RemoteOpenShop.secondShop);
                }),
            _SettingTile(
                iconData: Icons.logout,
                title: '登出帳號',
                subtitle: '就是個登出',
                color: _SettingTileColor.white,
                onTap: () async {
                  showDialog(context: context, builder: (context) => _askLogout());
                }),
          ]),
        ],
      ),
    );
  }

  void checkRemoteOpen({required RemoteOpenShop shop}) async {
    await EasyLoading.show();
    final location = Location();
    double deg2rad(double deg) => deg * (math.pi / 180);

    double getDistance(double lat1, double lng1, double lat2, double lng2) {
      var R = 6371; // Radius of the earth in km
      var dLat = deg2rad(lat2 - lat1); // deg2rad below
      var dLon = deg2rad(lng2 - lng1);
      var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
          math.cos(deg2rad(lat1)) * math.cos(deg2rad(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
      var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      var d = R * c; // Distance in km
      return d;
    }

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        await EasyLoading.dismiss();
        return;
      }
    }

    locationData = await location.getLocation();
    double myLat = locationData.latitude!;
    double myLng = locationData.longitude!;
    String result = await Repository().remoteOpenDoor(
      getDistance(25.0455991, 121.5027702, myLat, myLng),
      doorName: shop.doorName,
    );
    await EasyLoading.dismiss();
    await EasyLoading.showInfo(result.replaceFirst(',', '\n'));
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
              final nav = Navigator.of(context);
              if (await viewModel.logout()) {
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
            style: Themes.severe(isV4: true),
            child: const Text('登出'))
      ],
    );
  }
}

enum NVSVPayment {
  light('Light', '0'),
  standard('Standard', '1'),
  blaster('Blaster', '2');

  final String name;
  final String value;
  const NVSVPayment(this.name, this.value);
}

enum SDVXPayment {
  standard('Standard', '0'),
  blaster('Blaster', '1');

  final String name;
  final String value;
  const SDVXPayment(this.name, this.value);
}

enum DPPayment {
  single('單人', "0"),
  double('雙人', "1");

  final String name;
  final String value;
  const DPPayment(this.name, this.value);
}

enum DefaultCabPayment {
  ask('每次都詢問我', '0'),
  x50pay('X50Pay', '1'),
  jko('街口支付', '2');

  final String name;
  final String value;
  const DefaultCabPayment(this.name, this.value);
}

class _AccountBlock extends StatelessWidget {
  final List<_SettingTile> children;
  const _AccountBlock({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Themes.borderColor, width: 1),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: children.length,
            separatorBuilder: (context, index) =>
                const Divider(thickness: 1, height: 1, color: Themes.borderColor),
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

enum _SettingTileColor { green, red, yellow, blue, black, white }

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
    Color? iconColor;

    switch (color) {
      case _SettingTileColor.green:
        iconColor = const Color(0xff37970e);
        break;
      case _SettingTileColor.red:
        iconColor = const Color(0xfff5222d);
        break;
      case _SettingTileColor.yellow:
        iconColor = const Color(0xfff4d614);
        break;
      case _SettingTileColor.blue:
        iconColor = const Color(0xff2492f7);
        break;
      case _SettingTileColor.black:
        iconColor = const Color(0xff333333);
        break;
      case _SettingTileColor.white:
        iconColor = const Color(0xfffafafa);
        break;
    }

    return ListTile(
      onTap: onTap,
      leading: Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Themes.borderColor, width: 2)),
          child: Icon(iconData, color: iconColor, size: 18)),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      subtitle: Text(subtitle, style: const TextStyle(color: Color(0xffb7b7b7))),
    );
  }
}

class _Dialog extends StatelessWidget {
  final Widget content;
  final bool scrollable;
  final void Function()? onConfirm;
  final Widget? customConfirmButton;
  final bool _iosLike;
  final String title;

  const _Dialog({
    required this.content,
    required this.onConfirm,
    this.customConfirmButton,
    this.scrollable = false,
  })  : _iosLike = false,
        title = '';

  const _Dialog.ios({
    required this.content,
    required this.title,
    this.onConfirm,
    this.customConfirmButton,
    this.scrollable = false,
  }) : _iosLike = true;

  @override
  Widget build(BuildContext context) {
    if (_iosLike) {
      return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        navigationBar: CupertinoNavigationBar(
            previousPageTitle: '設定',
            middle: Text(title),
            trailing: customConfirmButton ??
                (onConfirm != null
                    ? CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: onConfirm,
                        child: const Text('保存', style: TextStyle(color: CupertinoColors.activeBlue)),
                      )
                    : null)),
        child: content,
      );
    }
    return AlertDialog(
      scrollable: scrollable,
      contentPadding: const EdgeInsets.only(top: 28, left: 28, right: 28, bottom: 14),
      actionsPadding: const EdgeInsets.only(top: 0, left: 28, right: 28, bottom: 28),
      content: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: content),
      actionsAlignment: MainAxisAlignment.start,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: Themes.pale(),
            child: const Text('取消')),
        customConfirmButton == null
            ? TextButton(onPressed: onConfirm, style: Themes.severe(isV4: true), child: const Text('保存'))
            : customConfirmButton!
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
  final bool _iosLike;
  final void Function(bool value)? onChanged;
  const _DialogSwitch({required this.value, required this.title, this.onChanged}) : _iosLike = false;
  const _DialogSwitch.ios({required this.value, required this.title, required this.onChanged})
      : _iosLike = true;

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
    if (widget._iosLike) {
      return CupertinoListTile.notched(
        title: Text(widget.title),
        trailing: CupertinoSwitch(
            activeColor: const Color(0xff005eb0),
            value: v,
            onChanged: (newValue) {
              v = newValue;
              setState(() {});
              widget.onChanged?.call(newValue);
            }),
      );
    }
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
        if (!widget._iosLike) const SizedBox(width: 15),
        if (!widget._iosLike) Text(widget.title),
      ],
    );
  }
}

class _DialogDropdown<T> extends StatefulWidget {
  final String title;
  final T? value;
  final List<T> avaliList;
  final bool _ios;
  final void Function(T value)? onChanged;
  const _DialogDropdown({required this.title, required this.value, required this.avaliList})
      : _ios = false,
        onChanged = null;
  const _DialogDropdown.ios(
      {required this.title, required this.value, required this.avaliList, required this.onChanged})
      : _ios = true;

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

  Widget buildCupertinoPicker() {
    return CupertinoPicker.builder(
      childCount: widget.avaliList.length,
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      scrollController: FixedExtentScrollController(
        initialItem: v == null ? 0 : widget.avaliList.indexOf(v as T),
      ),
      onSelectedItemChanged: (int selectedItem) {
        v = widget.avaliList[selectedItem];
        HapticFeedback.mediumImpact();
        setState(() {});
        widget.onChanged?.call(v as T);
      },
      itemBuilder: (context, index) =>
          Center(child: Text(widget.avaliList[index].toString().split('.').last)),
    );
  }

  void _showCupertinoPickerDialog() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: buildCupertinoPicker(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget._ios) {
      return CupertinoListTile.notched(
        title: Text(widget.title),
        onTap: _showCupertinoPickerDialog,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              v.toString().split('.').last,
              style: const TextStyle(color: CupertinoColors.systemGrey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 10),
            const CupertinoListTileChevron(),
          ],
        ),
      );
    }
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
  final bool _iosLike;
  const _DialogWidget({required this.title, required this.child, this.isRequired = false, this.titleIcon})
      : _iosLike = false;
  const _DialogWidget.ios({required this.title, required this.child, this.isRequired = false, this.titleIcon})
      : _iosLike = true;

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
              style: const TextStyle(color: Color(0xfffafafa)),
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

enum RemoteOpenShop {
  firstShop((lat: 25.0455991, lng: 121.5027702), doorName: 'door'),
  secondShop((lat: 25.0455991, lng: 121.5027702), doorName: 'door2');

  final ({double lat, double lng}) location;
  final String doorName;
  const RemoteOpenShop(this.location, {required this.doorName});
}
