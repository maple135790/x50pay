part of '../main.dart';

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

final debugRoute = AppRoutes.home.path;

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
              (_, __) => const Account(),
              innerRoutes: [
                _routeTransition(AppRoutes.padPref, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: PadPrefDialog(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.quicPayPref, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: QuiCPayPrefDialog(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.paymentPref, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: PaymentPrefDialog(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.changeEmail, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: ChangeEmailDialog(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.changePassword, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: ChangePasswordDialog(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.bidRecords, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: BidRecords(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.playRecords, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: PlayRecords(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.ticketRecords, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: TicketRecords(viewModel),
                  );
                }),
                _routeTransition(AppRoutes.ticketUsedRecords, (_, state) {
                  final viewModel = state.extra as AccountViewModel;
                  return CupertinoPage(
                    child: TicketUsedRecords(viewModel),
                  );
                }),
              ],
            ),
            _route(AppRoutes.home, (_, __) => const Home(), innerRoutes: [
              _route(AppRoutes.ecPay, (_, state) => const EcPay()),
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
            ]),
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

FutureOr<String?> gameStoreRedirect(context, state) async {
  final prefs = await SharedPreferences.getInstance();
  final shouldRedirect = prefs.getString('store_id') != null ||
      prefs.getString('store_name') != null;
  if (shouldRedirect) return AppRoutes.gameCabs.path;
  return null;
}
