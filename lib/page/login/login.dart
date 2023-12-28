import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences_debugger/shared_preferences_debugger.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/button_theme.dart';
import 'package:x50pay/page/login/login_view_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends BaseStatefulState<Login> with BasePage {
  late final bool enabledBiometricsLogin;
  late final Future<void> checkBiometricsLoginEnabled;
  final email = TextEditingController();
  final password = TextEditingController();
  final viewModel = LoginViewModel();

  GestureRecognizer onForgetPasswordTap = TapGestureRecognizer()
    ..onTap = () {
      launchUrlString(
        'https://pay.x50.fun/iforgot',
        mode: LaunchMode.externalApplication,
      );
    };

  @override
  void Function()? get debugFunction => () {
        email.text = 'test';
        password.text = 'test';
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SharedPreferencesDebugPage(),
          ),
        );
      };

  @override
  void initState() {
    super.initState();
    checkBiometricsLoginEnabled = viewModel.checkEnableBiometricsLogin();
    EasyLoading.dismiss();
    email.addListener(() {
      log(email.text, name: 'email');
    });
  }

  void onSignUpTap() async {
    launchUrlString(
      'https://pay.x50.fun/reg',
      mode: LaunchMode.externalApplication,
    );
  }

  /// 使用生物辨識登入
  void doBiometricsLogin() async {
    final auth = LocalAuthentication();
    FocusManager.instance.primaryFocus?.unfocus();

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: i18n.loginBiometricsReason,
      );
      if (!didAuthenticate) return;
      viewModel.biometricsLogin(
        onLoginSuccess: () {
          context.goNamed(AppRoutes.home.routeName);
        },
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        EasyLoading.showError('此裝置不支援生物辨識登入');
      } else if (e.code == auth_error.notEnrolled) {
        EasyLoading.showError('此裝置尚未設定生物辨識登入');
      } else {
        log('', error: e, name: 'doBiometricsLogin');
      }
    }
  }

  Widget showPasswordButton(LoginViewModel vm) {
    return GestureDetector(
      onTap: () {
        vm.hidePassword = !vm.hidePassword;
      },
      child: Icon(
        vm.hidePassword
            ? Icons.visibility_rounded
            : Icons.visibility_off_rounded,
        size: 20,
        color: isDarkTheme ? Colors.white38 : Colors.black38,
      ),
    );
  }

  Widget topImage(double maxWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3.75),
      child: SizedBox(
        height: maxWidth > 480 ? 300 : 220,
        width: maxWidth,
        child: Stack(
          children: [
            Positioned.fill(
                child: CachedNetworkImage(
              imageUrl: "https://pay.x50.fun/static/logo.jpg",
              color: const Color.fromARGB(35, 0, 0, 0),
              colorBlendMode: BlendMode.srcATop,
              fit: BoxFit.fitWidth,
              alignment: const Alignment(0, -0.25),
            )),
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    colors: [Colors.black, Colors.transparent],
                    transform: GradientRotation(12),
                    stops: [0, 0.6],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i18n.loginWelcome,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        i18n.loginSub,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xe6ffffff),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget errorNotice(String? errorMsg) {
    if (errorMsg == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.symmetric(vertical: 6.75, horizontal: 15),
      decoration: const BoxDecoration(color: Color(0xfff5222d)),
      child: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 4.5, horizontal: 7.5),
              child: Text(i18n.loginError,
                  style: const TextStyle(color: Color(0xffcf1322)))),
          const SizedBox(width: 15),
          Text(errorMsg),
        ],
      ),
    );
  }

  /// 輸入帳號密碼的登入
  void doLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (email.text.isEmpty || password.text.isEmpty) {
      viewModel.errorMsg = '帳密不得為空';
      return;
    }

    viewModel.login(
      email: email.text,
      password: password.text,
      onLoginSuccess: () {
        context.goNamed(AppRoutes.home.routeName);
      },
    );
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void dropFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget body(BuildContext context) {
    return Material(
      child: ChangeNotifierProvider.value(
        value: viewModel,
        builder: (context, child) {
          return FutureBuilder(
              future: checkBiometricsLoginEnabled,
              builder: (context, snapshot) {
                return _loaded();
              });
        },
      ),
    );
  }

  Widget _loaded() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: dropFocus,
          child: Column(
            children: [
              topImage(constraints.maxWidth),
              Consumer<LoginViewModel>(
                builder: (context, vm, child) {
                  return errorNotice(vm.errorMsg);
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      border: Border.all(color: borderColor, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(i18n.loginEmail),
                        const SizedBox(height: 12),
                        TextField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.username],
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person)),
                        ),
                        const SizedBox(height: 15),
                        Text.rich(
                          TextSpan(
                            text: i18n.loginPassword,
                            children: [
                              const TextSpan(text: '( '),
                              TextSpan(
                                  text: i18n.loginForgotPassword,
                                  recognizer: onForgetPasswordTap,
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline)),
                              const TextSpan(text: ' )')
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer<LoginViewModel>(
                          builder: (context, vm, child) {
                            return TextField(
                                controller: password,
                                obscureText: vm.hidePassword,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: showPasswordButton(vm),
                                ));
                          },
                        ),
                        const SizedBox(height: 10),
                        Divider(color: borderColor),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextButton(
                              onPressed: doLogin,
                              style: CustomButtonThemes.cancel(
                                  isDarkMode: isDarkTheme),
                              child: Text(i18n.loginLogin),
                            ),
                            Consumer<LoginViewModel>(
                                builder: (context, vm, child) {
                              return TextButton(
                                onPressed: vm.enableBiometricsLogin
                                    ? doBiometricsLogin
                                    : null,
                                style: CustomButtonThemes.cancel(
                                    isDarkMode: isDarkTheme),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(i18n.loginBiometrics),
                                    const SizedBox(width: 15),
                                    const Icon(Icons.fingerprint_rounded)
                                  ],
                                ),
                              );
                            }),
                            const SizedBox(width: 5),
                            Material(
                              type: MaterialType.transparency,
                              child: TextButton(
                                  onPressed: onSignUpTap,
                                  style: CustomButtonThemes.severe(isV4: true),
                                  child: Text(i18n.loginSignUp)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
