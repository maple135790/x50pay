import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/common/widgets/scaffold_with_nav_bar.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/page/pages.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/setting_repository.dart';
import 'package:x50pay/route/app_route.dart';

class AppRouter {
  /// 全域的 navigatorKey
  ///
  /// 在不特定頁面顯示 dialog 時使用
  static final rootNavigatorKey = GlobalKey<NavigatorState>(
    debugLabel: 'Global navigatorKey',
  );

  /// 路由設定
  late final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoute.home.path,
    redirect: (context, state) async {
      if (!context.read<LoginProvider>().isLoggedIn) {
        return AppRoute.login.path;
      }
      return null;
    },
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        routes: [
          _route(AppRoute.forgotPassword, (_, _) => const ForgotPassword()),
          _route(AppRoute.signUp, (_, _) => const SignUp()),
          _route(AppRoute.login, (_, _) => const Login()),
          _routeTransition(
            AppRoute.gameStore,
            (_, _) => const NoTransitionPage(child: GameStore()),
            redirect: gameStoreRedirect,
          ),
          _routeTransition(
            AppRoute.gameCabs,
            (_, state) {
              final shouldRebuild = state.extra as bool?;
              if (shouldRebuild ?? false) {
                return NoTransitionPage(
                  child: GameCabs(
                    key: ValueKey(DateTime.now().millisecondsSinceEpoch),
                  ),
                );
              }
              return const NoTransitionPage(child: GameCabs());
            },
            innerRoutes: [
              _routeTransition(AppRoute.gameCab, (_, state) {
                final machineId = state.pathParameters['mid']!;
                return CupertinoPage(child: CabDetail(machineId));
              }),
            ],
          ),
          _route(AppRoute.scanQRCode, (_, state) => const ScanQRCode()),
          _route(AppRoute.license, (_, _) => const License()),
          _routeTransition(
            AppRoute.settings,
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
              _routeTransition(AppRoute.padPref, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const PadPrefDialog(),
                  ),
                );
              }),
              _routeTransition(AppRoute.quicPayPref, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const QuiCPayPrefDialog(),
                  ),
                );
              }),
              _routeTransition(AppRoute.paymentPref, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const PaymentPrefDialog(),
                  ),
                );
              }),
              _routeTransition(AppRoute.changePassword, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const ChangePasswordDialog(),
                  ),
                );
              }),
              _routeTransition(AppRoute.changeEmail, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const ChangeEmailDialog(),
                  ),
                );
              }),
              _routeTransition(AppRoute.bidRecords, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const BidRecords(),
                  ),
                );
              }),
              _routeTransition(AppRoute.ticketRecords, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const TicketRecords(),
                  ),
                );
              }),
              _routeTransition(AppRoute.playRecords, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const PlayRecords(),
                  ),
                );
              }),
              _routeTransition(AppRoute.freePointRecords, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const FreePointRecords(),
                  ),
                );
              }),
              _routeTransition(AppRoute.ticketUsedRecords, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const TicketUsedRecords(),
                  ),
                );
              }),
              _routeTransition(AppRoute.x50PayAppSetting, (_, _) {
                return CupertinoPage(
                  child: ChangeNotifierProvider(
                    create: (context) {
                      final settingRepo = context.read<SettingRepository>();
                      return SettingsViewModel(settingRepo: settingRepo);
                    },
                    builder: (context, child) => const AppSettings(),
                  ),
                );
              }),
            ],
          ),
          _routeTransition(
            AppRoute.home,
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
              _route(AppRoute.ecPay, (_, state) => const EcPay()),
              _routeTransition(
                AppRoute.dressRoom,
                (_, _) => const CupertinoPage(child: DressRoom()),
              ),
              _routeTransition(
                AppRoute.buyMPass,
                (_, state) => const CupertinoPage(child: BuyMPass()),
              ),
              _route(AppRoute.questCampaign, (_, state) {
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
          _routeTransition(
            AppRoute.gift,
            (_, _) => const NoTransitionPage(child: GiftSystem()),
          ),
          _routeTransition(
            AppRoute.gradeBox,
            (_, _) => const NoTransitionPage(child: GradeBox()),
          ),
          _routeTransition(
            AppRoute.collab,
            (_, _) => const NoTransitionPage(child: Collab()),
          ),
        ],
        builder: (context, state, child) {
          if (AppRoute.noLoginPages.any(
            (p) => p.path == state.uri.toString(),
          )) {
            return child;
          }
          return ScaffoldWithNavBar(body: child);
        },
      ),
    ],
  );

  /// 遊戲頁面的重新導向邏輯
  ///
  /// 使用者選店時，會將 [store_id] 和 [store_name] 存入 [SharedPreferences] 中。
  ///
  /// 如果使用者有設定 [store_id] 或 [store_name]，則導向遊戲商店頁面。
  ///
  /// 若判定為須導向至遊戲商店頁面，則回傳 [AppRoute.gameCabs.path]，若判定為不須導向，則回傳 null。
  FutureOr<String?> gameStoreRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final storeId = await Prefs.getString(PrefsToken.storeId);
    final storeName = await Prefs.getString(PrefsToken.storeName);
    final shouldRedirect = storeId != null || storeName != null;
    if (shouldRedirect) return AppRoute.gameCabs.path;
    return null;
  }

  /// GoRouter 路由 wrapper
  GoRoute _route(
    AppRoute rp,
    GoRouterWidgetBuilder? builder, {
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
  GoRoute _routeTransition(
    AppRoute rp,
    GoRouterPageBuilder? pageBuilder, {
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
}
