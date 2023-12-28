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
  bool get isDarkHeader => true;

  @override
  BaseViewModel? baseViewModel() => null;

  @override
  void initState() {
    super.initState();
    checkBiometricsLoginEnabled = viewModel.checkEnableBiometricsLogin();
    EasyLoading.dismiss();
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

  @override
  Widget body() {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, child) {
        return FutureBuilder(
            future: checkBiometricsLoginEnabled,
            builder: (context, snapshot) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3.75),
                        child: SizedBox(
                          height: constraints.maxWidth > 480 ? 300 : 220,
                          width: constraints.maxWidth,
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
                                      colors: [
                                        Colors.black,
                                        Colors.transparent
                                      ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(i18n.loginWelcome,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          )),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.schedule_rounded,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(i18n.loginSub,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xe6ffffff),
                                                ))
                                          ]),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                                Text.rich(TextSpan(
                                    text: i18n.loginPassword,
                                    children: [
                                      const TextSpan(text: '( '),
                                      TextSpan(
                                          text: i18n.loginForgotPassword,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // context.pushNamed(
                                              //     AppRoutes.forgotPassword.routeName);
                                              launchUrlString(
                                                'https://pay.x50.fun/iforgot',
                                                mode: LaunchMode
                                                    .externalApplication,
                                              );
                                            },
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.underline)),
                                      const TextSpan(text: ' )')
                                    ])),
                                const SizedBox(height: 12),
                                Consumer<LoginViewModel>(
                                  builder: (context, vm, child) => TextField(
                                      controller: password,
                                      obscureText: vm.hidePassword,
                                      textInputAction: TextInputAction.done,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      autofillHints: const [
                                        AutofillHints.password
                                      ],
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                          onLongPressDown: (_) {
                                            vm.hidePassword = false;
                                          },
                                          onTapDown: (details) {
                                            vm.hidePassword = false;
                                          },
                                          onTapCancel: () {
                                            vm.hidePassword = true;
                                          },
                                          onLongPressCancel: () {
                                            vm.hidePassword = true;
                                          },
                                          onTapUp: (details) {
                                            vm.hidePassword = true;
                                          },
                                          onLongPressUp: () {
                                            vm.hidePassword = true;
                                          },
                                          child: Icon(
                                            Icons.remove_red_eye,
                                            color: isDarkTheme
                                                ? Colors.white38
                                                : Colors.black38,
                                          ),
                                        ),
                                      )),
                                ),
                                const SizedBox(height: 10),
                                Divider(color: borderColor),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(i18n.loginBiometrics),
                                            const SizedBox(width: 15),
                                            const Icon(
                                                Icons.fingerprint_rounded)
                                          ],
                                        ),
                                      );
                                    }),
                                    const SizedBox(width: 5),
                                    Material(
                                      type: MaterialType.transparency,
                                      child: TextButton(
                                          onPressed: () async {
                                            // await signUpDialog(context);
                                            launchUrlString(
                                              'https://pay.x50.fun/reg',
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          style: CustomButtonThemes.severe(
                                              isV4: true),
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
                  );
                },
              );
            });
      },
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
                  borderRadius: BorderRadius.circular(4), color: Colors.white),
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

  Future<dynamic> signUpDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('請閱讀會員條款'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('一、本平台只提供本店及經本店授權之店家內服務使用，除上述以外的其他店家不可使用。'),
                    const Text(
                        '二、基於保障帳戶安全原則，本服務所需之使用者個人資料提供僅用於註冊、系統登入驗證使用，但當本平台認為有必要性時不在此限，例如：使用者參加本平台舉辦活動獲獎後發送領獎通知。'),
                    const Text(
                        '三、使用者應保證所提供之資料及個人資訊為正確且完整，若有虛假或不實之情形導致無法繼續使用本服務，使用者需自行承擔。如果使用者發現有錯誤，請通知X50粉絲專頁更正。'),
                    const Text(
                        '四、本平台無積分、押分、退幣等功能。當使用者於本平台進行加值並放入鈔票時，即視同使用者同意消費，恕無法取消或找零。'),
                    const Text(
                        '五、消費 Point / 遊玩卷 前請確認欲遊玩模式與欲消費機台編號，付款成功後使用者不得要求任何形式之退款。'),
                    const Text(
                        '六、本店提供的所有優惠活動，均以活動公布之辦法為準，本店並有權隨時變更、暫停或終止任何進行中之活動，如獲得方式、使用方式、獲獎名額或使用期限等，並保有活動最終解釋權力。'),
                    const Text(
                        '七、本平台所提供的服務，包括使用者帳號、Point 、遊玩卷等資訊，一概禁止任何形式之轉移、販售、買賣行為。'),
                    const Text(
                        '八、使用本平台服務將視同您同意服務條款之約定辦理。如您不同意本使用條款中任何一項，請不要使用本平台所提供的任何服務。'),
                    const Text('\n'),
                    RichText(
                      text: TextSpan(
                          text: '完整版條款請點擊我閱讀',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pushNamed(AppRoutes.license.routeName);
                            }),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: CustomButtonThemes.cancel(isDarkMode: isDarkTheme),
                    child: const Text('取消')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushNamed(AppRoutes.signUp.routeName);
                    },
                    style: CustomButtonThemes.severe(),
                    child: const Text('確認'))
              ],
            ));
  }
}
