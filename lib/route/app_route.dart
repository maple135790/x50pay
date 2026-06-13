enum AppRoute {
  login('login', path: '/login'),
  home('home', path: '/home'),
  dressRoom('dressRoom', path: 'dressRoom'),
  forgotPassword('forgotPassword', path: '/iforgot'),
  license('license', path: '/lic'),
  signUp('signUp', path: '/signUp'),
  buyMPass('buyMPass', path: 'buyMPass'),
  ecPay('ecpay', path: 'ecpay'),
  settings('setting', path: '/setting'),
  quicPayPref('quicPayPref', path: 'quicPayPref'),
  paymentPref('paymentPref', path: 'paymentPref'),
  padPref('padPref', path: 'padPref'),
  changePassword('changePassword', path: 'changePassword'),
  changeEmail('changeEmail', path: 'changeEmail'),
  bidRecords('bidRecords', path: 'bidRecords'),
  ticketRecords('ticketRecords', path: 'ticketRecords'),
  playRecords('playRecords', path: 'playRecords'),
  x50PayAppSetting('x50PayAppSetting', path: 'x50PayAppSetting'),
  ticketUsedRecords('ticketUsedRecords', path: 'ticketUsedRecords'),
  gameStore('gameStore', path: '/game/store'),
  gameCabs('gameCabs', path: '/game/cabs'),
  gameCab('gameCab', path: ':mid'),
  gift('gift', path: '/gift'),
  gradeBox('gradeBox', path: '/gift/gradeBox'),
  collab('collab', path: '/collab'),
  scanQRCode('scanQRCode', path: '/scanQRCode'),
  questCampaign('questCampaign', path: 'questCampaign/:couid'),
  qrPay('qrPay', path: '/qrPay/:caboid/:sid'),
  freePointRecords('freePointRecords', path: 'freePointRecords');

  static const noLoginPages = [login, forgotPassword, signUp, license];

  final String routeName;
  final String path;

  const AppRoute(this.routeName, {required this.path});
}
