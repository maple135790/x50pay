import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibration/vibration.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/account/popups/change_phone.dart';
import 'package:x50pay/r.g.dart';
import 'package:x50pay/repository/repository.dart';

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
  ask('每次都詢問我', 0),
  x50pay('X50Pay', 1),
  jko('街口支付', 2);

  final String name;
  final int value;
  const DefaultCabPayment(this.name, this.value);
}

class Account extends StatefulWidget {
  final bool? shouldGoPhone;
  final bool? shouldGoTicketRecord;

  const Account({super.key, this.shouldGoPhone, this.shouldGoTicketRecord});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends BaseStatefulState<Account> {
  late final String avatarUrl;
  final viewModel = AccountViewModel();
  final user = GlobalSingleton.instance.userNotifier.value!;

  Color get bgColor => Theme.of(context).scaffoldBackgroundColor;

  void showEasterEgg() {
    Vibration.vibrate(duration: 50, amplitude: 128);
    Fluttertoast.showToast(msg: ' 🥳 ');
  }

  void onQuicPayPrefPressed() {
    context.pushNamed(AppRoutes.quicPayPref.routeName);
  }

  void onPaymentPrefPressed() async {
    context.pushNamed(AppRoutes.paymentPref.routeName);
  }

  void onPadPrefPressed() async {
    context.pushNamed(AppRoutes.padPref.routeName);
  }

  void onChangePasswordPressed() async {
    context.pushNamed(AppRoutes.changePassword.routeName);
  }

  void onChangeEmailPressed() async {
    context.pushNamed(AppRoutes.changeEmail.routeName);
  }

  void onBidRecordPressed() async {
    context.pushNamed(AppRoutes.bidRecords.routeName);
  }

  void onTicketRecordPressed() async {
    context.pushNamed(AppRoutes.ticketRecords.routeName);
  }

  void onPlayRecordPressed() async {
    context.pushNamed(AppRoutes.playRecords.routeName);
  }

  void onFreePointRecordPressed() async {
    context.pushNamed(AppRoutes.freePointRecords.routeName);
  }

  void onTicketUseRecordPressed() async {
    context.pushNamed(AppRoutes.ticketUsedRecords.routeName);
  }

  void onChangePhonePressed() async {
    if (user.tphone != 0 && !user.phoneactive!) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => ChangePhoneConfirmedDialog(viewModel, context));
    } else {
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
                      builder: (context) =>
                          ChangePhoneConfirmedDialog(viewModel, context));
                } else {
                  showServiceError();
                }
              },
            );
          });
    }
  }

  void onXimen1OpenPressed() {
    checkRemoteOpen(shop: RemoteOpenShop.firstShop);
  }

  void onXimen2OpenPressed() {
    checkRemoteOpen(shop: RemoteOpenShop.secondShop);
  }

  void onLogoutPressed() async {
    showDialog(context: context, builder: (context) => askLogout());
  }

  void onLogout() {
    context
      ..pop()
      ..goNamed(AppRoutes.login.routeName);
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
          math.cos(deg2rad(lat1)) *
              math.cos(deg2rad(lat2)) *
              math.sin(dLon / 2) *
              math.sin(dLon / 2);
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

  Widget askLogout() {
    return AlertDialog(
      title: const Text('登出'),
      content: const Text('確定要登出?'),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            style: Themes.grey(),
            child: const Text('取消')),
        TextButton(
            onPressed: () async {
              if (await viewModel.logout()) {
                GlobalSingleton.instance.clearUser();
                final prefs = await SharedPreferences.getInstance();
                await EasyLoading.showSuccess('感謝\n登出成功！歡迎再光臨本小店',
                    dismissOnTap: false, duration: const Duration(seconds: 2));
                await prefs.remove('session');
                await Future.delayed(const Duration(seconds: 2));
                onLogout();
              } else {
                showServiceError();
              }
            },
            style: Themes.severe(isV4: true),
            child: const Text('登出'))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    if (user.rawUserImgUrl!.contains('size')) {
      avatarUrl =
          '${user.rawUserImgUrl!.split('size').first}size=80&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg';
    } else {
      avatarUrl = user.rawUserImgUrl! +
          r"&d=https%3A%2F%2Fpay.x50.fun%2Fstatic%2Flogo.jpg";
    }

    if (widget.shouldGoPhone ?? false) {
      Future.delayed(const Duration(milliseconds: 350), () {
        onChangePhonePressed.call();
      });
    } else if (widget.shouldGoTicketRecord ?? false) {
      Future.delayed(const Duration(milliseconds: 350), () {
        onTicketRecordPressed.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(color: bgColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Themes.borderColor, width: 1),
                      color: bgColor),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        user.rawUserImgUrl != null
                            ? CachedNetworkImage(
                                imageUrl: avatarUrl,
                                width: 60,
                                height: 60,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 30,
                                ),
                              )
                            : CircleAvatar(
                                foregroundImage: R.image.logo_150_jpg(),
                                radius: 30),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.8, 8, 0, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name!,
                                  style: const TextStyle(
                                      color: Color(0xfffafafa))),
                              const SizedBox(height: 5),
                              Text(user.email!,
                                  style: const TextStyle(
                                      color: Color(0xfffafafa))),
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
                      launchUrlString('https://en.gravatar.com/',
                          mode: LaunchMode.externalApplication);
                    }),
                _SettingTile(
                  iconData: Icons.rss_feed,
                  title: '多元付款設定',
                  subtitle: 'X50MGS 多元付款喜好設定',
                  color: _SettingTileColor.blue,
                  onTap: onPaymentPrefPressed,
                ),
                _SettingTile(
                  iconData: Icons.badge_outlined,
                  title: 'QuiC Pay 設定',
                  subtitle: 'QuiC 喜愛選項設定',
                  color: _SettingTileColor.blue,
                  onTap: onQuicPayPrefPressed,
                ),
                _SettingTile(
                  iconData: Icons.tablet_mac,
                  title: '線上排隊設定',
                  subtitle: 'X50Pad 西門線上排隊系統偏好設定',
                  color: _SettingTileColor.blue,
                  onTap: onPadPrefPressed,
                ),
              ]),
              _AccountBlock(children: [
                _SettingTile(
                  iconData: Icons.key,
                  title: '更改密碼',
                  subtitle: '密碼不夠安全嗎？點我更改！',
                  color: _SettingTileColor.red,
                  onTap: onChangePasswordPressed,
                ),
                _SettingTile(
                  iconData: Icons.email_outlined,
                  title: '更改信箱',
                  subtitle: '換信箱了嗎，點我修改信箱。',
                  color: _SettingTileColor.white,
                  onTap: onChangeEmailPressed,
                ),
                _SettingTile(
                  iconData: Icons.call,
                  title: '更改手機',
                  subtitle: '換手機號碼了嗎，點我修改號碼重新驗證。',
                  color: _SettingTileColor.white,
                  onTap: onChangePhonePressed,
                ),
              ]),
              _AccountBlock(children: [
                _SettingTile(
                  iconData: Icons.local_atm,
                  title: '儲值紀錄',
                  subtitle: '查詢加值相關記錄。',
                  color: _SettingTileColor.yellow,
                  onTap: onBidRecordPressed,
                ),
                _SettingTile(
                  iconData: Icons.redeem,
                  title: '獲券紀錄',
                  subtitle: '查詢可用遊玩券詳情 可用店鋪/機種/過期日。',
                  color: _SettingTileColor.yellow,
                  onTap: onTicketRecordPressed,
                ),
                _SettingTile(
                  iconData: Icons.format_list_bulleted,
                  title: '付費明細',
                  subtitle: '查詢點數付款明細。',
                  color: _SettingTileColor.yellow,
                  onTap: onPlayRecordPressed,
                ),
                const _SettingTile(
                  iconData: Icons.list_alt_rounded,
                  title: '回饋明細',
                  subtitle: '查看回饋點數明細。',
                  color: _SettingTileColor.yellow,
                  // TODO(kenneth): 等拿到 freeP api 內容後再開放
                  onTap: null,
                ),
                _SettingTile(
                  iconData: Icons.confirmation_num,
                  title: '扣券明細',
                  subtitle: '查詢遊玩券使用明細。',
                  color: _SettingTileColor.yellow,
                  onTap: onTicketUseRecordPressed,
                ),
              ]),
              _AccountBlock(children: [
                _SettingTile(
                  iconData: Icons.home,
                  title: '西門一店開門',
                  subtitle: '就是個一店開門按鈕',
                  color: _SettingTileColor.white,
                  onTap: onXimen1OpenPressed,
                ),
                _SettingTile(
                  iconData: Icons.home,
                  title: '西門二店開門',
                  subtitle: '就是個二店開門按鈕',
                  color: _SettingTileColor.white,
                  onTap: onXimen2OpenPressed,
                ),
                _SettingTile(
                  iconData: Icons.logout,
                  title: '登出帳號',
                  subtitle: '就是個登出',
                  color: _SettingTileColor.white,
                  onTap: onLogoutPressed,
                ),
              ]),
              GestureDetector(
                onLongPress: showEasterEgg,
                child: Center(
                  child: Text(GlobalSingleton.instance.appVersion,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: const Color(0xff505050).withOpacity(0.7))),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountBlock extends StatelessWidget {
  final List<_SettingTile> children;
  const _AccountBlock({required this.children, Key? key}) : super(key: key);

  List<Widget> get _children {
    final list = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      list.add(_SettingTile(
        iconData: children[i].iconData,
        title: children[i].title,
        subtitle: children[i].subtitle,
        color: children[i].color,
        onTap: children[i].onTap,
      ));
      if (i != children.length - 1) {
        list.add(
            const Divider(thickness: 1, height: 1, color: Themes.borderColor));
      }
    }
    return list;
  }

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
          child: Column(children: _children),
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
      subtitle:
          Text(subtitle, style: const TextStyle(color: Color(0xffb7b7b7))),
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
