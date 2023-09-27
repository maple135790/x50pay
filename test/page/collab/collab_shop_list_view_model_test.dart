import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/page/collab/collab_shop_list_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();

void main() {
  final viewModel = CollabShopListViewModel(repository: mockRepo);

  setUp(() {
    SharedPreferences.setMockInitialValues({"store_id": "7037656"});

    when(() => mockRepo.getSponserDocument()).thenAnswer((_) async {
      const rawResponse =
          r'''<div class="ts-content is-tertiary" style="padding:0px;">
    <div class="ts-center">
        <div class="ts-space"></div>
        <div class="ts-header is-secondary">X50Pay 合作商家</div>
        <div class="ts-text is-secondary">查看 & 兌換合作商家優惠</div>
        <div class="ts-space is-large"></div>
    </div>
    <div class="ts-content is-fitted is-secondary">
        <div class="ts-tab">
            <a id="tab-me" class="item is-active" onclick="tabme()">商家清單 / 兌換</a>
        </div>
    </div>
    <div class="symbol" style="float:right; bottom:0px; position:absolute; right:0px;">
        <div class="ts-image is-heading">
            <img src="/static/giftcenter.png" style="width:auto; height:135px; opacity:80%;">
         </div>
    </div>
</div>

    <div style="margin:20px 12px 12px 12px;"class="ts-content is-tertiary is-rounded" onclick="goQRcode()">
<div class="ts-center" style="padding:2px;">
  <span class="ts-icon is-qrcode-icon" style="font-size:2.5vh;"></span>   
  <div class="ts-header is-secondary">點我掃店鋪 QRCode</div>
  </div>
</div>
    <div style="margin:12px 12px 12px 12px; padding:0px;"class="ts-content is-rounded">
<div class="ts-divider"></div>
<div class="ts-menu is-fluid" style="">
    <div class="item">
        <div class="ts-row" style="flex: 1;">
            <div class="column">
                <div class="ts-image is-rounded is-covered is-1-by-1 is-tiny">
                    <img src="/static/gc/01.jpg">
                </div>                            
            </div>                       
            <div class="column is-fluid content" style="line-height:2;">
                <div class="header"><span class="ts-icon is-tiny-icon is-end-spaced is-shop-icon"></span>獅子林冰茶</div>    
                <div class="meta">
                    <div>萬華區西寧南路36-1號</div>
                    <div>每杯折抵5元</div>
                </div>
            </div> 
            </div> 
            </div> 
    <div class="item">
            <div class="column">
                <div class="ts-image is-rounded is-covered is-1-by-1 is-tiny">
                    <img src="https://play-lh.googleusercontent.com/uLVeDdW958oOixZpDspwcKoteDu9JWHKKZUlQ1RgOa3JKqsRPJaPS5R2zJAAEmdR3zGt">
                </div>                            
            </div>                       
            <div class="column is-fluid content" style="line-height:2;">
                <div class="header"><span class="ts-icon is-tiny-icon is-end-spaced is-shop-icon"></span>街口支付</div>    
                <div class="meta">
                    <div>街口APP掃描付款</div>
                    <div>可使用街口點數折抵</div>
                </div>
            </div> 
        </div> 
    </div>
</div>
''';
      return rawResponse;
    });
  });
  test('測試取得合作資料', () async {
    final sponsers = await viewModel.init();

    expect(sponsers, isNotEmpty);
  });
}
