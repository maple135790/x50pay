import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/common/widgets/body_card.dart';
import 'package:x50pay/r.g.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends BaseStatefulState<Login> with BasePage {
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  BaseViewModel? baseViewModel() => null;

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
                  Positioned.fill(
                      child: Image(
                          image: R.image.login_banner_jpg(), fit: BoxFit.none)),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.1, 1]),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('歡迎回來！',
                              style: TextStyle(shadows: [
                                Shadow(color: Colors.black, blurRadius: 25)
                              ], fontSize: 26, color: Color(0xe6ffffff))),
                          const SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.schedule,
                                    size: 12, color: Colors.white),
                                Text(' 24Hr 年中無休',
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xe6ffffff)))
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.pin_drop,
                                    size: 12, color: Colors.white),
                                Text(' X50 ：萬華區武昌街二段134號1樓',
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xe6ffffff)))
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(Icons.pin_drop,
                                    size: 12, color: Colors.white),
                                Text(' X40 ：士林區大南路49號2樓',
                                    style: TextStyle(
                                        fontSize: 12, color: Color(0xe6ffffff)))
                              ]),
                        ]),
                  ),
                ],
              ),
            ),
            BodyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('立即登入會員系統',
                      style: TextStyle(color: Color(0xff5a5a5a))),
                  const SizedBox(height: 15),
                  const Text('電子郵件'),
                  const SizedBox(height: 12),
                  TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1)),
                      )),
                  const SizedBox(height: 15),
                  RichText(
                      text: TextSpan(
                          text: '密碼 ',
                          style: const TextStyle(color: Colors.black),
                          children: [
                        const TextSpan(text: '( '),
                        TextSpan(
                            text: '忘記密碼嗎?',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context)
                                    .pushNamed(AppRoute.forgotPassword);
                              },
                            style: const TextStyle(color: Colors.blue)),
                        const TextSpan(text: ' )')
                      ])),
                  const SizedBox(height: 12),
                  TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1)))),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: OutlinedButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text('請閱讀會員條款'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                  '一、本平台只提供本店及經本店授權之店家內服務使用，除上述以外的其他店家不可使用。'),
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
                                                    style: const TextStyle(
                                                        color: Colors.blue),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    AppRoute
                                                                        .license);
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
                                                Navigator.of(context)
                                                    .popAndPushNamed(
                                                        AppRoute.signUp);
                                              },
                                              style: Themes.confirm(),
                                              child: const Text('確認'))
                                        ],
                                      ));
                            },
                            style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color(0xffCE5F58);
                                  }
                                  return Colors.white;
                                }),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white;
                                  }
                                  return const Color(0xffCE5F58);
                                }),
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        color: Color(0xffCE5F58), width: 1))),
                            child: const Text('註冊')),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                          onPressed: () {},
                          style: Themes.confirm(),
                          child: const Text('登入',
                              style: TextStyle(color: Colors.white)))
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
