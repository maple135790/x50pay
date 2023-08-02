@Deprecated("Use `AppRoutes` instead")
class AppRoute {
  static const login = '/login';
  static const home = '/home';
  static const forgotPassword = '/iforgot';
  static const license = '/lic';
  static const signUp = '/signUp';
  static const buyMPass = '/buyMPass';
  static const setting = '/setting';
  static const game = '/game';
  static const account = '/account';
  static const gift = '/gift';
  static const collab = '/collab';
}

typedef RouteProperty = ({String routeName, String path});

class AppRoutes {
  static const login = (routeName: 'login', path: '/login');
  static const home = (routeName: 'home', path: '/');
  static const forgotPassword = (routeName: 'forgotPassword', path: '/iforgot');
  static const license = (routeName: 'license', path: '/lic');
  static const signUp = (routeName: 'signUp', path: '/signUp');
  static const buyMPass = (routeName: 'buyMPass', path: 'buyMPass');
  static const settings = (routeName: 'setting', path: '/setting');
  static const game = (routeName: 'game', path: '/game');
  static const gameStore = (routeName: 'gameStore', path: 'store');
  static const gameCabs = (routeName: 'gameCabs', path: 'cabs/:storeName');
  static const gift = (routeName: 'gift', path: '/gift');
  static const collab = (routeName: 'collab', path: '/collab');
  static const questCampaign =
      (routeName: 'questCampaign', path: 'questCampaign/:couid');
}
