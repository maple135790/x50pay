import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base_page.dart';
import 'package:x50pay/common/base/base_stateful_state.dart';
import 'package:x50pay/common/base/base_view_model.dart';
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
                  Positioned.fill(child: Image(image: R.image.login_banner_jpg(), fit: BoxFit.none)),
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
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('歡迎回來！',
                          style: TextStyle(
                              shadows: [Shadow(color: Colors.black, blurRadius: 25)],
                              fontSize: 26,
                              color: Color(0xe6ffffff))),
                      const SizedBox(height: 5),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                        Icon(Icons.schedule, size: 12, color: Colors.white),
                        Text(' 24Hr 年中無休', style: TextStyle(fontSize: 12, color: Color(0xe6ffffff)))
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                        Icon(Icons.pin_drop, size: 12, color: Colors.white),
                        Text(' X50 ：萬華區武昌街二段134號1樓', style: TextStyle(fontSize: 12, color: Color(0xe6ffffff)))
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
                        Icon(Icons.pin_drop, size: 12, color: Colors.white),
                        Text(' X40 ：士林區大南路49號2樓', style: TextStyle(fontSize: 12, color: Color(0xe6ffffff)))
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
                  const Text('立即登入會員系統', style: TextStyle(color: Color(0xff5a5a5a))),
                  const SizedBox(height: 15),
                  const Text('電子郵件'),
                  const SizedBox(height: 12),
                  TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1)),
                      )),
                  const SizedBox(height: 15),
                  RichText(
                      text: TextSpan(text: '密碼 ', style: const TextStyle(color: Colors.black), children: [
                    const TextSpan(text: '( '),
                    TextSpan(
                        text: '忘記密碼嗎?',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamed(AppRoute.forgotPassword);
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
                          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide(color: Colors.blue, width: 1)))),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: OutlinedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                backgroundColor: MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color(0xffCE5F58);
                                  }
                                  return Colors.white;
                                }),
                                foregroundColor: MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return Colors.white;
                                  }
                                  return const Color(0xffCE5F58);
                                }),
                                side: MaterialStateProperty.all(
                                    const BorderSide(color: Color(0xffCE5F58), width: 1))),
                            child: const Text('註冊')),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color(0xff677A40);
                              }
                              return const Color(0xff8bb96e);
                            }),
                          ),
                          child: const Text('登入', style: TextStyle(color: Colors.white)))
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
