import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/common/models/quicSettings/quic_settings.dart';
import 'package:x50pay/page/scan/qr_pay/qr_pay_view_model.dart';
import 'package:x50pay/page/settings/settings_view_model.dart';
import 'package:x50pay/repository/repository.dart';
import 'package:x50pay/repository/setting_repository.dart';

class MockRepository extends Mock implements Repository {}

class MockSettingRepository extends Mock implements SettingRepository {}

final mockRepo = MockRepository();
final mockSettingRepo = MockSettingRepository();

void main() {
  final viewModel = QRPayViewModel(
    repository: mockRepo,
    settingRepo: mockSettingRepo,
    cid: '',
    mid: '',
    onCabSelect: (qrPayData) {},
    onPaymentDone: () {},
  );
  setUpAll(() {
    when(() => mockRepo.selGame(any())).thenAnswer((_) async {
      const rawResponse =
          '''{"message":"done","code":200,"re":[["05-27 13:00 ~ 16:00","maiDX-\u2606\u897f\u9580\u4e8c\u5e97\u2605"]],"note":[0,"1F/\u9032\u9580\u53f3\u5074","1F/\u9032\u9580\u5de6\u524d",false,"one"],"cabinet":[{"num":1,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3 (DX\u6846\u6309\u9375)","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true},{"num":2,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6 (DX\u6846\u6309\u9375)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true}],"caboid":"632904081eb45d31f0a1185c","pad":true,"padmid":"50Pad02","padlid":"twommdx"}''';
      return CabinetModel.fromJson(json.decode(rawResponse));
    });
  });

  group('預設支付方法 == X50Pay', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({"store_id": "7037656"});

      when(() => mockSettingRepo.getQuickPaySettings()).thenAnswer((_) async {
        return PaymentSettingsModel(
          mtpMode: DefaultCabPayment.x50pay.value,
          aGV: true,
          nfcAuto: true,
          nfcQuic: true,
          nfcTicket: true,
          nfcNVSV: "0",
          nfcSDVX: "0",
          nfcTwo: "0",
          nfcQlock: 15,
        );
      });
    });
    test('支付路由回傳須為X50Pay', () async {
      final result = await viewModel.checkThirdPartyPaymentRedirect();
      expect(result.type, QRPayTPPRedirectType.x50Pay);
    });
  });

  group('預設支付方法 == jkopay', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({"store_id": "7037656"});

      when(() => mockSettingRepo.getQuickPaySettings()).thenAnswer((_) async {
        return PaymentSettingsModel(
          mtpMode: DefaultCabPayment.jko.value,
          aGV: true,
          nfcAuto: true,
          nfcQuic: true,
          nfcTicket: true,
          nfcNVSV: "0",
          nfcSDVX: "0",
          nfcTwo: "0",
          nfcQlock: 15,
        );
      });
      when(() => mockRepo.getDocument(any())).thenAnswer((_) async {
        const rawBody = r'''<!DOCTYPE html>
<html class="is-dark">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="apple-mobile-web-app-title" content="X50Pay" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tocas-ui/4.0.0-beta.2/tocas.min.css">        
        <link rel="apple-touch-icon" href="/static/apple-touch-icon.png" />
        <link rel="stylesheet" type="text/css" href="/static/css/style-v4.css?v2.6.1" />
        <title>X50 Pay - X50 線上付款遊玩系統</title>
    </head>
    <style>
        body {
            overflow-y: scroll;
            overflow-x: hidden;
        }
    </style>
    <body ontouchstart=””>
        <div class="ts-box is-noborder" id="main">
            <div class="ts-app-layout is-horizontal" style="height: 100vh; 
                    height: calc(var(--vh, 1vh) * 100);">
                <div class="cell is-vertical" style=""> 
                <div class="cell" style="z-index:5;"> 
		            <div id="navbar" class="ts-box" style="border:0px; padding:5px; font-size:14px;">
        		    	<div class="ts-center">
                            <span class="ts-avatar is-circular" style="height:30px;width:30px;">			
                                <img src="/static/logo.jpg">		
                            </span>
            			</div>
		            </div>
                </div>
                <div class="cell is-fluid is-scrollable">
		            <div id="content" >
<div class="ts-box gamesel" style="margin:0px; border:0px; border-radius:0px;">
    <div class="ts-image" style="height:220px;">							
        <img class="loginlogo" src="/static/logo.jpg">
    </div>
    <div class="ts-mask is-bottom">
        <div class="ts-content" style="color: #FFF;">
            <div class="ts-header">
                選擇付款方式
            </div>
            <div class="ts-header is-gameinfo" style="color:rgba(255,255,255,0.9);">
                <i class="ts-icon is-clock-icon is-margin-icon"></i> 歡迎使用 X50MGS 多元付款平台  <br/>
            </div>
        </div>
    </div>
</div>
<div class="ts-segment" style="margin:12px;">
    <div class="ts-wrap is-vertical">
        <div class="ts-button is-fluid is-negative is-start-icon" onclick="location.href='/'" style=" padding:10px;"><span class="ts-icon is-wallet-icon" style="
                    margin-right: .1rem;
                    "></span><span class="ts-icon is-p-icon"></span>X50Pay</div>
        <div class="ts-divider is-fluid"></div>
        <div class="ts-button is-fluid " onclick="location.href='https://onlinepay.jkopay.com/web/paymentRouter?j=OL%231%3AENT%23UStZdDBadDNzL3lBTlNFQXRld1oxZz09%3AS%23b8be1b9d-0b4b-11ee-bdc1-f8f21e0d1b98%3AA%2328%3ACUR%23TWD%3ASRC%23REDIRECT_MWEB%3AUNRDM%230%3AFX%230%3ATA%2328%3ATCUR%23TWD%3AFXR%231.00%3AUR%231%3AD%23D&amp;s=d76c08c4e4933b3e49fc69e5892dd16c72dff1d2cb73dcd5070db4edf36c5358'"><img style="height:28px;" src="https://upload.wikimedia.org/wikipedia/zh/thumb/5/5a/JKOPAY_logo.svg/1200px-JKOPAY_logo.svg.png"></div>
        <div class="ts-button is-fluid is-disabled" onclick="location.href='/reg'" ><img style="height:20px; margin:4px;" src="https://d.line-scdn.net/linepay/portal/v-230531/portal/assets/img/portal/tw/logo.svg"></div>
    </div>
</div>
        		    </div>
                </div>
            </div>
        </div>
        <script>
            let vh = window.innerHeight * 0.01;
document.documentElement.style.setProperty('--vh', `${vh}px`);
        </script>
        <script src="/static/js/jquery-3.5.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html5-qrcode/2.0.3/html5-qrcode.min.js" integrity="sha512-uOj9C1++KO/GY58nW0CjDiUjLKWQG4yB/NJMj3PtJNmFA52Hg56lojRtvBpLgQyVByUD+1M3M/1tKdoGDKUBAQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    </body>
</html>''';
        return Response.bytes(
          utf8.encode(rawBody),
          302,
          headers: {'location': 'onlinepay.jkopay.com'},
        );
      });
    });
    test('支付路由回傳須為jkoPay', () async {
      final result = await viewModel.checkThirdPartyPaymentRedirect();
      expect(result.type, QRPayTPPRedirectType.jkoPay);
    });
  });
  group('預設支付方法 == ask', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({"store_id": "7037656"});

      when(() => mockSettingRepo.getQuickPaySettings()).thenAnswer((_) async {
        return PaymentSettingsModel(
          mtpMode: DefaultCabPayment.ask.value,
          aGV: true,
          nfcAuto: true,
          nfcQuic: true,
          nfcTicket: true,
          nfcNVSV: "0",
          nfcSDVX: "0",
          nfcTwo: "0",
          nfcQlock: 15,
        );
      });
      when(() => mockRepo.getDocument(any())).thenAnswer((_) async {
        const rawBody = r'''
<!DOCTYPE html>
<html class="is-dark">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="apple-mobile-web-app-title" content="X50Pay" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/tocas-ui/4.0.0-beta.2/tocas.min.css">        
        <link rel="apple-touch-icon" href="/static/apple-touch-icon.png" />
        <link rel="stylesheet" type="text/css" href="/static/css/style-v4.css?v2.6.1" />
        <title>X50 Pay - X50 線上付款遊玩系統</title>
    </head>
    <style>
        body {
            overflow-y: scroll;
            overflow-x: hidden;
        }
    </style>
    <body ontouchstart=””>
        <div class="ts-box is-noborder" id="main">
            <div class="ts-app-layout is-horizontal" style="height: 100vh; 
                    height: calc(var(--vh, 1vh) * 100);">
                <div class="cell is-vertical" style=""> 
                <div class="cell" style="z-index:5;"> 
		            <div id="navbar" class="ts-box" style="border:0px; padding:5px; font-size:14px;">
        		    	<div class="ts-center">
                            <span class="ts-avatar is-circular" style="height:30px;width:30px;">			
                                <img src="/static/logo.jpg">		
                            </span>
            			</div>
		            </div>
                </div>
                <div class="cell is-fluid is-scrollable">
		            <div id="content" >
<div class="ts-box gamesel" style="margin:0px; border:0px; border-radius:0px;">
    <div class="ts-image" style="height:220px;">							
        <img class="loginlogo" src="/static/logo.jpg">
    </div>
    <div class="ts-mask is-bottom">
        <div class="ts-content" style="color: #FFF;">
            <div class="ts-header">
                選擇付款方式
            </div>
            <div class="ts-header is-gameinfo" style="color:rgba(255,255,255,0.9);">
                <i class="ts-icon is-clock-icon is-margin-icon"></i> 歡迎使用 X50MGS 多元付款平台  <br/>
            </div>
        </div>
    </div>
</div>
<div class="ts-segment" style="margin:12px;">
    <div class="ts-wrap is-vertical">
        <div class="ts-button is-fluid is-negative is-start-icon" onclick="location.href='/nfcpay/5fcdcf630004a524c8fadffe/70376560'" style=" padding:10px;"><span class="ts-icon is-wallet-icon" style="
                    margin-right: .1rem;
                    "></span><span class="ts-icon is-p-icon"></span>X50Pay</div>
        <div class="ts-divider is-fluid"></div>
        <div class="ts-button is-fluid " onclick="location.href='https://onlinepay.jkopay.com/web/paymentRouter?j=OL%231%3AENT%23NVhMdzh5d1pVY2lSUVFYTlZFYUQwUT09%3AS%233f6b332b-0120-11ee-bdc1-f8f21e0d1b98%3AA%2321%3ACUR%23TWD%3ASRC%23REDIRECT_MWEB%3AUNRDM%230%3AFX%230%3ATA%2321%3ATCUR%23TWD%3AFXR%231.00%3AUR%231%3AD%23D&amp;s=e26134fc207ed4a97fd79cdd73bbdf3038401056c277e95ed5cbacf0ffad4dd9'"><img style="height:28px;" src="https://upload.wikimedia.org/wikipedia/zh/thumb/5/5a/JKOPAY_logo.svg/1200px-JKOPAY_logo.svg.png"></div>
        <div class="ts-button is-fluid is-disabled" onclick="location.href='/reg'" ><img style="height:20px; margin:4px;" src="https://d.line-scdn.net/linepay/portal/v-230531/portal/assets/img/portal/tw/logo.svg"></div>
    </div>
</div>
        		    </div>
                </div>
            </div>
        </div>
        <script>
            let vh = window.innerHeight * 0.01;
document.documentElement.style.setProperty('--vh', `${vh}px`);
        </script>
        <script src="/static/js/jquery-3.5.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html5-qrcode/2.0.3/html5-qrcode.min.js" integrity="sha512-uOj9C1++KO/GY58nW0CjDiUjLKWQG4yB/NJMj3PtJNmFA52Hg56lojRtvBpLgQyVByUD+1M3M/1tKdoGDKUBAQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    </body>
</html>''';
        return Response.bytes(utf8.encode(rawBody), 200);
      });
    });
    test('支付路由回傳須為none', () async {
      final result = await viewModel.checkThirdPartyPaymentRedirect();
      expect(result.type, QRPayTPPRedirectType.none);
    });
  });
}
