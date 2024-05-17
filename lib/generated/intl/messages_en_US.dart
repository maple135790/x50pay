// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en_US locale. All the
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
  String get localeName => 'en_US';

  static String m0(day) => " Continuous : ${day} days";

  static String m1(waitCount) => "X50Pad queue status : ${waitCount} waiting";

  static String m2(point) => " Gatcha : ${point} points";

  static String m3(limitTimes) => " Point back ${limitTimes} times , 25P/t";

  static String m4(summaryGameRecordTimes, summaryGameRecordTotal) =>
      "${summaryGameRecordTimes} times, total ${summaryGameRecordTotal}";

  static String m5(pages) =>
      "After enabling the function, the summarized information will be displayed on the following page.\n${pages}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "continuous": m0,
        "dialogCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "dialogConfirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "dialogNext": MessageLookupByLibrary.simpleMessage("Next"),
        "dialogReturn": MessageLookupByLibrary.simpleMessage("Return"),
        "dialogSave": MessageLookupByLibrary.simpleMessage("Save"),
        "dressRoomTitle":
            MessageLookupByLibrary.simpleMessage("Change avater/clothes"),
        "gameCabTileLarge": MessageLookupByLibrary.simpleMessage("Large"),
        "gameCabTileSmall": MessageLookupByLibrary.simpleMessage("Small"),
        "gameDiscountHour": MessageLookupByLibrary.simpleMessage("Discount"),
        "gameLocation": MessageLookupByLibrary.simpleMessage("Your Location"),
        "gameMPass": MessageLookupByLibrary.simpleMessage("Monthly Pass"),
        "gameNormalHour": MessageLookupByLibrary.simpleMessage("Normal"),
        "gameTicket": MessageLookupByLibrary.simpleMessage("Ticket"),
        "gameUnlimit": MessageLookupByLibrary.simpleMessage(
            "This game have reservation at this week"),
        "gameUnlimitTitle": MessageLookupByLibrary.simpleMessage(
            "Already reservation datetime"),
        "gameWait": m1,
        "gameWeekday": MessageLookupByLibrary.simpleMessage("Weekday"),
        "gameWeekends": MessageLookupByLibrary.simpleMessage("Weekends"),
        "gatcha": m2,
        "gr2HeartBox": MessageLookupByLibrary.simpleMessage("Hearts Shop"),
        "gr2Limit": m3,
        "gr2ResetDate": MessageLookupByLibrary.simpleMessage(" Reset Date : "),
        "heart": MessageLookupByLibrary.simpleMessage(" Hearts"),
        "infoNotify": MessageLookupByLibrary.simpleMessage("Informations"),
        "loginBiometrics":
            MessageLookupByLibrary.simpleMessage("Biometric Login"),
        "loginBiometricsReason": MessageLookupByLibrary.simpleMessage(
            "Using Biometrics to login X50Pay app"),
        "loginEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "loginError": MessageLookupByLibrary.simpleMessage("Login Error!"),
        "loginForgotPassword": MessageLookupByLibrary.simpleMessage("Forgot?"),
        "loginLogin": MessageLookupByLibrary.simpleMessage("Login"),
        "loginPassword": MessageLookupByLibrary.simpleMessage("Password"),
        "loginSignUp":
            MessageLookupByLibrary.simpleMessage("Not have account ?"),
        "loginSub": MessageLookupByLibrary.simpleMessage("24Hr Open."),
        "loginWelcome": MessageLookupByLibrary.simpleMessage("Welcome Back !"),
        "monthlyPass": MessageLookupByLibrary.simpleMessage("Monthly Pass : "),
        "mpassInvalid": MessageLookupByLibrary.simpleMessage("Buy it Now!"),
        "mpassValid": MessageLookupByLibrary.simpleMessage("Owned"),
        "msgNotify": MessageLookupByLibrary.simpleMessage("Events"),
        "navCollab": MessageLookupByLibrary.simpleMessage("Collab"),
        "navGame": MessageLookupByLibrary.simpleMessage("Game"),
        "navGift": MessageLookupByLibrary.simpleMessage("Gift"),
        "navSettings": MessageLookupByLibrary.simpleMessage("Settings"),
        "nbusyCoin": MessageLookupByLibrary.simpleMessage("Coined"),
        "nbusyNoCoin": MessageLookupByLibrary.simpleMessage("Not Coined"),
        "nbusyS1": MessageLookupByLibrary.simpleMessage("Idle"),
        "nbusyS2": MessageLookupByLibrary.simpleMessage("Normal"),
        "nbusyS3": MessageLookupByLibrary.simpleMessage("Busy"),
        "nextLv": MessageLookupByLibrary.simpleMessage(" Next Lv : "),
        "officialNotify": MessageLookupByLibrary.simpleMessage("Offical ADs"),
        "serviceError": MessageLookupByLibrary.simpleMessage(
            "Server error, Please retry again."),
        "summaryGame": MessageLookupByLibrary.simpleMessage("Game"),
        "summaryGameDetailed": MessageLookupByLibrary.simpleMessage("Game"),
        "summaryGameFavGame":
            MessageLookupByLibrary.simpleMessage("Favorite Game"),
        "summaryGameFavGameSetup":
            MessageLookupByLibrary.simpleMessage("Not Set Favorite Game Yet"),
        "summaryGameNoData": MessageLookupByLibrary.simpleMessage(
            "No play record found in the calculation period. Please select another calculation period"),
        "summaryGameRecordRecord": m4,
        "summaryGameRecordTitle":
            MessageLookupByLibrary.simpleMessage("Game Record:"),
        "summaryHide": MessageLookupByLibrary.simpleMessage("Hide"),
        "summaryNoData": MessageLookupByLibrary.simpleMessage("No Data"),
        "summaryPeriod":
            MessageLookupByLibrary.simpleMessage("Calculation Period"),
        "summaryPeriod30": MessageLookupByLibrary.simpleMessage("30 Days"),
        "summaryPeriod60": MessageLookupByLibrary.simpleMessage("60 Days"),
        "summaryPeriod7": MessageLookupByLibrary.simpleMessage("7 Days"),
        "summaryPoint": MessageLookupByLibrary.simpleMessage("Used Point"),
        "summaryShow": MessageLookupByLibrary.simpleMessage("Show"),
        "ticketBalance":
            MessageLookupByLibrary.simpleMessage("Ticket Balance : "),
        "ticketUnit": MessageLookupByLibrary.simpleMessage(" "),
        "userAppSettingsAccentColor":
            MessageLookupByLibrary.simpleMessage("Accent Color"),
        "userAppSettingsBiometrics":
            MessageLookupByLibrary.simpleMessage("Biometrics login"),
        "userAppSettingsBiometricsDisable":
            MessageLookupByLibrary.simpleMessage("Disable Biometrics login"),
        "userAppSettingsBiometricsDisableContent":
            MessageLookupByLibrary.simpleMessage(
                "You are going to disable Biomertrics Login.\nYou will be prompt to enter your login credentials in order to re-enable it."),
        "userAppSettingsBiometricsEnableContent":
            MessageLookupByLibrary.simpleMessage(
                "Attention:\n\nThis feature will encrypt and store your login credentials on your phone. When you log in with biometrics, your account and password will be automatically filled in.\n\nAndroid uses KeyStore to store.\niOS uses KeyChain to store.\n\nIf your login credentials is changed, you need to reset it again.\n\nAre you sure you want to use this feature?"),
        "userAppSettingsBiometricsLoginCred":
            MessageLookupByLibrary.simpleMessage("Login Credentials"),
        "userAppSettingsBiometricsLoginCredContent":
            MessageLookupByLibrary.simpleMessage(
                "Enter your login credentials again"),
        "userAppSettingsBiometricsLoginTry":
            MessageLookupByLibrary.simpleMessage("Try to log in"),
        "userAppSettingsCardEmulationInterval":
            MessageLookupByLibrary.simpleMessage("Card Emulation Interval"),
        "userAppSettingsEnableDarkTheme":
            MessageLookupByLibrary.simpleMessage("Dark Theme"),
        "userAppSettingsFastPayment":
            MessageLookupByLibrary.simpleMessage("Fast payment"),
        "userAppSettingsFastPaymentEnableContent":
            MessageLookupByLibrary.simpleMessage(
                "The Fast Payment feature is different from the web-based payment process. No token verification will be performed when coins are deposited.\n\nAre you sure you want to enable the quick payment process?"),
        "userAppSettingsFastPaymentEnableTitle":
            MessageLookupByLibrary.simpleMessage("Enable Fast Payment"),
        "userAppSettingsGameCabTileStyle":
            MessageLookupByLibrary.simpleMessage("Game tile size"),
        "userAppSettingsInAppNfc":
            MessageLookupByLibrary.simpleMessage("In-App NFC tag read"),
        "userAppSettingsInAppNfcContent": MessageLookupByLibrary.simpleMessage(
            "When scanning NFC tags in the store, show payment methods, payment results dialog, etc. in the app.\nIf the speed is slow, please disable this option."),
        "userAppSettingsRememberGameTabInfo": MessageLookupByLibrary.simpleMessage(
            "If enabled, the last visited tab will be displayed when entering the Game page.\nIf disabled, the Pinned Game tab will be displayed each time you enter.\nDefault is disabled."),
        "userAppSettingsRememberGameTabTitle":
            MessageLookupByLibrary.simpleMessage(
                "Remember the last tab in Game page"),
        "userAppSettingsResetTheme":
            MessageLookupByLibrary.simpleMessage("Reset Theme"),
        "userAppSettingsSummarizedRecord": MessageLookupByLibrary.simpleMessage(
            "Show summarized used point record"),
        "userAppSettingsSummarizedRecordContent": m5,
        "userAvatar": MessageLookupByLibrary.simpleMessage("Change Gravator"),
        "userBidLog": MessageLookupByLibrary.simpleMessage("Top-up history"),
        "userEmail": MessageLookupByLibrary.simpleMessage("Change user E-mail"),
        "userFPlayLog":
            MessageLookupByLibrary.simpleMessage("Cashback history"),
        "userInAppSetting":
            MessageLookupByLibrary.simpleMessage("X50Pay App Settings"),
        "userLogout": MessageLookupByLibrary.simpleMessage("Logout X50Pay"),
        "userNFC":
            MessageLookupByLibrary.simpleMessage("Multi Payment Setting"),
        "userOpenDoor1":
            MessageLookupByLibrary.simpleMessage("Open \"Ximen 1 Store\" door"),
        "userOpenDoor2":
            MessageLookupByLibrary.simpleMessage("Open \"Ximen 2 Store\" door"),
        "userPad": MessageLookupByLibrary.simpleMessage("Online queue Setting"),
        "userPassword":
            MessageLookupByLibrary.simpleMessage("Change user password"),
        "userPhone":
            MessageLookupByLibrary.simpleMessage("Change user cellphone"),
        "userPlayLog":
            MessageLookupByLibrary.simpleMessage("Used point history"),
        "userQUIC":
            MessageLookupByLibrary.simpleMessage("X50QuIC Payment Setting"),
        "userTicLog":
            MessageLookupByLibrary.simpleMessage("Unused ticket history"),
        "userUTicLog":
            MessageLookupByLibrary.simpleMessage("Usage ticket history"),
        "vipDate": MessageLookupByLibrary.simpleMessage("Expire Date : "),
        "vipExpiredMsg": MessageLookupByLibrary.simpleMessage(
            "Click left \"Ticket\" icon to buy !"),
        "x50PayLanguage":
            MessageLookupByLibrary.simpleMessage("X50Pay Language")
      };
}
