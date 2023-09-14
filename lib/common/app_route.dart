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
  static const noLoginPages = [login, forgotPassword, signUp, license];

  static const login = (routeName: 'login', path: '/login');
  static const home = (routeName: 'home', path: '/home');
  static const dressRoom = (routeName: 'dressRoom', path: 'dressRoom');
  static const forgotPassword = (routeName: 'forgotPassword', path: '/iforgot');
  static const license = (routeName: 'license', path: '/lic');
  static const signUp = (routeName: 'signUp', path: '/signUp');
  static const buyMPass = (routeName: 'buyMPass', path: 'buyMPass');
  static const ecPay = (routeName: 'ecpay', path: 'ecpay');
  static const settings = (routeName: 'setting', path: '/setting');
  static const quicPayPref = (routeName: 'quicPayPref', path: 'quicPayPref');
  static const paymentPref = (routeName: 'paymentPref', path: 'paymentPref');
  static const padPref = (routeName: 'padPref', path: 'padPref');
  static const changePassword =
      (routeName: 'changePassword', path: 'changePassword');
  static const changeEmail = (routeName: 'changeEmail', path: 'changeEmail');
  static const bidRecords = (routeName: 'bidRecords', path: 'bidRecords');
  static const ticketRecords =
      (routeName: 'ticketRecords', path: 'ticketRecords');
  static const playRecords = (routeName: 'playRecords', path: 'playRecords');
  static const x50PayAppSetting =
      (routeName: 'x50PayAppSetting', path: 'x50PayAppSetting');
  static const ticketUsedRecords =
      (routeName: 'ticketUsedRecords', path: 'ticketUsedRecords');
  static const gameStore = (routeName: 'gameStore', path: '/game/store');
  static const gameCabs = (routeName: 'gameCabs', path: '/game/cabs');
  static const gameCab = (routeName: 'gameCab', path: ':mid');
  static const gift = (routeName: 'gift', path: '/gift');
  static const gradeBox = (routeName: 'gradeBox', path: '/gift/gradeBox');
  static const collab = (routeName: 'collab', path: '/collab');
  static const scanQRCode = (routeName: 'scanQRCode', path: '/scanQRCode');
  static const questCampaign =
      (routeName: 'questCampaign', path: 'questCampaign/:couid');
  static const qrPay = (routeName: 'qrPay', path: '/qrPay/:caboid/:sid');
  static const freePointRecords =
      (routeName: 'freePointRecords', path: 'freePointRecords');
}
