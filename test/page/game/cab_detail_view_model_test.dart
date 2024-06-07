import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:x50pay/common/models/cabinet/cabinet.dart';
import 'package:x50pay/page/game/cab_detail_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();

void main() {
  final viewModel = CabDatailViewModel(
    repository: mockRepo,
    machineId: '2mmdx',
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({"store_id": "7037656"});

    when(() => mockRepo.selGame(any())).thenAnswer((_) async {
      const rawResponse =
          '''{"message":"done","code":200,"re":[["05-27 13:00 ~ 16:00","maiDX-\u2606\u897f\u9580\u4e8c\u5e97\u2605"]],"note":[0,"1F/\u9032\u9580\u53f3\u5074","1F/\u9032\u9580\u5de6\u524d",false,"one"],"cabinet":[{"num":1,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u53f3 (DX\u6846\u6309\u9375)","busy":"<i style='color:red; margin-left:3px;' class='users icon'></i>\u5fd9\u788c","nbusy":"\u5fd9\u788c","pcl":true},{"num":2,"id":"2mmdx","lable":"[\u897f\u9580\u4e8c\u5e97] maimaiDX","mode":[[0,"\u55ae\u4eba\u904a\u73a9",25],[1,"\u96d9\u4eba\u904a\u73a9(\u6263\u5169\u5f35\u5238)",50]],"card":false,"bool":true,"vipbool":true,"notice":"\u5de6 (DX\u6846\u6309\u9375)","busy":"<i style='color:blue; margin-left:3px;' class='user icon'></i>\u9069\u4e2d","nbusy":"\u9069\u4e2d","pcl":true}],"caboid":"632904081eb45d31f0a1185c","pad":true,"padmid":"50Pad02","padlid":"twommdx"}''';
      return CabinetModel.fromJson(json.decode(rawResponse));
    });
    when(() => mockRepo.getPadLineup(any(), any())).thenAnswer((_) async {
      return 2;
    });
  });
  test('測試取得遊戲機台資料', () async {
    final result = await viewModel.getSelGameCab();
    expect(result, true);
  });
  test('測試取得排隊人數', () async {
    final result = await viewModel.getPadLineup('2mmdx', '50Pad02');
    expect(result, isNonNegative);
  });
}
