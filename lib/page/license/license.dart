import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/widgets/body_card.dart';
import 'package:x50pay/page/license/license_view_model.dart';
import 'package:x50pay/r.g.dart';

class License extends StatefulWidget {
  const License({Key? key}) : super(key: key);

  @override
  State<License> createState() => _LicenseState();
}

class _LicenseState extends BaseStatefulState<License> with BasePage {
  final viewModel = LicenseViewModel()
    ..isFloatHeader = true
    ..isHeaderBackType = true;

  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    return BodyCard(
      child: ChangeNotifierProvider.value(
        value: viewModel,
        builder: (context, _) => Consumer<LicenseViewModel>(
          builder: (context, vm, _) => FutureBuilder<String>(
            future: vm.getLicense(),
            initialData: '',
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return const Text('loading');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: R.image.logo_150_jpg(),
                              fit: BoxFit.fill))),
                  const SizedBox(height: 30),
                  Text(snapshot.data!)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
