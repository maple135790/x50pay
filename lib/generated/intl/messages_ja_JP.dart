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

  static String m1(waitCount) => "X50Pad 並び状況 : ${waitCount} 人待ち";

  static String m2(gatchaPoints) => " 抽選券 :  ${gatchaPoints} 点";

  static String m3(gr2LimitTimes) => "還元ポイント 25P / ${gr2LimitTimes} ";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "continuous": m0,
        "dialogCancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "dialogConfirm": MessageLookupByLibrary.simpleMessage("OK"),
        "dialogNext": MessageLookupByLibrary.simpleMessage("次"),
        "dialogReturn": MessageLookupByLibrary.simpleMessage("戻る"),
        "dialogSave": MessageLookupByLibrary.simpleMessage("セーフ"),
        "dressRoomTitle": MessageLookupByLibrary.simpleMessage("キャラ変更/着せ替え"),
        "gameDiscountHour": MessageLookupByLibrary.simpleMessage("オフピークタイム"),
        "gameLocation": MessageLookupByLibrary.simpleMessage("ロケーション"),
        "gameMPass": MessageLookupByLibrary.simpleMessage("お得パス"),
        "gameNormalHour": MessageLookupByLibrary.simpleMessage("ピークタイム"),
        "gameTicket": MessageLookupByLibrary.simpleMessage("遊びチケット"),
        "gameUnlimit": MessageLookupByLibrary.simpleMessage("予約された無制限台があります"),
        "gameUnlimitTitle": MessageLookupByLibrary.simpleMessage("予約された時間帯"),
        "gameWait": m1,
        "gameWeekday": MessageLookupByLibrary.simpleMessage("平日"),
        "gameWeekends": MessageLookupByLibrary.simpleMessage("休日"),
        "gatcha": m2,
        "gr2HeartBox": MessageLookupByLibrary.simpleMessage("絆ポイントショップ"),
        "gr2Limit": m3,
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
        "navGame": MessageLookupByLibrary.simpleMessage("コインを\n  入れる"),
        "navGift": MessageLookupByLibrary.simpleMessage("プレゼント"),
        "navSettings": MessageLookupByLibrary.simpleMessage("オプション"),
        "nbusyCoin": MessageLookupByLibrary.simpleMessage("ゲーム中"),
        "nbusyNoCoin": MessageLookupByLibrary.simpleMessage("空いています"),
        "nbusyS1": MessageLookupByLibrary.simpleMessage("空いている"),
        "nbusyS2": MessageLookupByLibrary.simpleMessage("やや空いている"),
        "nbusyS3": MessageLookupByLibrary.simpleMessage("混雑中"),
        "nextLv": MessageLookupByLibrary.simpleMessage("次のランク : "),
        "officialNotify": MessageLookupByLibrary.simpleMessage("公式インフォメーション"),
        "serviceError": MessageLookupByLibrary.simpleMessage(
            "サーバーエラー、ページをリロードもしくはスタッフまでお声掛けください。"),
        "ticketBalance": MessageLookupByLibrary.simpleMessage("所持しているチケット : "),
        "ticketUnit": MessageLookupByLibrary.simpleMessage(" "),
        "userAppSettingsBiometrics":
            MessageLookupByLibrary.simpleMessage("生体認証ログイン"),
        "userAppSettingsBiometricsDisable":
            MessageLookupByLibrary.simpleMessage("生体認証ログイン解除"),
        "userAppSettingsBiometricsDisableContent":
            MessageLookupByLibrary.simpleMessage(
                "生体認証ログインを解除しますか？\n再利用の場合は、ログイン情報を再び入力します"),
        "userAppSettingsBiometricsEnableContent":
            MessageLookupByLibrary.simpleMessage(
                "注意：\n\nこの機能は、ログイン情報を暗号化して携帯電話に保存します。生体認証でログインすると、ログイン情報が自動的に入力されます。\n\nAndroid は KeyStore を使用して保存します。\niOS は KeyChain を使用して保存します。\n\nログイン情報を変更した場合は、再度設定する必要があります。\n\nこの機能を使用してもよろしいですか？"),
        "userAppSettingsBiometricsLoginCred":
            MessageLookupByLibrary.simpleMessage("ログイン情報"),
        "userAppSettingsBiometricsLoginCredContent":
            MessageLookupByLibrary.simpleMessage("ログイン情報を再入力してください"),
        "userAppSettingsBiometricsLoginTry":
            MessageLookupByLibrary.simpleMessage("ログインを試みる"),
        "userAppSettingsFastPayment":
            MessageLookupByLibrary.simpleMessage("高速化決済"),
        "userAppSettingsFastPaymentEnableContent":
            MessageLookupByLibrary.simpleMessage(
                "高速化決済は、Webベースの支払いプロセスとは異なります。コインを投入する際には、トークン認証は行われません。\n\n高速化決済を有効にしますか？"),
        "userAppSettingsFastPaymentEnableTitle":
            MessageLookupByLibrary.simpleMessage("高速化決済を有効化"),
        "userAvatar": MessageLookupByLibrary.simpleMessage("アイコン変更"),
        "userBidLog": MessageLookupByLibrary.simpleMessage("チャージ履歴"),
        "userEmail": MessageLookupByLibrary.simpleMessage("ユーザーメールアドレス変更"),
        "userFPlayLog": MessageLookupByLibrary.simpleMessage("還元履歴"),
        "userInAppSetting":
            MessageLookupByLibrary.simpleMessage("X50Pay アプリ設定"),
        "userLogout": MessageLookupByLibrary.simpleMessage("X50Payからログアウト"),
        "userNFC": MessageLookupByLibrary.simpleMessage("支払い設定"),
        "userOpenDoor1":
            MessageLookupByLibrary.simpleMessage("西門\"一号店\"のドアを開く"),
        "userOpenDoor2":
            MessageLookupByLibrary.simpleMessage("西門\"二号店\"のドアを開く"),
        "userPad": MessageLookupByLibrary.simpleMessage("オンライン並ぶ表示設定"),
        "userPassword": MessageLookupByLibrary.simpleMessage("ユーザーパスワード変更"),
        "userPhone": MessageLookupByLibrary.simpleMessage("ユーザー携帯番号変更"),
        "userPlayLog": MessageLookupByLibrary.simpleMessage("支払い履歴"),
        "userQUIC": MessageLookupByLibrary.simpleMessage("QUICアイコン変更"),
        "userTicLog": MessageLookupByLibrary.simpleMessage("所持チケット"),
        "userUTicLog": MessageLookupByLibrary.simpleMessage("チケット利用履歴"),
        "vipDate": MessageLookupByLibrary.simpleMessage("有効期限 : "),
        "vipExpiredMsg":
            MessageLookupByLibrary.simpleMessage("左側のアイコンをクリックして購入"),
        "x50PayLanguage": MessageLookupByLibrary.simpleMessage("X50Pay 言語")
      };
}
