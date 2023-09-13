// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja_JP locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ja_JP';

  static String m0(continuousDay) => " ログイン日数 :  ${continuousDay} 日";

  static String m1(gatchaPoints) => " 抽選券 :  ${gatchaPoints} 点";

  static String m2(gr2LimitTimes) => "還元ポイント 25P / ${gr2LimitTimes} ";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "continuous": m0,
        "dialogReturn": MessageLookupByLibrary.simpleMessage("戻る"),
        "dialogSave": MessageLookupByLibrary.simpleMessage("セーフ"),
        "dressRoomTitle": MessageLookupByLibrary.simpleMessage("キャラ変更/着せ替え"),
        "gameDiscountHour": MessageLookupByLibrary.simpleMessage("オフピークタイム"),
        "gameLocation": MessageLookupByLibrary.simpleMessage("ロケーション"),
        "gameMPass": MessageLookupByLibrary.simpleMessage("お得パス"),
        "gameNormalHour": MessageLookupByLibrary.simpleMessage("ピークタイム"),
        "gameWeekday": MessageLookupByLibrary.simpleMessage("平日"),
        "gameWeekends": MessageLookupByLibrary.simpleMessage("休日"),
        "gatcha": m1,
        "gr2HeartBox": MessageLookupByLibrary.simpleMessage("絆ポイントショップ"),
        "gr2Limit": m2,
        "gr2ResetDate": MessageLookupByLibrary.simpleMessage(" シーズン変わる日 : "),
        "heart": MessageLookupByLibrary.simpleMessage(" 絆ランク"),
        "infoNotify": MessageLookupByLibrary.simpleMessage("最新イベント"),
        "loginEmail": MessageLookupByLibrary.simpleMessage("メールアドレス"),
        "loginError": MessageLookupByLibrary.simpleMessage("ログインエラー"),
        "loginForgotPassword":
            MessageLookupByLibrary.simpleMessage("パスワードを忘れたお方"),
        "loginLogin": MessageLookupByLibrary.simpleMessage("ログイン"),
        "loginPassword": MessageLookupByLibrary.simpleMessage("パスワード"),
        "loginSignUp": MessageLookupByLibrary.simpleMessage("会員登録"),
        "loginSub": MessageLookupByLibrary.simpleMessage("24時間年中無休"),
        "loginWelcome": MessageLookupByLibrary.simpleMessage("おかえりなさい！"),
        "monthlyPass": MessageLookupByLibrary.simpleMessage("お得パス : "),
        "mpassInvalid": MessageLookupByLibrary.simpleMessage("未購入"),
        "mpassValid": MessageLookupByLibrary.simpleMessage("購入済み"),
        "navCollab": MessageLookupByLibrary.simpleMessage("コラボ"),
        "navGame": MessageLookupByLibrary.simpleMessage("コインを入れる"),
        "navGift": MessageLookupByLibrary.simpleMessage("プレゼント"),
        "navSettings": MessageLookupByLibrary.simpleMessage("オプション"),
        "nextLv": MessageLookupByLibrary.simpleMessage("次のランク : "),
        "officialNotify": MessageLookupByLibrary.simpleMessage("公式インフォメーション"),
        "serviceError": MessageLookupByLibrary.simpleMessage(
            "サーバーエラー、ページをリロードもしくはスタッフまでお声掛けください。"),
        "ticketBalance": MessageLookupByLibrary.simpleMessage("抽選券 : "),
        "ticketUnit": MessageLookupByLibrary.simpleMessage(" "),
        "vipDate": MessageLookupByLibrary.simpleMessage("有効期限 : "),
        "vipExpiredMsg":
            MessageLookupByLibrary.simpleMessage("左側のアイコンをクリックして購入"),
        "x50PayLanguage": MessageLookupByLibrary.simpleMessage("X50Pay 言語")
      };
}
