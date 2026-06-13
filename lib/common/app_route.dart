enum AppRoutes {
  login(routeName: 'login', path: '/login'),
  home(routeName: 'home', path: '/home'),
  dressRoom(routeName: 'dressRoom', path: 'dressRoom'),
  forgotPassword(routeName: 'forgotPassword', path: '/iforgot'),
  license(routeName: 'license', path: '/lic'),
  signUp(routeName: 'signUp', path: '/signUp'),
  buyMPass(routeName: 'buyMPass', path: 'buyMPass'),
  ecPay(routeName: 'ecpay', path: 'ecpay'),
  settings(routeName: 'setting', path: '/setting'),
  quicPayPref(routeName: 'quicPayPref', path: 'quicPayPref'),
  paymentPref(routeName: 'paymentPref', path: 'paymentPref'),
  padPref(routeName: 'padPref', path: 'padPref'),
  changePassword(routeName: 'changePassword', path: 'changePassword'),
  changeEmail(routeName: 'changeEmail', path: 'changeEmail'),
  bidRecords(routeName: 'bidRecords', path: 'bidRecords'),
  ticketRecords(routeName: 'ticketRecords', path: 'ticketRecords'),
  playRecords(routeName: 'playRecords', path: 'playRecords'),
  x50PayAppSetting(routeName: 'x50PayAppSetting', path: 'x50PayAppSetting'),
  ticketUsedRecords(routeName: 'ticketUsedRecords', path: 'ticketUsedRecords'),
  gameStore(routeName: 'gameStore', path: '/game/store'),
  gameCabs(routeName: 'gameCabs', path: '/game/cabs'),
  gameCab(routeName: 'gameCab', path: ':mid'),
  gift(routeName: 'gift', path: '/gift'),
  gradeBox(routeName: 'gradeBox', path: '/gift/gradeBox'),
  collab(routeName: 'collab', path: '/collab'),
  scanQRCode(routeName: 'scanQRCode', path: '/scanQRCode'),
  questCampaign(routeName: 'questCampaign', path: 'questCampaign/:couid'),
  qrPay(routeName: 'qrPay', path: '/qrPay/:caboid/:sid'),
  freePointRecords(routeName: 'freePointRecords', path: 'freePointRecords');

  static const noLoginPages = [login, forgotPassword, signUp, license];

  final String routeName;
  final String path;

  const AppRoutes({required this.routeName, required this.path});
}
