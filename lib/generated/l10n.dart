// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// ` 已簽到 : {continuousDay} 天`
  String continuous(Object continuousDay) {
    return Intl.message(
      ' 已簽到 : $continuousDay 天',
      name: 'continuous',
      desc: '',
      args: [continuousDay],
    );
  }

  /// `返回`
  String get dialogReturn {
    return Intl.message(
      '返回',
      name: 'dialogReturn',
      desc: '',
      args: [],
    );
  }

  /// `保存`
  String get dialogSave {
    return Intl.message(
      '保存',
      name: 'dialogSave',
      desc: '',
      args: [],
    );
  }

  /// `更換角色/衣裝`
  String get dressRoomTitle {
    return Intl.message(
      '更換角色/衣裝',
      name: 'dressRoomTitle',
      desc: '',
      args: [],
    );
  }

  /// `離峰時段`
  String get gameDiscountHour {
    return Intl.message(
      '離峰時段',
      name: 'gameDiscountHour',
      desc: '',
      args: [],
    );
  }

  /// `目前所在`
  String get gameLocation {
    return Intl.message(
      '目前所在',
      name: 'gameLocation',
      desc: '',
      args: [],
    );
  }

  /// `月票`
  String get gameMPass {
    return Intl.message(
      '月票',
      name: 'gameMPass',
      desc: '',
      args: [],
    );
  }

  /// `通常時段`
  String get gameNormalHour {
    return Intl.message(
      '通常時段',
      name: 'gameNormalHour',
      desc: '',
      args: [],
    );
  }

  /// `平日`
  String get gameWeekday {
    return Intl.message(
      '平日',
      name: 'gameWeekday',
      desc: '',
      args: [],
    );
  }

  /// `假日`
  String get gameWeekends {
    return Intl.message(
      '假日',
      name: 'gameWeekends',
      desc: '',
      args: [],
    );
  }

  /// ` 抽獎券 : 再 {gatchaPoints} 點`
  String gatcha(Object gatchaPoints) {
    return Intl.message(
      ' 抽獎券 : 再 $gatchaPoints 點',
      name: 'gatcha',
      desc: '',
      args: [gatchaPoints],
    );
  }

  /// `養成點數商城`
  String get gr2HeartBox {
    return Intl.message(
      '養成點數商城',
      name: 'gr2HeartBox',
      desc: '',
      args: [],
    );
  }

  /// ` 每日回饋 {gr2LimitTimes} 次 每次 25 P `
  String gr2Limit(String gr2LimitTimes) {
    return Intl.message(
      ' 每日回饋 $gr2LimitTimes 次 每次 25 P ',
      name: 'gr2Limit',
      desc: '',
      args: [gr2LimitTimes],
    );
  }

  /// ` 換季日: `
  String get gr2ResetDate {
    return Intl.message(
      ' 換季日: ',
      name: 'gr2ResetDate',
      desc: '',
      args: [],
    );
  }

  /// ` 親密度 `
  String get heart {
    return Intl.message(
      ' 親密度 ',
      name: 'heart',
      desc: '',
      args: [],
    );
  }

  /// `最新活動`
  String get infoNotify {
    return Intl.message(
      '最新活動',
      name: 'infoNotify',
      desc: '',
      args: [],
    );
  }

  /// `電子郵件`
  String get loginEmail {
    return Intl.message(
      '電子郵件',
      name: 'loginEmail',
      desc: '',
      args: [],
    );
  }

  /// `登入錯誤`
  String get loginError {
    return Intl.message(
      '登入錯誤',
      name: 'loginError',
      desc: '',
      args: [],
    );
  }

  /// `忘記密碼嗎?`
  String get loginForgotPassword {
    return Intl.message(
      '忘記密碼嗎?',
      name: 'loginForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `登入`
  String get loginLogin {
    return Intl.message(
      '登入',
      name: 'loginLogin',
      desc: '',
      args: [],
    );
  }

  /// `密碼`
  String get loginPassword {
    return Intl.message(
      '密碼',
      name: 'loginPassword',
      desc: '',
      args: [],
    );
  }

  /// `註冊`
  String get loginSignUp {
    return Intl.message(
      '註冊',
      name: 'loginSignUp',
      desc: '',
      args: [],
    );
  }

  /// `24Hr 年中無休`
  String get loginSub {
    return Intl.message(
      '24Hr 年中無休',
      name: 'loginSub',
      desc: '',
      args: [],
    );
  }

  /// `歡迎回來!`
  String get loginWelcome {
    return Intl.message(
      '歡迎回來!',
      name: 'loginWelcome',
      desc: '',
      args: [],
    );
  }

  /// `月票 : `
  String get monthlyPass {
    return Intl.message(
      '月票 : ',
      name: 'monthlyPass',
      desc: '',
      args: [],
    );
  }

  /// `未購買`
  String get mpassInvalid {
    return Intl.message(
      '未購買',
      name: 'mpassInvalid',
      desc: '',
      args: [],
    );
  }

  /// `已購買`
  String get mpassValid {
    return Intl.message(
      '已購買',
      name: 'mpassValid',
      desc: '',
      args: [],
    );
  }

  /// `合作`
  String get navCollab {
    return Intl.message(
      '合作',
      name: 'navCollab',
      desc: '',
      args: [],
    );
  }

  /// `投幣`
  String get navGame {
    return Intl.message(
      '投幣',
      name: 'navGame',
      desc: '',
      args: [],
    );
  }

  /// `禮物`
  String get navGift {
    return Intl.message(
      '禮物',
      name: 'navGift',
      desc: '',
      args: [],
    );
  }

  /// `設定`
  String get navSettings {
    return Intl.message(
      '設定',
      name: 'navSettings',
      desc: '',
      args: [],
    );
  }

  /// `下一階 : `
  String get nextLv {
    return Intl.message(
      '下一階 : ',
      name: 'nextLv',
      desc: '',
      args: [],
    );
  }

  /// `官方資訊`
  String get officialNotify {
    return Intl.message(
      '官方資訊',
      name: 'officialNotify',
      desc: '',
      args: [],
    );
  }

  /// `伺服器錯誤，請嘗試重新整理或回報X50`
  String get serviceError {
    return Intl.message(
      '伺服器錯誤，請嘗試重新整理或回報X50',
      name: 'serviceError',
      desc: '',
      args: [],
    );
  }

  /// `券量 : `
  String get ticketBalance {
    return Intl.message(
      '券量 : ',
      name: 'ticketBalance',
      desc: '',
      args: [],
    );
  }

  /// `張`
  String get ticketUnit {
    return Intl.message(
      '張',
      name: 'ticketUnit',
      desc: '',
      args: [],
    );
  }

  /// `期限 : `
  String get vipDate {
    return Intl.message(
      '期限 : ',
      name: 'vipDate',
      desc: '',
      args: [],
    );
  }

  /// `點左側票券圖樣立刻購買`
  String get vipExpiredMsg {
    return Intl.message(
      '點左側票券圖樣立刻購買',
      name: 'vipExpiredMsg',
      desc: '',
      args: [],
    );
  }

  /// `X50Pay 語言`
  String get x50PayLanguage {
    return Intl.message(
      'X50Pay 語言',
      name: 'x50PayLanguage',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
      Locale.fromSubtags(languageCode: 'en', countryCode: 'US'),
      Locale.fromSubtags(languageCode: 'ja', countryCode: 'JP'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
