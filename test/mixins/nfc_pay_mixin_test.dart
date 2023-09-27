import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/basic_response.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/mixins/nfc_pay_mixin.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';

class MockNfcPayMixin with NfcPayMixin {}

class MockRepository extends Mock implements Repository {}

class MockSettingRepository extends Mock implements SettingRepository {}

void main() {
  final mockSettingRepo = MockSettingRepository();
  final mockRepo = MockRepository();
  final mockMixin = MockNfcPayMixin();

  setUp(() {
    when(() => mockRepo.getQRPayDocument(any())).thenAnswer((_) async {
      const rawResponse = r'''付款中...''';
      return rawResponse;
    });
    when(() => mockRepo.doInsertRawUrl(any())).thenAnswer((_) async {
      const rawResponse = '''{"code":200,"message":"smth"}''';
      return BasicResponse.fromJson(json.decode(rawResponse));
    });
    when(() => mockRepo.getDocumentWithDomainPrefix(
          any(),
          any(),
          descLabel: any(named: 'descLabel'),
        )).thenAnswer((_) async {
      return r'''<script type="text/javascript"> 
        $.post('/api/v1/pay/5fcdcf800004a524c8fae000/70376560/0',function(data){});
        function myfc() {
            var win = window.open('','_self');
            win.close();
         }
        setInterval(myfc, 1500);
    </script>
  </body>''';
    });
  });
  test('當快速付款無設定、自動付款開啟，預期自動完成付款', () async {
    SharedPreferences.setMockInitialValues({});

    var log = <String>[];
    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: true,
        aGV: true,
        nfcQuic: true,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
      },
      onNfcAutoPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), false);
    expect(log.contains('onPaymentDone'), true);
  });
  test('當快速付款開啟、自動付款開啟，預期自動完成付款', () async {
    var log = <String>[];
    SharedPreferences.setMockInitialValues({"fastQRPay": true});

    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: true,
        aGV: true,
        nfcQuic: true,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
      },
      onNfcAutoPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), false);
    expect(log.contains('onPaymentDone'), true);
  });
  test('當快速付款關閉、自動付款開啟，預期自動完成付款', () async {
    var log = <String>[];
    SharedPreferences.setMockInitialValues({"fastQRPay": false});

    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: true,
        aGV: true,
        nfcQuic: true,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
      },
      onNfcAutoPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), false);
    expect(log.contains('onPaymentDone'), true);
  });
  test('當自動付款關閉，預期彈出onCabSelect', () async {
    SharedPreferences.setMockInitialValues({});

    var log = <String>[];
    when(() => mockRepo.getQRPayDocument(any())).thenAnswer((_) async {
      const rawResponse = r'''<html><head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-title" content="X50 Pay">
    <link rel="apple-touch-icon" href="/static/apple-touch-icon.png">
    <link href="/static/css/tocas.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/static/css/style.css?v2.0">   
<style>
.ts.structured.message > .avatar{
    width: 10em;
    min-width: 10em;
    height: 10em;
}
.ts.padded.grid {
    padding:1.2em;
}
</style>
    <link rel="stylesheet" type="text/css" href="/static/css/addtohomescreen.css">
    <title>X50 Pay - X50 線上付款遊玩系統</title>
    <style>
      body {
        background-color: rgb(250, 250, 250);
      }
    </style>
    <!--X50 Music Game Station 線上遊玩付款系統-->
  </head>
  <body>
    <div class="ts very narrow container">
      <div class="ts ab card" style="margin-top:1rem;">
<div class="ts  grid" style="padding:7px 15px 7px 15px;">
    <div class="six wide column">
        <div class="left aligned padded content">
            <div class="ts circular icon very compact button" onclick="location.href='/'" style="height:30px;">
                <i class="chevron left icon"></i>
            </div> 
        </div>
    </div>
    <div class="ten wide column">
        <div class="right aligned padded content">
            <div class="ts mini circular image" style="height:30px; margin-right:1px;">
        <img src="https://secure.gravatar.com/avatar/6a4cbe004cdedee9738d82fe9670b326?size=250">
    </div>
    <div class="ts circular negative labeled icon very compact button" style="height:30px;">
                <i class="plus icon"></i>
                99324.0P
            </div> 
        </div>
    </div>
</div>
      </div>
<div class="ts modals dimmer">
    <dialog id="closable0ticModal" class="ts modal">
        <div class="content">
            <div class="ts header">請確認是否要使用遊玩卷:</div>
            <div class="header"><strong>機種: maimaiDX</strong> </div>
            <div class="header">編號: 1號機</div>
            <p>注意 請確認是否有玩家正在遊玩，如無在進行使用，</p>
            <p>請勿影響他人權益。如投幣扣點/券後機臺無動作請聯絡粉專請勿再次點擊</p>
        </div>
        <div class="actions">
            <button id="canceltic0" class="ts button">
                取消
            </button>
            <button id="tic0" class="ts positive button">
                確認 
            </button>
        </div>
    </dialog>
</div>
<div class="ts modals dimmer">
    <dialog id="closable1ticModal" class="ts modal">
        <div class="content">
            <div class="ts header">請確認是否要使用遊玩卷:</div>
            <div class="header"><strong>機種: maimaiDX</strong> </div>
            <div class="header">編號: 1號機</div>
            <p>注意 請確認是否有玩家正在遊玩，如無在進行使用，</p>
            <p>請勿影響他人權益。如投幣扣點/券後機臺無動作請聯絡粉專請勿再次點擊</p>
        </div>
        <div class="actions">
            <button id="canceltic1" class="ts button">
                取消
            </button>
            <button id="tic1" class="ts positive button">
                確認 
            </button>
        </div>
    </dialog>
</div>
<div class="ts modals dimmer">
    <dialog id="closable0Modal" class="ts modal">
        <div class="content">
            <div class="ts header">請確認是否要扣除點數:</div>
            <div class="header"><strong>機種: maimaiDX</strong> </div>
           <div class="header">編號: 1號機</div>
            <p>注意 請確認是否有玩家正在遊玩，如無在進行扣點，</p>
            <p>請勿影響他人權益。如投幣扣點/券後機臺無動作請聯絡粉專請勿再次點擊</p>
        </div>
        <div class="actions">
            <button id="cancel0" class="ts button">
                取消
            </button>
            <button id="btn0" class="ts positive button">
                確認
            </button>
        </div>
    </dialog>
</div>
<div class="ts modals dimmer">
    <dialog id="closable1Modal" class="ts modal">
        <div class="content">
            <div class="ts header">請確認是否要扣除點數:</div>
            <div class="header"><strong>機種: maimaiDX</strong> </div>
           <div class="header">編號: 1號機</div>
            <p>注意 請確認是否有玩家正在遊玩，如無在進行扣點，</p>
            <p>請勿影響他人權益。如投幣扣點/券後機臺無動作請聯絡粉專請勿再次點擊</p>
        </div>
        <div class="actions">
            <button id="cancel1" class="ts button">
                取消
            </button>
            <button id="btn1" class="ts positive button">
                確認
            </button>
        </div>
    </dialog>
</div>
<div id="dimmer" class="ts inverted dimmer">
    <div class="ts indeterminate text loader">等候投幣中</div>
</div>
<a class="ts card gamesel">
<div class="image">
<img src="/static/gamesimg/mmdx.png">	
<div class="header">	
maimaiDX
<div class="sub header" style="color:rgba(255,255,255,0.9);">
</div>
</div>
</div>
</a>
<div class="center aligned content">
    <div class="ts structured secondary message" style="min-height: 12.5rem;padding:5px; padding-top:0.5rem; padding-bottom:0.5rem;">
        <div class="content" style="text-align:center; padding:8px;">
           <div class="header" style="padding-bottom:0.6em;"><strong>您已選擇 1 號機</strong></div>
            <p>單人遊玩</p>
            <div class="center aligned content" style="padding-bottom:1em;">
                <div class="ts separated buttons">
                    <button id="tic0-modal" class="pay ts  compact positive button">遊玩券</button>
                    <button id="btn0-modal" class="pay ts  compact negative button">25P</button>
                    </div>
             </div>
            <p>雙人遊玩(扣2券)</p>
            <div class="center aligned content" style="padding-bottom:1em;">
                <div class="ts separated buttons">
                    <button id="tic1-modal" class="pay ts  compact positive button">遊玩券</button>
                    <button id="btn1-modal" class="pay ts  compact negative button">50P</button>
                    </div>
             </div>
        </div>
    </div>
</div>
      <div class="ts center aligned basic small message">
          <p>Copyright © <a href="mailto:pay@x50.fun">X50 Music Game Staion</a></p>
        <p class="ug">如使用本平台視為同意<a href="/lic">平台使用條款</a></p>
      </div>
    </div>
    <script src="/static/js/jquery-3.5.1.min.js"></script>
    <script src="/static/js/tocas.js"></script>
    <script>
      addToHomescreen();
    </script>
]
<script>
$("#btn0-modal").click(function(){
    ts('#closable0Modal').modal("show")
});
$("#cancel0").click(function(){
    ts('#closable0Modal').modal("hide")
});
$("#btn0").click(function() {
console.log('run');
        $("#dimmer").addClass("active");
    $.post('/api/v1/pay/5fcdce800004a524c8fadff9/70376560/0',function(data){
        if (data.code == 'done') {
            location.replace('/');
        } else if (data.code == 'lock') {
            location.replace('/api/v1/pay/lock/');
        } else {
            location.replace('/api/v1/pay/err/');
        }
    });
});
$("#btn1-modal").click(function(){
    ts('#closable1Modal').modal("show")
});
$("#cancel1").click(function(){
    ts('#closable1Modal').modal("hide")
});
$("#btn1").click(function() {
console.log('run');
        $("#dimmer").addClass("active");
    $.post('/api/v1/pay/5fcdce800004a524c8fadff9/70376560/1',function(data){
        if (data.code == 'done') {
            location.replace('/');
        } else if (data.code == 'lock') {
            location.replace('/api/v1/pay/lock/');
        } else {
            location.replace('/api/v1/pay/err/');
        }
    });
});
$("#tic0-modal").click(function(){
    ts('#closable0ticModal').modal("show")
});
$("#tic0").click(function() {
console.log('run');
        $("#dimmer").addClass("active");
    $.post('/api/v1/tic/5fcdce800004a524c8fadff9/70376560/0',function(data){
        if (data.code == 'done') {
            location.replace('/');
        } else if (data.code == 'lock') {
            location.replace('/api/v1/pay/lock/');
        } else {
            location.replace('/api/v1/pay/err/');
        }
    });
});
$("#canceltic0").click(function(){
    ts('#closable0ticModal').modal("hide")
});
$("#tic1-modal").click(function(){
    ts('#closable1ticModal').modal("show")
});
$("#tic1").click(function() {
console.log('run');
        $("#dimmer").addClass("active");
    $.post('/api/v1/tic/5fcdce800004a524c8fadff9/70376560/1',function(data){
        if (data.code == 'done') {
            location.replace('/');
        } else if (data.code == 'lock') {
            location.replace('/api/v1/pay/lock/');
        } else {
            location.replace('/api/v1/pay/err/');
        }
    });
});
$("#canceltic1").click(function(){
    ts('#closable1ticModal').modal("hide")
});

</script>
  
</body></html>''';
      return rawResponse;
    });
    when(mockSettingRepo.getQuickPaySettings).thenAnswer((_) async {
      return PaymentSettingsModel(
        mtpMode: DefaultCabPayment.x50pay.value,
        nfcAuto: false,
        aGV: true,
        nfcQuic: false,
        nfcTicket: true,
        nfcNVSV: "0",
        nfcSDVX: "0",
        nfcTwo: "0",
        nfcQlock: 15,
      );
    });

    await mockMixin.handleNfcPay(
      mid: '',
      cid: '',
      settingRepo: mockSettingRepo,
      onCabSelect: (qrPayData) {
        log.add('onCabSelect');
        expect(qrPayData, isNotNull);
      },
      onNfcAutoPaymentDone: () {
        log.add('onPaymentDone');
      },
      isPreferTicket: false,
      repository: mockRepo,
    );
    expect(log.contains('onCabSelect'), true);
    expect(log.contains('onPaymentDone'), false);
  });
}
