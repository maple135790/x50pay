import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/life_cycle_manager.dart';
import 'package:x50pay/common/utils/prefs_utils.dart';
import 'package:x50pay/mixins/nfc_pad_mixin.dart';
import 'package:x50pay/mixins/nfc_pay_mixin.dart';
import 'package:x50pay/page/game/cab_select.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';

class AppLifeCycles extends LifecycleCallback with NfcPayMixin, NfcPadMixin {
  static AppLifeCycles? _instance;
  AppLifeCycles._();

  /// App 全局的生命週期管理
  static AppLifeCycles get instance => _instance ??= AppLifeCycles._();

  var _lastScanTime = DateTime.fromMillisecondsSinceEpoch(0);
  int cardEmuInterval = 0;

  /// X50 店內的 tag type
  static const availablePollingTypes = {NfcPollingOption.iso14443};

  /// 機台使用的 polling type，需要被排除
  static const neverPollingTypes = {NfcPollingOption.iso18092};

  static const _kNfcIntervalLockTime = 2500;

  static const _kNfcSessionTime = 800;

  Future<bool> _isEnableInAppNfcScan() async {
    final enabled = await Prefs.getBool(PrefsToken.enabledInAppNfcScan);
    return enabled ?? false;
  }

  Future<void> _handleNfc(NfcTag tag) async {
    if (!GlobalSingleton.instance.isLogined) return;
    log('got tag', name: 'handleNfc');

    Ndef? ndef = Ndef.from(tag);
    if (ndef == null) {
      MifareClassic.from(tag);
      if (!kDebugMode) {
        log('not capable of this tag', name: 'handleNfc');
        return;
      } else {
        _nfcTest(tag);
        return;
      }
    }
    _handleNfcEvent(ndef);
  }

  void _handleNfcPadRecord(String url) async {
    final typeCheck = url.split('nfcPad/').last.split('/').first;
    if (typeCheck != 'byMid') return;
    final padmid = url.split('nfcPad/').last.split('/').last;
    if (padmid.isEmpty) return;
    handleNfcPad(padmid);
  }

  void _handleNfcPayRecord(String url) async {
    final mid = url.split('nfcpay/').last.split('/').first;
    final cid = url.split('nfcpay/').last.split('/').last;
    if (mid.isEmpty || cid.isEmpty) return;
    final settingRepo = SettingRepository();
    final isPreferTicket = await _getNfcPreferTicketSetting(settingRepo);
    handleNfcPay(
      mid: mid,
      cid: cid,
      repository: Repository(),
      settingRepo: settingRepo,
      isPreferTicket: isPreferTicket,
      onCabSelect: (qrPayData) {
        GlobalSingleton.instance.isNfcPayDialogOpen = true;
        showDialog(
          context: GlobalSingleton.navigatorKey.currentContext!,
          builder: (context) {
            return CabSelect.fromQRPay(
              qrPayData: qrPayData,
              onCreated: () {
                EasyLoading.dismiss();
              },
              onDestroy: () {
                GlobalSingleton.instance.isNfcPayDialogOpen = false;
              },
            );
          },
        );
      },
      onNfcAutoPaymentDone: () {},
    );
  }

  void _handleNfcEvent(Ndef ndef) async {
    if (DateTime.now().difference(_lastScanTime).inMilliseconds <
        _kNfcIntervalLockTime) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(msg: 'NFC 間隔鎖作動中');
      return;
    }

    _lastScanTime = DateTime.now();
    final message = ndef.cachedMessage;

    if (message == null) {
      log('message is null or same', name: 'handleNfcEvent');
      return;
    }
    NdefRecord? urlRecord;

    if (GlobalSingleton.instance.isNfcPayDialogOpen) {
      log('nfcPay dialog already opened', name: '_nfcTest');
      return;
    }

    for (var record in message.records) {
      if (record.typeNameFormat != NdefTypeNameFormat.nfcWellknown) continue;
      final scheme = NdefRecord.URI_PREFIX_LIST[record.payload[0]].toString();
      final url = String.fromCharCodes(record.payload);
      if (Uri.tryParse(scheme + url) == null) continue;
      urlRecord = record;
    }
    // 沒找到符合的record
    if (urlRecord == null) return;

    final url = String.fromCharCodes(urlRecord.payload);
    log(url, name: 'handleNfcEvent');

    if (!await _isEnableInAppNfcScan()) {
      log('inAppNfcScan is disabled', name: 'handleNfcEvent');
      final isUrl = Uri.tryParse(url) != null;
      log("$url $isUrl", name: 'handleNfcEvent');
      if (isUrl && kReleaseMode) {
        launchUrlString('https://$url', mode: LaunchMode.externalApplication);
      }
      return;
    }

    if (url.contains('nfcpay')) {
      _handleNfcPayRecord(url);
    } else if (url.contains('nfcPad')) {
      _handleNfcPadRecord(url);
    }
  }

  void _startNfcScan() async {
    NfcManager.instance.stopSession();

    cardEmuInterval = await Prefs.getInt(PrefsToken.cardEmulationInterval) ??
      PrefsToken.cardEmulationInterval.defaultValue;
    log('card Emu Interval: $cardEmuInterval', name: 'startNfcScan');

    // 若使用者設定不模擬卡片，則不需要模擬卡片
    if (cardEmuInterval == -1) {
      NfcManager.instance.startSession(
        onDiscovered: _handleNfc,
        pollingOptions: availablePollingTypes,
      );
    } else {
      while (true) {
        NfcManager.instance.startSession(
          onDiscovered: _handleNfc,
          pollingOptions: availablePollingTypes,
        );

        await Future.delayed(const Duration(milliseconds: _kNfcSessionTime));
        // 因為開啟NFC讀寫模式時，沒有辦法模擬卡片，所以要關掉NFC讀寫模式
        NfcManager.instance.stopSession();

        await Future.delayed(Duration(milliseconds: cardEmuInterval));
      }
    }
  }

  Future<void> _nfcTest(NfcTag tag) async {
    final ndef = Ndef(
      tag: tag,
      isWritable: true,
      maxSize: 137,
      cachedMessage: NdefMessage([
        NdefRecord.createUri(
          Uri.parse('https://pay.x50.fun/nfcPad/byMid/50Pad'),
        ),
      ]),
      additionalData: {},
    );
    _handleNfcEvent(ndef);
  }

  Future<bool> _checkNfcAvailable() {
    return NfcManager.instance.isAvailable();
  }

  Future<void> _tryActivateNfc() async {
    bool isAvailable = await _checkNfcAvailable();
    if (!isAvailable) {
      log('NFC is not available', name: 'tryActivateNfc');
      return;
    }

    _startNfcScan();
  }

  void reactivateNFC() async {
    await Future.delayed(const Duration(milliseconds: 100));

    _tryActivateNfc();
  }

  @override
  void onCreated() {
    super.onCreated();
    _tryActivateNfc();
  }

  @override
  void onPaused() async {
    bool isAvailable = await _checkNfcAvailable();
    if (!isAvailable) return;

    NfcManager.instance.stopSession();
  }

  @override
  void onResumed() {
    _tryActivateNfc();
  }

  Future<bool> _getNfcPreferTicketSetting(SettingRepository settingRepo) async {
    final settings =
        await SettingsViewModel(settingRepo: settingRepo).getPaymentSettings();
    return settings.nfcTicket;
  }
}
