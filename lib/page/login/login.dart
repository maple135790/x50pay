import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/global_singleton.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/login/login_view_model.dart';
import 'package:x50pay/r.g.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends BaseStatefulState<Login> with BasePage {
  final email = TextEditingController();
  final password = TextEditingController();
  final viewModel = LoginViewModel();

  @override
  void Function()? get debugFunction => () {
        email.text = 'test';
        password.text = 'test';
      };

  @override
  bool get isDarkHeader => true;

  String? _errorMsg;

  @override
  BaseViewModel? baseViewModel() => null;
  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
  }

  @override
  Widget body() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            SizedBox(
              height: constraints.maxWidth > 480 ? 300 : 220,
              width: constraints.maxWidth,
              child: Stack(
                children: [
                  Positioned.fill(child: Image(image: R.image.login_banner_jpg(), fit: BoxFit.fitWidth)),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.2, 1]),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('歡迎回來！',
                          style: TextStyle(
                              shadows: [Shadow(color: Colors.black, blurRadius: 25)],
                              fontSize: 17,
                              color: Color(0xe6ffffff))),
                      const SizedBox(height: 5),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                        Icon(Icons.schedule, size: 12, color: Colors.white),
                        Text(' 24Hr 年中無休', style: TextStyle(fontSize: 13, color: Color(0xe6ffffff)))
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                        Icon(Icons.pin_drop, size: 12, color: Colors.white),
                        Text(' X50 ：萬華區武昌街二段134號1樓', style: TextStyle(fontSize: 13, color: Color(0xe6ffffff)))
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                        Icon(Icons.restaurant, size: 12, color: Colors.white),
                        Text(' X40 ：士林區大南路49號2樓', style: TextStyle(fontSize: 13, color: Color(0xe6ffffff)))
                      ]),
                    ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border.all(color: const Color(0xff3e3e3e), width: 1),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _errorMsg == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  color: const Color(0xffF6E1DF),
                                  border: Border.all(color: const Color(0xffE5A9A5), width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  const Icon(Icons.priority_high, color: Color(0xffA1414C)),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('錯誤',
                                          style: TextStyle(color: Color(0xffA1414C), fontSize: 16)),
                                      Text(_errorMsg!, style: const TextStyle(color: Color(0xffA1414C))),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                    const Text('電子郵件'),
                    const SizedBox(height: 12),
                    TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.person))),
                    const SizedBox(height: 15),
                    RichText(
                        text: TextSpan(
                            text: '密碼 ',
                            style: const TextStyle(color: Color(0xfffafafa)),
                            children: [
                          const TextSpan(text: '( '),
                          TextSpan(
                              text: '忘記密碼嗎 ? ',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushNamed(AppRoute.forgotPassword);
                                },
                              style: const TextStyle(
                                  color: Color(0xfffafafa), decoration: TextDecoration.underline)),
                          const TextSpan(text: ' )')
                        ])),
                    const SizedBox(height: 12),
                    TextField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.lock))),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.white60),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (email.text.isEmpty || password.text.isEmpty) {
                                _errorMsg = '帳密不得為空';
                                setState(() {});
                                return;
                              }
                              final nav = Navigator.of(context);
                              final isSuccessLogin =
                                  await viewModel.login(email: email.text, password: password.text);
                              if (isSuccessLogin) {
                                int code = viewModel.response!.code;
                                if (code == 400) {
                                  _errorMsg = '帳號或密碼錯誤';
                                  setState(() {});
                                } else if (code == 401) {
                                  _errorMsg = 'Email尚未驗證，請先驗證信箱\n若有問題請聯絡X50粉絲團';
                                  setState(() {});
                                } else if (code == 402) {
                                  _errorMsg = 'nologin';
                                  setState(() {});
                                } else if (code != 200) {
                                  _errorMsg = '未知錯誤';
                                  setState(() {});
                                } else if (code == 200) {
                                  await GlobalSingleton.instance.checkUser(force: true);
                                  nav.pushReplacementNamed(AppRoute.home);
                                }
                              }
                            },
                            style: Themes.pale(),
                            child: const Text('登入')),
                        const SizedBox(width: 5),
                        Material(
                          type: MaterialType.transparency,
                          child: OutlinedButton(
                              onPressed: () async {
                                await signUpDialog(context);
                              },
                              style: Themes.severe(isV4: true),
                              child: const Text('註冊')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
                    const Text('四、本平台無積分、押分、退幣等功能。當使用者於本平台進行加值並放入鈔票時，即視同使用者同意消費，恕無法取消或找零。'),
                    const Text('五、消費 Point / 遊玩卷 前請確認欲遊玩模式與欲消費機台編號，付款成功後使用者不得要求任何形式之退款。'),
                    const Text(
                        '六、本店提供的所有優惠活動，均以活動公布之辦法為準，本店並有權隨時變更、暫停或終止任何進行中之活動，如獲得方式、使用方式、獲獎名額或使用期限等，並保有活動最終解釋權力。'),
                    const Text('七、本平台所提供的服務，包括使用者帳號、Point 、遊玩卷等資訊，一概禁止任何形式之轉移、販售、買賣行為。'),
                    const Text('八、使用本平台服務將視同您同意服務條款之約定辦理。如您不同意本使用條款中任何一項，請不要使用本平台所提供的任何服務。'),
                    const Text('\n'),
                    RichText(
                      text: TextSpan(
                          text: '完整版條款請點擊我閱讀',
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushNamed(AppRoute.license);
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
                    style: Themes.cancel(),
                    child: const Text('取消')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(AppRoute.signUp);
                    },
                    style: Themes.confirm(),
                    child: const Text('確認'))
              ],
            ));
  }
}
