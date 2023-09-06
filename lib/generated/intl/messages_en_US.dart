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

  static String m0(continuousDay) => " Continuous : ${continuousDay} days";

  static String m1(gatchaPoints) => " Gatcha : ${gatchaPoints} points";

  static String m2(gr2LimitTimes) =>
      " Point back ${gr2LimitTimes} times , 25P/t";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "continuous": m0,
        "dialogReturn": MessageLookupByLibrary.simpleMessage("Return"),
        "dialogSave": MessageLookupByLibrary.simpleMessage("Save"),
        "dressRoomTitle":
            MessageLookupByLibrary.simpleMessage("Change avater/clothes"),
        "gameDiscountHour": MessageLookupByLibrary.simpleMessage("Discount"),
        "gameLocation": MessageLookupByLibrary.simpleMessage("Your Location"),
        "gameMPass": MessageLookupByLibrary.simpleMessage("Monthly Pass"),
        "gameNormalHour": MessageLookupByLibrary.simpleMessage("Normal"),
        "gameWeekday": MessageLookupByLibrary.simpleMessage("Weekday"),
        "gameWeekends": MessageLookupByLibrary.simpleMessage("Weekends"),
        "gatcha": m1,
        "gr2HeartBox": MessageLookupByLibrary.simpleMessage("Hearts Shop"),
        "gr2Limit": m2,
        "gr2ResetDate": MessageLookupByLibrary.simpleMessage(" Reset Date : "),
        "heart": MessageLookupByLibrary.simpleMessage(" Hearts"),
        "infoNotify": MessageLookupByLibrary.simpleMessage("Informations"),
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
        "navCollab": MessageLookupByLibrary.simpleMessage("Collab"),
        "navGame": MessageLookupByLibrary.simpleMessage("Game"),
        "navGift": MessageLookupByLibrary.simpleMessage("Gift"),
        "navSettings": MessageLookupByLibrary.simpleMessage("Settings"),
        "nextLv": MessageLookupByLibrary.simpleMessage(" Next Lv : "),
        "officialNotify": MessageLookupByLibrary.simpleMessage("Offical ADs"),
        "serviceError": MessageLookupByLibrary.simpleMessage(
            "Server error, Please retry again."),
        "ticketBalance":
            MessageLookupByLibrary.simpleMessage("Ticket Balance : "),
        "ticketUnit": MessageLookupByLibrary.simpleMessage(" "),
        "vipDate": MessageLookupByLibrary.simpleMessage("Expire Date : "),
        "vipExpiredMsg": MessageLookupByLibrary.simpleMessage(
            "Click left \"Ticket\" icon to buy !"),
        "x50PayLanguage":
            MessageLookupByLibrary.simpleMessage("X50Pay Language")
      };
}
