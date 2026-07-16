import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_service_mixin.dart';
import 'package:x50pay/page/gift_system/gift_page_loaded.dart';
import 'package:x50pay/page/gift_system/gift_system_view_model.dart';
import 'package:x50pay/repository/main_repository/main_repository.dart';

class GiftPage extends StatefulWidget {
  /// 禮物系統頁面
  const GiftPage({super.key});

  @override
  State<GiftPage> createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> with AppFeedbackMixin {
  late final GiftPageViewModel viewModel;
  late Future<void> init;

  @override
  void initState() {
    super.initState();
    viewModel = GiftPageViewModel(
      repository: context.read<MainRepository>(),
      feedbackMixin: this,
    );
    init = viewModel.init();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: FutureBuilder(
        future: init,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: kDebugMode ? Text('not done') : null);
          }
          if (snapshot.hasError) {
            showServiceError();
            return Center(child: Text(serviceErrorText));
          }
          if (EasyLoading.isShow) EasyLoading.dismiss();
          return const GiftPageLoaded();
        },
      ),
    );
  }
}
