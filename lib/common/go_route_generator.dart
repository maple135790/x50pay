import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/common/widgets/scaffold_with_nav_bar.dart';
import 'package:x50pay/page/pages.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/setting_repository.dart';

class AppRouter {
  /// GoRouter 路由 wrapper
  static GoRoute _route(
    RouteProperty rp,
    Widget Function(BuildContext, GoRouterState)? builder, {
    List<RouteBase>? innerRoutes,
    GoRouterRedirect? redirect,
  }) {
    return GoRoute(
      path: rp.path,
      name: rp.routeName,
      routes: innerRoutes ?? [],
      builder: builder,
      redirect: redirect,
    );
  }

  /// GoRouter 路由 wrapper
  ///
  /// 可提供跳轉時的轉場動畫
  static GoRoute _routeTransition(
    RouteProperty rp,
    Page<dynamic> Function(BuildContext, GoRouterState)? pageBuilder, {
    List<RouteBase>? innerRoutes,
    GoRouterRedirect? redirect,
  }) {
    return GoRoute(
      path: rp.path,
      name: rp.routeName,
      routes: innerRoutes ?? [],
      pageBuilder: pageBuilder,
      redirect: redirect,
    );
  }

  /// 開發用，設定初始路由
  static final debugRoute = AppRoutes.home.path;

  /// 路由設定
  static RouterConfig<Object> config(bool isInitiallyLogin) {
    final settingRepo = SettingRepository();

    final String realRoute;
    if (isInitiallyLogin) {
      realRoute = AppRoutes.home.path;
    } else {
      realRoute = AppRoutes.login.path;
    }

    return GoRouter(
      navigatorKey: GlobalSingleton.appNavigatorKey,
      initialLocation: kDebugMode && !GlobalSingleton.instance.isServiceOnline
          ? debugRoute
          : realRoute,
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          routes: [
            _route(AppRoutes.forgotPassword, (_, __) => const ForgotPassword()),
            _route(AppRoutes.signUp, (_, __) => const SignUp()),
            _route(AppRoutes.login, (_, __) => const Login()),
            _routeTransition(
              AppRoutes.gameStore,
              (_, __) => const NoTransitionPage(child: GameStore()),
              redirect: gameStoreRedirect,
            ),
            _routeTransition(AppRoutes.gameCabs, (_, state) {
              final shouldRebuild = state.extra as bool?;
              if (shouldRebuild ?? false) {
                return NoTransitionPage(
                  child: GameCabs(
                    key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                  ),
                );
              }
              return const NoTransitionPage(child: GameCabs());
            }, innerRoutes: [
              _routeTransition(AppRoutes.gameCab, (_, state) {
                final machineId = state.pathParameters['mid']!;
                return CupertinoPage(child: CabDetail(machineId));
              }),
            ]),
            _route(
              AppRoutes.scanQRCode,
              (_, state) => const ScanQRCode(),
            ),
            _route(AppRoutes.license, (_, __) => const License()),
            _routeTransition(
              AppRoutes.settings,
              (_, state) {
                final shouldGoPhone =
                    state.uri.queryParameters['goTo'] == 'phoneChange';
                final shouldGoTicketRecord =
                    state.uri.queryParameters['goTo'] == 'ticketRecord';

                log('shouldGoPhone: $shouldGoPhone');
                log('shouldGoTicketRecord: $shouldGoTicketRecord');
                return NoTransitionPage(
                  child: Settings(
                    shouldGoPhone: shouldGoPhone,
                    shouldGoTicketRecord: shouldGoTicketRecord,
                  ),
                );
              },
              innerRoutes: [
                _routeTransition(AppRoutes.padPref, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const PadPrefDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.quicPayPref, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const QuiCPayPrefDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.paymentPref, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const PaymentPrefDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.changePassword, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const ChangePasswordDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.changeEmail, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const ChangeEmailDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.bidRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const BidRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.ticketRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const TicketRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.playRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const PlayRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.freePointRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const FreePointRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.ticketUsedRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const TicketUsedRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.x50PayAppSetting, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) =>
                          SettingsViewModel(settingRepo: settingRepo),
                      builder: (context, child) => const AppSettings(),
                    ),
                  );
                }),
              ],
            ),
            _routeTransition(
              AppRoutes.home,
              (_, state) {
                final shouldRebuild = state.extra as bool?;
                if (shouldRebuild == true) {
                  return NoTransitionPage(
                    child: Home(
                      key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                    ),
                  );
                }
                return const NoTransitionPage(child: Home());
              },
              innerRoutes: [
                _route(AppRoutes.ecPay, (_, state) => const EcPay()),
                _routeTransition(AppRoutes.dressRoom,
                    (_, __) => const CupertinoPage(child: DressRoom())),
                _routeTransition(AppRoutes.buyMPass,
                    (_, state) => const CupertinoPage(child: BuyMPass())),
                _route(AppRoutes.questCampaign, (_, state) {
                  final shouldRebuild = state.extra as bool?;
                  if (shouldRebuild == true) {
                    return QuestCampaign(
                      key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                      campaignId: state.pathParameters['couid']!,
                    );
                  }
                  return QuestCampaign(
                    campaignId: state.pathParameters['couid']!,
                  );
                }),
              ],
            ),
            _routeTransition(AppRoutes.gift,
                (_, __) => const NoTransitionPage(child: GiftSystem())),
            _routeTransition(AppRoutes.gradeBox,
                (_, __) => const NoTransitionPage(child: GradeBox())),
            _routeTransition(AppRoutes.collab,
                (_, __) => const NoTransitionPage(child: Collab())),
          ],
          builder: (context, state, child) {
            if (AppRoutes.noLoginPages
                .any((p) => p.path == state.uri.toString())) {
              return child;
            }
            return ScaffoldWithNavBar(body: child);
          },
        ),
      ],
    );
  }

  /// 遊戲頁面的重新導向邏輯
  ///
  /// 使用者選店時，會將 [store_id] 和 [store_name] 存入 [SharedPreferences] 中。
  ///
  /// 如果使用者有設定 [store_id] 或 [store_name]，則導向遊戲商店頁面。
  ///
  /// 若判定為須導向至遊戲商店頁面，則回傳 [AppRoutes.gameCabs.path]，若判定為不須導向，則回傳 null。
  static FutureOr<String?> gameStoreRedirect(context, state) async {
    final storeId = await Prefs.getString(PrefsToken.storeId);
    final storeName = await Prefs.getString(PrefsToken.storeName);
    final shouldRedirect = storeId != null || storeName != null;
    if (shouldRedirect) return AppRoutes.gameCabs.path;
    return null;
  }
}
