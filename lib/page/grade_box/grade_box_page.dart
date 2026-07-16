import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/page/grade_box/grade_box_loaded.dart';
import 'package:x50pay/page/grade_box/grade_box_view_model.dart';
import 'package:x50pay/providers/user_provider.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class GradeBoxPage extends StatefulWidget {
  /// 養成商場頁面
  const GradeBoxPage({super.key});

  @override
  State<GradeBoxPage> createState() => _GradeBoxPageState();
}

class _GradeBoxPageState extends State<GradeBoxPage> with AppFeedbackMixin {
  late final GradeBoxViewModel viewModel;
  late Future<bool> init;

  @override
  void initState() {
    super.initState();
    viewModel = GradeBoxViewModel(
      repository: context.read<MainRepository>(),
      userProvider: context.read<UserProvider>(),
      feedback: this,
    );
    init = viewModel.getGradeBox();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ChangeNotifierProvider.value(
        value: viewModel,
        builder: (context, child) => FutureBuilder(
          future: init,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: kDebugMode ? Text('not done') : null);
            }
            if (!snapshot.hasData) {
              return Center(child: kDebugMode ? Text(serviceErrorText) : null);
            }
            if (snapshot.data != true) {
              return Center(child: kDebugMode ? Text(serviceErrorText) : null);
            }
            return const GradeBoxLoaded();
          },
        ),
      ),
    );
  }
}
