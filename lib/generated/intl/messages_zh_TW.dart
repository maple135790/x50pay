// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_TW locale. All the
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
  String get localeName => 'zh_TW';

  static String m0(day) => " 已簽到 : ${day} 天";

  static String m1(waitCount) => "X50Pad 排隊狀況 : ${waitCount} 人等待中";

  static String m2(point) => " 抽獎券 : 再 ${point} 點";

  static String m3(limitTimes) => " 每日回饋 ${limitTimes} 次 每次 25 P ";

  static String m4(summaryGameRecordTimes, summaryGameRecordTotal) =>
      "${summaryGameRecordTimes}次，共${summaryGameRecordTotal}";

  static String m5(pages) => "開啟功能後，會在以下頁面顯示統整過後的資訊。\n${pages}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addFavGameSubtitle":
            MessageLookupByLibrary.simpleMessage("選擇自己經常遊玩的機臺！"),
        "addFavGameTitle": MessageLookupByLibrary.simpleMessage("立即釘選機臺"),
        "changeFavGameSubtitle":
            MessageLookupByLibrary.simpleMessage("重新選擇釘選的機臺"),
        "changeFavGameTitle": MessageLookupByLibrary.simpleMessage("重新釘選機臺"),
        "continuous": m0,
        "dialogCancel": MessageLookupByLibrary.simpleMessage("取消"),
        "dialogConfirm": MessageLookupByLibrary.simpleMessage("確定"),
        "dialogNext": MessageLookupByLibrary.simpleMessage("下一步"),
        "dialogReturn": MessageLookupByLibrary.simpleMessage("返回"),
        "dialogSave": MessageLookupByLibrary.simpleMessage("保存"),
        "dressRoomTitle": MessageLookupByLibrary.simpleMessage("更換角色/衣裝"),
        "gameCabTileLarge": MessageLookupByLibrary.simpleMessage("大"),
        "gameCabTileSmall": MessageLookupByLibrary.simpleMessage("小"),
        "gameDiscountHour": MessageLookupByLibrary.simpleMessage("離峰時段"),
        "gameLocation": MessageLookupByLibrary.simpleMessage("目前所在"),
        "gameMPass": MessageLookupByLibrary.simpleMessage("月票"),
        "gameNormalHour": MessageLookupByLibrary.simpleMessage("通常時段"),
        "gameTicket": MessageLookupByLibrary.simpleMessage("遊玩券"),
        "gameUnlimit": MessageLookupByLibrary.simpleMessage("該機種當周有無限制台預約"),
        "gameUnlimitTitle": MessageLookupByLibrary.simpleMessage("已預約時段"),
        "gameWait": m1,
        "gameWeekday": MessageLookupByLibrary.simpleMessage("平日"),
        "gameWeekends": MessageLookupByLibrary.simpleMessage("假日"),
        "gatcha": m2,
        "gr2HeartBox": MessageLookupByLibrary.simpleMessage("養成點數商城"),
        "gr2Limit": m3,
        "gr2ResetDate": MessageLookupByLibrary.simpleMessage(" 換季日: "),
        "heart": MessageLookupByLibrary.simpleMessage(" 親密度 "),
        "infoNotify": MessageLookupByLibrary.simpleMessage("最新活動"),
        "loginBiometrics": MessageLookupByLibrary.simpleMessage("使用生物辨識登入"),
        "loginBiometricsReason":
            MessageLookupByLibrary.simpleMessage("使用生物辨識登入 X50Pay"),
        "loginEmail": MessageLookupByLibrary.simpleMessage("電子郵件"),
        "loginError": MessageLookupByLibrary.simpleMessage("登入錯誤"),
        "loginForgotPassword": MessageLookupByLibrary.simpleMessage("忘記密碼嗎?"),
        "loginLogin": MessageLookupByLibrary.simpleMessage("登入"),
        "loginPassword": MessageLookupByLibrary.simpleMessage("密碼"),
        "loginSignUp": MessageLookupByLibrary.simpleMessage("註冊"),
        "loginSub": MessageLookupByLibrary.simpleMessage("24Hr 年中無休"),
        "loginWelcome": MessageLookupByLibrary.simpleMessage("歡迎回來!"),
        "monthlyPass": MessageLookupByLibrary.simpleMessage("月票 : "),
        "mpassInvalid": MessageLookupByLibrary.simpleMessage("未購買"),
        "mpassValid": MessageLookupByLibrary.simpleMessage("已購買"),
        "msgNotify": MessageLookupByLibrary.simpleMessage("訊息告知"),
        "navCollab": MessageLookupByLibrary.simpleMessage("合作"),
        "navGame": MessageLookupByLibrary.simpleMessage("投幣"),
        "navGift": MessageLookupByLibrary.simpleMessage("禮物"),
        "navSettings": MessageLookupByLibrary.simpleMessage("設定"),
        "nbusyCoin": MessageLookupByLibrary.simpleMessage("已投幣"),
        "nbusyNoCoin": MessageLookupByLibrary.simpleMessage("未投幣"),
        "nbusyS1": MessageLookupByLibrary.simpleMessage("空閒"),
        "nbusyS2": MessageLookupByLibrary.simpleMessage("適中"),
        "nbusyS3": MessageLookupByLibrary.simpleMessage("忙碌"),
        "nextLv": MessageLookupByLibrary.simpleMessage("下一階 : "),
        "officialNotify": MessageLookupByLibrary.simpleMessage("官方資訊"),
        "pinnedGame": MessageLookupByLibrary.simpleMessage("釘選機臺"),
        "serviceError":
            MessageLookupByLibrary.simpleMessage("伺服器錯誤，請嘗試重新整理或回報X50"),
        "setFavGameTitle": MessageLookupByLibrary.simpleMessage("設定喜好機臺"),
        "summaryGame": MessageLookupByLibrary.simpleMessage("機種別"),
        "summaryGameDetailed": MessageLookupByLibrary.simpleMessage("詳細機種別"),
        "summaryGameFavGame": MessageLookupByLibrary.simpleMessage("喜好機台"),
        "summaryGameFavGameSetup":
            MessageLookupByLibrary.simpleMessage("可設定喜好機台"),
        "summaryGameNoData":
            MessageLookupByLibrary.simpleMessage("計算期間內無遊玩紀錄，請重新選擇計算期間"),
        "summaryGameRecordRecord": m4,
        "summaryGameRecordTitle":
            MessageLookupByLibrary.simpleMessage("機種別紀錄:"),
        "summaryHide": MessageLookupByLibrary.simpleMessage("隱藏"),
        "summaryNoData": MessageLookupByLibrary.simpleMessage("無資料"),
        "summaryPeriod": MessageLookupByLibrary.simpleMessage("計算期間"),
        "summaryPeriod30": MessageLookupByLibrary.simpleMessage("30天"),
        "summaryPeriod60": MessageLookupByLibrary.simpleMessage("60天"),
        "summaryPeriod7": MessageLookupByLibrary.simpleMessage("7天"),
        "summaryPeriodAll": MessageLookupByLibrary.simpleMessage("全期間"),
        "summaryPoint": MessageLookupByLibrary.simpleMessage("使用點數"),
        "summaryShow": MessageLookupByLibrary.simpleMessage("顯示"),
        "ticketBalance": MessageLookupByLibrary.simpleMessage("券量 : "),
        "ticketUnit": MessageLookupByLibrary.simpleMessage("張"),
        "userAppSettingsAccentColor":
            MessageLookupByLibrary.simpleMessage("主題色"),
        "userAppSettingsBiometrics":
            MessageLookupByLibrary.simpleMessage("生物辨識登入"),
        "userAppSettingsBiometricsDisable":
            MessageLookupByLibrary.simpleMessage("取消生物辨識登入"),
        "userAppSettingsBiometricsDisableContent":
            MessageLookupByLibrary.simpleMessage(
                "確定要取消生物辨識登入嗎？\n再次開啟需要重新輸入登入資訊"),
        "userAppSettingsBiometricsEnableContent":
            MessageLookupByLibrary.simpleMessage(
                "注意:\n此功能會將您的帳號密碼加密儲存於手機中，用生物辨識登入時會自動填入帳號密碼。\n\nAndroid 使用 KeyStore 儲存\niOS 使用 KeyChain 儲存。\n\n如果帳號密碼有更換，需要再次重新設定。\n\n確定使用此功能嗎？"),
        "userAppSettingsBiometricsLoginCred":
            MessageLookupByLibrary.simpleMessage("登入資訊"),
        "userAppSettingsBiometricsLoginCredContent":
            MessageLookupByLibrary.simpleMessage("再次輸入帳號密碼"),
        "userAppSettingsBiometricsLoginTry":
            MessageLookupByLibrary.simpleMessage("嘗試登入"),
        "userAppSettingsCardEmulationInterval":
            MessageLookupByLibrary.simpleMessage("卡片模擬間隔"),
        "userAppSettingsEnableDarkTheme":
            MessageLookupByLibrary.simpleMessage("深色主題"),
        "userAppSettingsFastPayment":
            MessageLookupByLibrary.simpleMessage("快速支付"),
        "userAppSettingsFastPaymentEnableContent":
            MessageLookupByLibrary.simpleMessage(
                "快速支付流程有別於網頁版的支付流程，投幣時不會做 Token 驗證\n\n確定開啟快速支付流程？"),
        "userAppSettingsFastPaymentEnableTitle":
            MessageLookupByLibrary.simpleMessage("開啟快速支付"),
        "userAppSettingsGameCabTileStyle":
            MessageLookupByLibrary.simpleMessage("遊戲磚大小"),
        "userAppSettingsInAppNfc":
            MessageLookupByLibrary.simpleMessage("App 內 NFC 標籤掃描"),
        "userAppSettingsInAppNfcContent": MessageLookupByLibrary.simpleMessage(
            "掃描到店內的 NFC 標籤時，在 App 內顯示支付方式、支付結果等。\n若速度過慢，請取消此選項"),
        "userAppSettingsRememberGameTabInfo":
            MessageLookupByLibrary.simpleMessage(
                "如果開啟，則進入投幣頁面時會顯示上次離開的分頁。\n若關閉，則每次進入都會顯示釘選遊戲頁\n預設為關閉"),
        "userAppSettingsRememberGameTabTitle":
            MessageLookupByLibrary.simpleMessage("紀錄上次的投幣標籤頁面"),
        "userAppSettingsResetTheme":
            MessageLookupByLibrary.simpleMessage("重設主題"),
        "userAppSettingsSummarizedRecord":
            MessageLookupByLibrary.simpleMessage("顯示遊玩紀錄統計"),
        "userAppSettingsSummarizedRecordContent": m5,
        "userAvatar": MessageLookupByLibrary.simpleMessage("修改顯示頭貼"),
        "userBidLog": MessageLookupByLibrary.simpleMessage("店鋪儲值紀錄"),
        "userEmail": MessageLookupByLibrary.simpleMessage("更改使用者信箱"),
        "userFPlayLog": MessageLookupByLibrary.simpleMessage("回饋點數紀錄"),
        "userInAppSetting":
            MessageLookupByLibrary.simpleMessage("X50Pay App 設定"),
        "userLogout": MessageLookupByLibrary.simpleMessage("登出 X50Pay"),
        "userNFC": MessageLookupByLibrary.simpleMessage("多元付款設定"),
        "userOpenDoor1": MessageLookupByLibrary.simpleMessage("西門\"一店\"開門"),
        "userOpenDoor2": MessageLookupByLibrary.simpleMessage("西門\"二店\"開門"),
        "userPad": MessageLookupByLibrary.simpleMessage("線上排隊設定"),
        "userPassword": MessageLookupByLibrary.simpleMessage("更改使用者密碼"),
        "userPhone": MessageLookupByLibrary.simpleMessage("更改使用者手機"),
        "userPlayLog": MessageLookupByLibrary.simpleMessage("付費遊玩紀錄"),
        "userQUIC": MessageLookupByLibrary.simpleMessage("QuIC付款設定"),
        "userTicLog": MessageLookupByLibrary.simpleMessage("未使用券紀錄"),
        "userUTicLog": MessageLookupByLibrary.simpleMessage("已使用券明細"),
        "vipDate": MessageLookupByLibrary.simpleMessage("期限 : "),
        "vipExpiredMsg": MessageLookupByLibrary.simpleMessage("點左側票券圖樣立刻購買"),
        "x50PayLanguage": MessageLookupByLibrary.simpleMessage("X50Pay 語言")
      };
}
