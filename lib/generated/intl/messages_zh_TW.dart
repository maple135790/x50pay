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

  static String m0(continuousDay) => " 已簽到 : ${continuousDay} 天";

  static String m1(waitCount) => "X50Pad 排隊狀況 : ${waitCount} 人等待中";

  static String m2(gatchaPoints) => " 抽獎券 : 再 ${gatchaPoints} 點";

  static String m3(gr2LimitTimes) => " 每日回饋 ${gr2LimitTimes} 次 每次 25 P ";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "continuous": m0,
        "dialogReturn": MessageLookupByLibrary.simpleMessage("返回"),
        "dialogSave": MessageLookupByLibrary.simpleMessage("保存"),
        "dressRoomTitle": MessageLookupByLibrary.simpleMessage("更換角色/衣裝"),
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
        "serviceError":
            MessageLookupByLibrary.simpleMessage("伺服器錯誤，請嘗試重新整理或回報X50"),
        "ticketBalance": MessageLookupByLibrary.simpleMessage("券量 : "),
        "ticketUnit": MessageLookupByLibrary.simpleMessage("張"),
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
