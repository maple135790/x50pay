import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';
import 'package:x50pay/repository/repository.dart';

class MockRepository extends Mock implements Repository {}

final mockRepo = MockRepository();

void main() {
  setUp(() {
    when(mockRepo.fetchGradeBox).thenAnswer((_) async {
      const rawGradeBox =
          r'''{"card":[{"pic":"grade/gdebox.png","name":"testName","much":"12","limit":"2","gid":"testGid","eid":"testEid","heart":"50"}],"cd":[],"code":200,"gifts":[{"pic":"grade/gdebox.png","name":"testName","much":"12","limit":"2","gid":"testGid","eid":"testEid","heart":"50"},{"pic":"grade/gdebox.png","name":"testName","much":"12","limit":"2","gid":"testGid","eid":"testEid","heart":"50"}],"x50":[]}''';
      return rawGradeBox;
    });
  });
  test('測試取得GradeBoxModel', () async {
    final viewModel = GradeBoxViewModel(repository: mockRepo);
    final gradeBox = await viewModel.getGradeBox();
    expect(gradeBox, isNotNull);
  });
}
