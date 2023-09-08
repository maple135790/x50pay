import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/widgets/scaffold_with_nav_bar.dart';
import 'package:x50pay/page/account/account_view_model.dart';
import 'package:x50pay/page/pages.dart';

/// GoRouter 路由 wrapper
GoRoute _route(
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
GoRoute _routeTransition(
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
final debugRoute = AppRoutes.home.path;

/// 路由設定
RouterConfig<Object> goRouteConfig(bool isLogin) => GoRouter(
      initialLocation: kDebugMode && !GlobalSingleton.instance.isServiceOnline
          ? debugRoute
          : isLogin
              ? AppRoutes.home.path
              : AppRoutes.login.path,
      debugLogDiagnostics: true,
      routes: [
        ShellRoute(
          routes: [
            _route(AppRoutes.forgotPassword, (_, __) => const ForgotPassword()),
            _route(AppRoutes.signUp, (_, __) => const SignUp()),
            _route(AppRoutes.login, (_, __) => const Login()),
            _route(
              AppRoutes.gameStore,
              (_, __) => const GameStore(),
              redirect: gameStoreRedirect,
            ),
            _route(AppRoutes.gameCabs, (_, state) {
              final shouldRebuild = state.extra as bool?;
              if (shouldRebuild ?? false) {
                return GameCabs(
                    key: ValueKey(DateTime.now().millisecondsSinceEpoch));
              }
              return const GameCabs();
            }, innerRoutes: [
              _routeTransition(AppRoutes.gameCab, (_, state) {
                final machineId = state.pathParameters['mid']!;
                return CupertinoPage(child: CabDetail(machineId));
              }),
            ]),
            _route(
              AppRoutes.scanQRCode,
              (_, state) => ScanQRCode(state.extra as PermissionStatus),
            ),
            _route(AppRoutes.license, (_, __) => const License()),
            _route(
              AppRoutes.settings,
              (_, state) {
                final shouldGoPhone =
                    state.queryParameters['goTo'] == 'phoneChange';
                final shouldGoTicketRecord =
                    state.queryParameters['goTo'] == 'ticketRecord';

                log('shouldGoPhone: $shouldGoPhone');
                log('shouldGoTicketRecord: $shouldGoTicketRecord');
                return Account(
                  shouldGoPhone: shouldGoPhone,
                  shouldGoTicketRecord: shouldGoTicketRecord,
                );
              },
              innerRoutes: [
                _routeTransition(AppRoutes.padPref, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const PadPrefDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.quicPayPref, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const QuiCPayPrefDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.paymentPref, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const PaymentPrefDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.changePassword, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const ChangePasswordDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.changeEmail, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const ChangeEmailDialog(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.bidRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const BidRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.ticketRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const TicketRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.playRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const PlayRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.freePointRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const FreePRecords(),
                    ),
                  );
                }),
                _routeTransition(AppRoutes.ticketUsedRecords, (_, __) {
                  return CupertinoPage(
                    child: ChangeNotifierProvider(
                      create: (context) => AccountViewModel(),
                      builder: (context, child) => const TicketUsedRecords(),
                    ),
                  );
                }),
              ],
            ),
            _route(
              AppRoutes.home,
              (_, state) {
                final shouldRebuild = state.extra as bool?;
                if (shouldRebuild == true) {
                  return Home(
                      key: ValueKey(DateTime.now().millisecondsSinceEpoch));
                }
                return const Home();
              },
              innerRoutes: [
                _route(AppRoutes.ecPay, (_, state) => const EcPay()),
                _routeTransition(AppRoutes.dressRoom,
                    (_, __) => const CupertinoPage(child: DressRoom())),
                _route(AppRoutes.buyMPass, (_, state) => const BuyMPass()),
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
            _route(AppRoutes.gift, (_, __) => const GiftSystem()),
            _route(AppRoutes.gradeBox, (_, __) => const GradeBox()),
            _route(AppRoutes.collab, (_, __) => const Collab()),
          ],
          builder: (context, state, child) {
            if (AppRoutes.noLoginPages
                .any((p) => p.path == state.location.toString())) {
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
/// 若判定為須導向至遊戲商店頁面，則回傳 [AppRoutes.gameCabs.path]，若判定為不須導向，則回傳 null。
FutureOr<String?> gameStoreRedirect(context, state) async {
  final prefs = await SharedPreferences.getInstance();
  final shouldRedirect = prefs.getString('store_id') != null ||
      prefs.getString('store_name') != null;
  if (shouldRedirect) return AppRoutes.gameCabs.path;
  return null;
}
