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

  static String m0(day) => " ログイン日数 :  ${day} 日";

  static String m1(waitCount) => "X50Pad 並び状況 : ${waitCount} 人待ち";

  static String m2(point) => " 抽選券 :  ${point} 点";

  static String m3(limitTimes) => "還元ポイント 25P / ${limitTimes} ";

  static String m4(summaryGameRecordTimes, summaryGameRecordTotal) =>
      "${summaryGameRecordTimes}回、合計${summaryGameRecordTotal}";

  static String m5(pages) => "機能を有効にすると、以下のページにまとめた情報が表示されます。\n${pages}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "continuous": m0,
        "dialogCancel": MessageLookupByLibrary.simpleMessage("キャンセル"),
        "dialogConfirm": MessageLookupByLibrary.simpleMessage("OK"),
        "dialogNext": MessageLookupByLibrary.simpleMessage("次へ"),
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
        "loginBiometrics": MessageLookupByLibrary.simpleMessage("生体認証でログイン"),
        "loginBiometricsReason":
            MessageLookupByLibrary.simpleMessage("X50Pay App で生体認証を使用"),
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
        "msgNotify": MessageLookupByLibrary.simpleMessage("お知らせ"),
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
        "summaryGame": MessageLookupByLibrary.simpleMessage("機種別"),
        "summaryGameDetailed": MessageLookupByLibrary.simpleMessage("機種詳細"),
        "summaryGameFavGame": MessageLookupByLibrary.simpleMessage("メイン機種設定"),
        "summaryGameFavGameSetup":
            MessageLookupByLibrary.simpleMessage("メイン機種設定できます"),
        "summaryGameRecordRecord": m4,
        "summaryGameRecordTitle": MessageLookupByLibrary.simpleMessage("機種記録:"),
        "summaryHide": MessageLookupByLibrary.simpleMessage("非表示"),
        "summaryNoData": MessageLookupByLibrary.simpleMessage("データなし"),
        "summaryPeriod": MessageLookupByLibrary.simpleMessage("通算期間"),
        "summaryPeriod30": MessageLookupByLibrary.simpleMessage("30日"),
        "summaryPeriod60": MessageLookupByLibrary.simpleMessage("60日 (全て)"),
        "summaryPeriod7": MessageLookupByLibrary.simpleMessage("7日"),
        "summaryPoint": MessageLookupByLibrary.simpleMessage("使用済ポイント"),
        "summaryShow": MessageLookupByLibrary.simpleMessage("表示"),
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
        "userAppSettingsInAppNfc":
            MessageLookupByLibrary.simpleMessage("アプリ内の NFC タグ読み取り"),
        "userAppSettingsInAppNfcContent": MessageLookupByLibrary.simpleMessage(
            "店内にあるNFCタグをスキャンすると、アプリ内に支払い方法、支払い結果などを表示します。\n速度が遅い場合は、このオプションを無効にしてください。"),
        "userAppSettingsSummarizedRecord":
            MessageLookupByLibrary.simpleMessage("まとめた支払い履歴を表示"),
        "userAppSettingsSummarizedRecordContent": m5,
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
