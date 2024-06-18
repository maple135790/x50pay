import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vibration/vibration.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/models/user/user.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/common/theme/color_theme.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/gen/assets.gen.dart';
import 'package:x50pay/mixins/remote_open_mixin.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/page/settings/popups/change_phone.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/setting_repository.dart';

class Settings extends StatefulWidget {
  /// 是否要跳轉到更換手機
  final bool shouldGoPhone;

  /// 是否要跳轉到遊玩券記錄
  final bool shouldGoTicketRecord;

  /// 設定頁面
  const Settings({
    super.key,
    this.shouldGoPhone = false,
    this.shouldGoTicketRecord = false,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends BaseStatefulState<Settings> with RemoteOpenMixin {
  late final String avatarUrl;
  late final viewModel = SettingsViewModel(settingRepo: settingRepo);
  late final UserModel user;
  late Future<void> intentDelay;
  final settingRepo = SettingRepository();
  final scrollController = ScrollController();

  void showEasterEgg() {
    Vibration.vibrate(duration: 50, amplitude: 128);
    Fluttertoast.showToast(msg: '🥳');
  }

  void onQuicPayPrefPressed() {
    context.pushNamed(AppRoutes.quicPayPref.routeName);
  }

  void onPaymentPrefPressed() {
    context.pushNamed(AppRoutes.paymentPref.routeName);
  }

  void onPadPrefPressed() {
    context.pushNamed(AppRoutes.padPref.routeName);
  }

  void onChangePasswordPressed() {
    context.pushNamed(AppRoutes.changePassword.routeName);
  }

  void onChangeEmailPressed() {
    context.pushNamed(AppRoutes.changeEmail.routeName);
  }

  void onBidRecordPressed() {
    context.pushNamed(AppRoutes.bidRecords.routeName);
  }

  void onTicketRecordPressed() {
    context.pushNamed(AppRoutes.ticketRecords.routeName);
  }

  void onPlayRecordPressed() {
    context.pushNamed(AppRoutes.playRecords.routeName);
  }

  void onFreePointRecordPressed() {
    context.pushNamed(AppRoutes.freePointRecords.routeName);
  }

  void onTicketUseRecordPressed() {
    context.pushNamed(AppRoutes.ticketUsedRecords.routeName);
  }

  void onX50PayAppSettingPressed() {
    context.pushNamed(AppRoutes.x50PayAppSetting.routeName);
  }

  /// 顯示手機已移除的 Dialog。無論是否有添加過手機，都會顯示
  void showPhoneRemovedDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const ChangePhoneConfirmedDialog(),
    );
  }

  void onChangePhonePressed() async {
    // 已經送出驗證碼，但使用者尚未進行驗證
    final hasSentVerification = user.tphone != 0 && !user.phoneactive!;

    if (hasSentVerification) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const ChangePhoneConfirmedDialog();
        },
      );
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return ChangePhoneDialog(
            onPhoneRemoved: (isRemoved) {
              Navigator.of(context).pop();
              if (!isRemoved) {
                showServiceError();
                return;
              }
              showPhoneRemovedDialog();
            },
          );
        },
      );
    }
  }

  void onXimen1OpenPressed() {
    checkRemoteOpen(shop: RemoteOpenShop.firstShop);
  }

  void onXimen2OpenPressed() {
    checkRemoteOpen(shop: RemoteOpenShop.secondShop);
  }

  void onChangeAvatarPressed() {
    launchUrlString(
      'https://en.gravatar.com/',
      mode: LaunchMode.externalApplication,
    );
  }

  void onLogoutPressed() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('登出'),
        content: const Text('確定要登出?'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            style: CustomButtonThemes.grey(),
            child: const Text('取消'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: doLogout,
            style: CustomButtonThemes.severe(isV4: true),
            child: const Text('登出'),
          )
        ],
      ),
    );
  }

  void doLogout() async {
    final userProvider = context.read<UserProvider>();
    final loginProvider = context.read<LoginProvider>();
    final isLogout = await loginProvider.logout();

    if (!isLogout) {
      showServiceError();
      return;
    }
    userProvider.clearUser();
    Prefs.secureDelete(SecurePrefsToken.session);
    await EasyLoading.showSuccess(
      '感謝\n登出成功！歡迎再光臨本小店',
      dismissOnTap: false,
      duration: const Duration(seconds: 2),
    );
    await Future.delayed(const Duration(seconds: 2));
    context
      ..pop()
      ..goNamed(AppRoutes.login.routeName);
  }

  @override
  void initState() {
    super.initState();
    intentDelay = viewModel.init();
    user = context.read<UserProvider>().user!;

    avatarUrl = user.settingsUserImageUrl;
    if (widget.shouldGoPhone) {
      Future.delayed(const Duration(milliseconds: 350), () {
        onChangePhonePressed.call();
      });
    } else if (widget.shouldGoTicketRecord) {
      Future.delayed(const Duration(milliseconds: 350), () {
        onTicketRecordPressed.call();
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final Widget userAvatar;
    if (user.rawUserImgUrl != null) {
      userAvatar = CachedNetworkImage(
        imageUrl: avatarUrl,
        width: 60,
        height: 60,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
          radius: 30,
        ),
      );
    } else {
      userAvatar = CircleAvatar(
        foregroundImage: R.images.common.logo150.provider(),
        radius: 30,
      );
    }

    final accountItem = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDarkTheme
                ? CustomColorThemes.borderColorDark
                : CustomColorThemes.borderColorLight,
            width: 2,
          ),
          color: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              userAvatar,
              Padding(
                padding: const EdgeInsets.fromLTRB(16.8, 8, 0, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name!),
                    const SizedBox(height: 5),
                    Text(user.email!),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    final settingsGroups = [
      accountItem,
      _SettingsGroup(children: [
        _SettingTile(
          iconData: Icons.remember_me_rounded,
          title: i18n.userAvatar,
          color: _SettingTileColor.green,
          onTap: onChangeAvatarPressed,
        ),
        _SettingTile(
          iconData: Icons.rss_feed_rounded,
          title: i18n.userNFC,
          color: _SettingTileColor.blue,
          onTap: onPaymentPrefPressed,
        ),
        _SettingTile(
          iconData: Icons.badge_rounded,
          title: i18n.userQUIC,
          color: _SettingTileColor.blue,
          onTap: onQuicPayPrefPressed,
        ),
        _SettingTile(
          iconData: Icons.tablet_mac_rounded,
          title: i18n.userPad,
          color: _SettingTileColor.blue,
          onTap: onPadPrefPressed,
        ),
      ]),
      _SettingsGroup(children: [
        _SettingTile(
          iconData: Icons.key_rounded,
          title: i18n.userPassword,
          color: _SettingTileColor.red,
          onTap: onChangePasswordPressed,
        ),
        _SettingTile(
          iconData: Icons.email_rounded,
          title: i18n.userEmail,
          color: _SettingTileColor.blackOrWhite,
          onTap: onChangeEmailPressed,
        ),
        _SettingTile(
          iconData: Icons.call_rounded,
          title: i18n.userPhone,
          color: _SettingTileColor.blackOrWhite,
          onTap: onChangePhonePressed,
        ),
      ]),
      _SettingsGroup(children: [
        _SettingTile(
          iconData: Icons.local_atm_rounded,
          title: i18n.userBidLog,
          color: _SettingTileColor.yellow,
          onTap: onBidRecordPressed,
        ),
        _SettingTile(
          iconData: Icons.redeem_rounded,
          title: i18n.userTicLog,
          color: _SettingTileColor.yellow,
          onTap: onTicketRecordPressed,
        ),
        _SettingTile(
          iconData: Icons.format_list_bulleted_rounded,
          title: i18n.userPlayLog,
          color: _SettingTileColor.yellow,
          onTap: onPlayRecordPressed,
        ),
        _SettingTile(
          iconData: Icons.list_alt_rounded,
          title: i18n.userFPlayLog,
          color: _SettingTileColor.yellow,
          onTap: onFreePointRecordPressed,
        ),
        _SettingTile(
          iconData: Icons.confirmation_num_rounded,
          title: i18n.userUTicLog,
          color: _SettingTileColor.yellow,
          onTap: onTicketUseRecordPressed,
        ),
      ]),
      _SettingsGroup(children: [
        _SettingTile(
          iconData: Icons.tune_rounded,
          title: i18n.userInAppSetting,
          color: _SettingTileColor.blackOrWhite,
          onTap: onX50PayAppSettingPressed,
        ),
      ]),
      _SettingsGroup(children: [
        _SettingTile(
          iconData: Icons.home_rounded,
          title: i18n.userOpenDoor1,
          color: _SettingTileColor.blackOrWhite,
          onTap: onXimen1OpenPressed,
        ),
        _SettingTile(
          iconData: Icons.home_rounded,
          title: i18n.userOpenDoor2,
          color: _SettingTileColor.blackOrWhite,
          onTap: onXimen2OpenPressed,
        ),
        _SettingTile(
          iconData: Icons.logout_rounded,
          title: i18n.userLogout,
          color: _SettingTileColor.blackOrWhite,
          onTap: onLogoutPressed,
        ),
      ]),
      GestureDetector(
        onLongPress: showEasterEgg,
        child: Center(
          child: Text(
            GlobalSingleton.instance.appVersion,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: const Color(0xff505050).withOpacity(0.7)),
          ),
        ),
      ),
      const SizedBox(height: 15),
    ];

    return FutureBuilder(
      future: intentDelay,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: SizedBox());
        }
        if (snapshot.hasError) {
          return Center(child: Text(serviceErrorText));
        }

        return Container(
          decoration: BoxDecoration(color: scaffoldBackgroundColor),
          child: Scrollbar(
            controller: scrollController,
            child: ListView.builder(
              // TODO: cacheExtent 是現在的workaround，不然 Scrollbar 會跳
              // https://github.com/flutter/flutter/issues/25652
              cacheExtent: 10000,
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: settingsGroups.length,
              itemBuilder: (context, index) {
                return settingsGroups[index];
              },
            ),
          ),
        );
      },
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingTile> children;
  const _SettingsGroup({required this.children});

  List<Widget> buildTiles(bool isDarkTheme) {
    final list = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      list.add(_SettingTile(
        iconData: children[i].iconData,
        title: children[i].title,
        color: children[i].color,
        onTap: children[i].onTap,
      ));
      if (i != children.length - 1) {
        list.add(Divider(
          thickness: 2,
          height: 1,
          color: isDarkTheme
              ? CustomColorThemes.borderColorDark
              : CustomColorThemes.borderColorLight,
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isDarkTheme
                  ? CustomColorThemes.borderColorDark
                  : CustomColorThemes.borderColorLight,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(children: buildTiles(isDarkTheme)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

enum _SettingTileColor {
  green,
  red,
  yellow,
  blue,
  blackOrWhite;
}

class _SettingTile extends StatelessWidget {
  final IconData iconData;
  final _SettingTileColor color;
  final String title;
  final VoidCallback onTap;

  const _SettingTile({
    required this.iconData,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late final Color iconColor;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final splashColor = isDarkTheme ? Colors.white24 : Colors.black26;

    iconColor = switch (color) {
      _SettingTileColor.green => const Color(0xff37970e),
      _SettingTileColor.red => const Color(0xfff5222d),
      _SettingTileColor.yellow => const Color(0xffd4b106),
      _SettingTileColor.blue => const Color(0xff2492f7),
      _SettingTileColor.blackOrWhite =>
        isDarkTheme ? const Color(0xfffafafa) : const Color(0xff333333),
    };

    return Material(
      clipBehavior: Clip.antiAlias,
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor.withOpacity(0.2),
        highlightColor: splashColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isDarkTheme
                        ? CustomColorThemes.borderColorDark
                        : CustomColorThemes.borderColorLight,
                    width: 1,
                  ),
                ),
                child: Icon(
                  iconData,
                  color: iconColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
