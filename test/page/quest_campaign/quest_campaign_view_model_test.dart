import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/page/quest_campaign/quest_campaign_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();

void main() {
  final viewModel = QuestCampaignViewModel(
    campaignId: 'test_x50chusp082023619',
    repository: mockRepo,
  );

  setUp(() {
    when(() => mockRepo.getCampaignDocument(any())).thenAnswer((_) async {
      const rawResponse = r'''<div class="gamebase">
    <div class="ts-box gamesel"  style="margi">
        <div class="ts-image" style="overflow: hidden; height:150px;">
            <img src="/static/coupon/chu08/big.jpg" style="margin-top:-25%;">
        </div>
        <div class="ts-mask is-bottom">
            <div class="ts-content" style="color:#FFF;">
                <div class="ts-header">リジナルグッズプレゼントキャンペーン </div>   
                <div class="ts-header is-gameinfo" style="color:rgba(255,255,255,0.9);">  
                        <i class="ts-icon is-clock-icon is-margin-icon"></i> ~08/30
                        <i class="ts-icon is-crown-icon is-margin-icon" style="margin-left:3%;"></i> 65~點
                </div>
            </div>
       </div>
    </div>
    <div class="ts-box gamesel" >
    
        <div class="ts-content is-dense" style="padding-left:8px; padding-right:8px;">
            <div>
                <div class="ts-row is-evenly-divided">
                        <div class="column">
                            <div class="ts-center" style="padding-left:2px;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ts-divider" style="margin:8px 0px 8px 0px;"></div>
            <div>
                <div class="ts-row is-evenly-divided">
                        <div class="column">
                            <div class="ts-center" style="padding-left:2px;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        <div class="column">
                            <div class="ts-center" style="padding-left:10px; left: -8px; border-left: 1px solid #5a5a5a;">
                                    <i class="ts-icon is-huge is-circle-icon" style="opacity:20%; margin:0; line-height:35px;"></i>	
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ts-divider" style="margin:10px 0px 8px 0px;"></div>
                    <div class="ts-button is-fluid" onclick="location.href='/li/ev/x50chusp082023619'">
                        增加一行欄位
                    </div>
    
                </div>
    </div>
    <div class="ts-divider" style="margin:8px 0px 8px 0px;"></div>
    <center>已擁有點數 : 0 點 , 已兌換 : 0 點 </center>
    <div class="ts-divider" style="margin:8px 0px 8px 0px;"></div>
            <div class="ts-box" style="margin:8px 0px 8px 0px;">
                <div class="ts-content is-dense" style="padding-left:8px; padding-right:8px;">
                    <div class="ts-row" style="flex: 1;">
                        <div class="column">                                
                            <div class="ts-image is-rounded is-covered is-1-by-1 is-tiny">
                                <img src="/static/coupon/chu08/aime0.jpg">
                            </div>
                        </div>
                        <div class="column is-fluid content" style="line-height:2;">
                            <div class="header">ナージャ・ベルリオーズ Aime</div>
                            <div class="meta">
                                <div>所需點數 65 點</div>
                            </div>
                        </div>
                        <div class="column actions" style="display:flex; align-items: center; justify-content: center;">
                            <div id="btncouchu08a065" class="ts-button is-small is-negative is-dense">查看</div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="closablecouchu08a065Modal" class="ts-modal">
                <div class="content" style="width:350px;">
                    <div class="ts-content is-center-aligned is-vertically-padded">
                        <div class="ts-box is-horizontal">
                            <div class="ts-image is-covered">
                                <img style="width: 140px; height: 100%;" src="/static/coupon/chu08/aime0.jpg">
                            </div>
                            <div class="ts-content" style="padding:5px 5px 5px 25px;">
                                <div class="ts-header">
                                ナージャ・ベルリオーズ Aime
                                </div>
                                <p style="font-size:10px; text-align:left;">
                                    所需點數 65 點<br/>
                                    本日剩餘 1 次<br/>
                                    期間剩餘 1 次<br/>
                                    今日存量 10 個<br/>
                                    活動存量 0 個
                                 </p>
                            </div>
                        </div><br/>
                        <div class="ts-divider is-center-text">近期被兌換時間</div>
                            <center>2023年07月15日 21:44:28</center>
                            <center>2023年07月14日 20:09:41</center>
                            <center>2023年07月13日 18:33:15</center>
                            <center>2023年07月11日 15:46:14</center>
                            <center>2023年07月09日 14:57:25</center>
                            <center>2023年07月05日 17:23:58</center>
                            <center>2023年07月04日 23:52:12</center>
                            <center>2023年07月02日 14:30:37</center>
                            <center>2023年06月26日 16:28:14</center>
                            <center>2023年06月24日 17:25:15</center>
                    </div>
                    <div class="ts-divider"></div>
                    <div class="ts-content is-tertiary">
                        <div class="ts-wrap">
                                <button id="" class="ts-button is-disabled" style="width: calc( 50% - 0.5rem );">
                                點數不足
                                </button>
                                <button id="cancelcouchu08a065"class="ts-button is-fluid" style="width: calc( 50% - 0.5rem );">
                                思考一下
                                </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ts-box" style="margin:8px 0px 8px 0px;">
                <div class="ts-content is-dense" style="padding-left:8px; padding-right:8px;">
                    <div class="ts-row" style="flex: 1;">
                        <div class="column">                                
                            <div class="ts-image is-rounded is-covered is-1-by-1 is-tiny">
                                <img src="/static/coupon/chu08/aime1.jpg">
                            </div>
                        </div>
                        <div class="column is-fluid content" style="line-height:2;">
                            <div class="header">ミァン・テルスウラス Aime</div>
                            <div class="meta">
                                <div>所需點數 65 點</div>
                            </div>
                        </div>
                        <div class="column actions" style="display:flex; align-items: center; justify-content: center;">
                            <div id="btncouchu08a165" class="ts-button is-small is-negative is-dense">查看</div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="closablecouchu08a165Modal" class="ts-modal">
                <div class="content" style="width:350px;">
                    <div class="ts-content is-center-aligned is-vertically-padded">
                        <div class="ts-box is-horizontal">
                            <div class="ts-image is-covered">
                                <img style="width: 140px; height: 100%;" src="/static/coupon/chu08/aime1.jpg">
                            </div>
                            <div class="ts-content" style="padding:5px 5px 5px 25px;">
                                <div class="ts-header">
                                ミァン・テルスウラス Aime
                                </div>
                                <p style="font-size:10px; text-align:left;">
                                    所需點數 65 點<br/>
                                    本日剩餘 1 次<br/>
                                    期間剩餘 1 次<br/>
                                    今日存量 10 個<br/>
                                    活動存量 0 個
                                 </p>
                            </div>
                        </div><br/>
                        <div class="ts-divider is-center-text">近期被兌換時間</div>
                            <center>2023年07月28日 17:22:36</center>
                            <center>2023年07月27日 17:48:21</center>
                            <center>2023年07月26日 21:52:14</center>
                            <center>2023年07月26日 15:38:09</center>
                            <center>2023年07月20日 17:53:51</center>
                            <center>2023年07月20日 11:35:28</center>
                            <center>2023年07月19日 23:47:13</center>
                            <center>2023年07月14日 21:53:06</center>
                            <center>2023年07月08日 17:21:45</center>
                            <center>2023年06月24日 18:18:29</center>
                    </div>
                    <div class="ts-divider"></div>
                    <div class="ts-content is-tertiary">
                        <div class="ts-wrap">
                                <button id="" class="ts-button is-disabled" style="width: calc( 50% - 0.5rem );">
                                點數不足
                                </button>
                                <button id="cancelcouchu08a165"class="ts-button is-fluid" style="width: calc( 50% - 0.5rem );">
                                思考一下
                                </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ts-box" style="margin:8px 0px 8px 0px;">
                <div class="ts-content is-dense" style="padding-left:8px; padding-right:8px;">
                    <div class="ts-row" style="flex: 1;">
                        <div class="column">                                
                            <div class="ts-image is-rounded is-covered is-1-by-1 is-tiny">
                                <img src="/static/coupon/chu08/aime2.jpg">
                            </div>
                        </div>
                        <div class="column is-fluid content" style="line-height:2;">
                            <div class="header">ミリアム・ベミドバル Aime</div>
                            <div class="meta">
                                <div>所需點數 65 點</div>
                            </div>
                        </div>
                        <div class="column actions" style="display:flex; align-items: center; justify-content: center;">
                            <div id="btncouchu08a265" class="ts-button is-small is-negative is-dense">查看</div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="closablecouchu08a265Modal" class="ts-modal">
                <div class="content" style="width:350px;">
                    <div class="ts-content is-center-aligned is-vertically-padded">
                        <div class="ts-box is-horizontal">
                            <div class="ts-image is-covered">
                                <img style="width: 140px; height: 100%;" src="/static/coupon/chu08/aime2.jpg">
                            </div>
                            <div class="ts-content" style="padding:5px 5px 5px 25px;">
                                <div class="ts-header">
                                ミリアム・ベミドバル Aime
                                </div>
                                <p style="font-size:10px; text-align:left;">
                                    所需點數 65 點<br/>
                                    本日剩餘 1 次<br/>
                                    期間剩餘 1 次<br/>
                                    今日存量 10 個<br/>
                                    活動存量 0 個
                                 </p>
                            </div>
                        </div><br/>
                        <div class="ts-divider is-center-text">近期被兌換時間</div>
                            <center>2023年07月08日 16:40:34</center>
                            <center>2023年07月07日 15:31:49</center>
                            <center>2023年07月06日 17:39:03</center>
                            <center>2023年07月05日 13:48:09</center>
                            <center>2023年07月05日 11:10:03</center>
                            <center>2023年07月04日 20:03:53</center>
                            <center>2023年07月02日 21:29:48</center>
                            <center>2023年06月30日 15:23:44</center>
                            <center>2023年06月29日 17:05:47</center>
                            <center>2023年06月22日 22:18:31</center>
                    </div>
                    <div class="ts-divider"></div>
                    <div class="ts-content is-tertiary">
                        <div class="ts-wrap">
                                <button id="" class="ts-button is-disabled" style="width: calc( 50% - 0.5rem );">
                                點數不足
                                </button>
                                <button id="cancelcouchu08a265"class="ts-button is-fluid" style="width: calc( 50% - 0.5rem );">
                                思考一下
                                </button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ts-box" style="margin:8px 0px 8px 0px;">
                <div class="ts-content is-dense" style="padding-left:8px; padding-right:8px;">
                    <div class="ts-row" style="flex: 1;">
                        <div class="column">                                
                            <div class="ts-image is-rounded is-covered is-1-by-1 is-tiny">
                                <img src="/static/coupon/chu08/bd.jpg">
                            </div>
                        </div>
                        <div class="column is-fluid content" style="line-height:2;">
                            <div class="header">イロドリミドリLIVE’21 第二回HaNaMiNa定例会 Blu-ray＆Aime</div>
                            <div class="meta">
                                <div>所需點數 230 點</div>
                            </div>
                        </div>
                        <div class="column actions" style="display:flex; align-items: center; justify-content: center;">
                            <div id="btncouchu08bd230" class="ts-button is-small is-negative is-dense">查看</div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="closablecouchu08bd230Modal" class="ts-modal">
                <div class="content" style="width:350px;">
                    <div class="ts-content is-center-aligned is-vertically-padded">
                        <div class="ts-box is-horizontal">
                            <div class="ts-image is-covered">
                                <img style="width: 140px; height: 100%;" src="/static/coupon/chu08/bd.jpg">
                            </div>
                            <div class="ts-content" style="padding:5px 5px 5px 25px;">
                                <div class="ts-header">
                                イロドリミドリLIVE’21 第二回HaNaMiNa定例会 Blu-ray＆Aime
                                </div>
                                <p style="font-size:10px; text-align:left;">
                                    所需點數 230 點<br/>
                                    本日剩餘 1 次<br/>
                                    期間剩餘 1 次<br/>
                                    今日存量 5 個<br/>
                                    活動存量 4 個
                                 </p>
                            </div>
                        </div><br/>
                        <div class="ts-divider is-center-text">近期被兌換時間</div>
                            <center>2023年06月27日 21:01:47</center>
                    </div>
                    <div class="ts-divider"></div>
                    <div class="ts-content is-tertiary">
                        <div class="ts-wrap">
                                <button id="" class="ts-button is-disabled" style="width: calc( 50% - 0.5rem );">
                                點數不足
                                </button>
                                <button id="cancelcouchu08bd230"class="ts-button is-fluid" style="width: calc( 50% - 0.5rem );">
                                思考一下
                                </button>
                        </div>
                    </div>
                </div>
            </div>
    </div>
    <script>
    $("#btncouchu08a065").click(function(){
        openModal('#closablecouchu08a065Modal');
    });
    $("#cancelcouchu08a065").click(function(){
        closeModal('#closablecouchu08a065Modal');
    });
    $("#btnsccouchu08a065").click(function() {
        $.get("/coupon/changecheck/x50chusp082023619/couchu08a065", function( data ) {
            alert(data);
        });
    });
    $("#btncouchu08a165").click(function(){
        openModal('#closablecouchu08a165Modal');
    });
    $("#cancelcouchu08a165").click(function(){
        closeModal('#closablecouchu08a165Modal');
    });
    $("#btnsccouchu08a165").click(function() {
        $.get("/coupon/changecheck/x50chusp082023619/couchu08a165", function( data ) {
            alert(data);
        });
    });
    $("#btncouchu08a265").click(function(){
        openModal('#closablecouchu08a265Modal');
    });
    $("#cancelcouchu08a265").click(function(){
        closeModal('#closablecouchu08a265Modal');
    });
    $("#btnsccouchu08a265").click(function() {
        $.get("/coupon/changecheck/x50chusp082023619/couchu08a265", function( data ) {
            alert(data);
        });
    });
    $("#btncouchu08bd230").click(function(){
        openModal('#closablecouchu08bd230Modal');
    });
    $("#cancelcouchu08bd230").click(function(){
        closeModal('#closablecouchu08bd230Modal');
    });
    $("#btnsccouchu08bd230").click(function() {
        $.get("/coupon/changecheck/x50chusp082023619/couchu08bd230", function( data ) {
            alert(data);
        });
    });
    </script>''';
      return rawResponse;
    });
    when(() => mockRepo.redeemQuestCampaignItem(any(), any()))
        .thenAnswer((result) async {
      return "https://pay.x50.fun/coupon/changecheck/${result.positionalArguments[0]}/${result.positionalArguments[1]}";
    });
  });
  test('測試取得集點活動資料', () async {
    final campaign = await viewModel.init();

    expect(campaign, isNotNull);
    expect(campaign!.redeemItems, isNotEmpty);
  });
}
