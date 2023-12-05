import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:x50pay/common/app_route.dart';  
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/common/widgets/body_card.dart';
import 'package:x50pay/page/sign_up/sign_up_view_model.dart';
import 'package:x50pay/r.g.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends BaseStatefulState<SignUp> with BasePage {
  final viewModel = SignUpViewModel()
    ..floatHeaderText = '註冊頁'
    ..isFloatHeader = true
    ..isShowFooter = true;
  final email = TextEditingController();
  final nickName = TextEditingController();
  final password = TextEditingController();
  final rePassword = TextEditingController();
  final phone = TextEditingController();
  final dateOfBirth = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? pwd;
  String? rePwd;

  @override
  BaseViewModel? baseViewModel() => viewModel;
  @override
  void dispose() {
    email.dispose();
    nickName.dispose();
    password.dispose();
    rePassword.dispose();
    phone.dispose();
    dateOfBirth.dispose();
    super.dispose();
  }

  @override
  Widget body() {
    return ChangeNotifierProvider.value(
      value: viewModel,
      builder: (context, _) => BodyCard(
          child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('立即註冊', style: TextStyle(color: Color(0xff5a5a5a))),
            const SizedBox(height: 15),
            _title('電子郵件'),
            const SizedBox(height: 10),
            TextFormField(
                controller: email,
                decoration: const InputDecoration(hintText: '請注意驗證郵件將會送到此信箱'),
                keyboardType: TextInputType.emailAddress,
                validator: viewModel.isEmailValid),
            const SizedBox(height: 20),
            _title('暱稱'),
            const SizedBox(height: 10),
            TextFormField(
                controller: nickName,
                decoration: const InputDecoration(hintText: '我們才知道如何稱呼你'),
                validator: viewModel.isEmpty),
            const SizedBox(height: 20),
            _title('密碼'),
            const SizedBox(height: 10),
            TextFormField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(hintText: '請輸入密碼'),
                onChanged: (t) {
                  pwd = t;
                  viewModel.passwordChk(pwd, rePwd);
                },
                keyboardType: TextInputType.visiblePassword),
            const SizedBox(height: 20),
            _title('重複輸入密碼'),
            const SizedBox(height: 10),
            TextFormField(
                controller: rePassword,
                obscureText: true,
                decoration: const InputDecoration(hintText: '請重複輸入密碼'),
                onChanged: (t) {
                  rePwd = t;
                  viewModel.passwordChk(pwd, rePwd);
                },
                keyboardType: TextInputType.visiblePassword),
            const SizedBox(height: 20),
            _title('手機號碼', isOptional: true),
            const SizedBox(height: 10),
            TextFormField(
                controller: phone,
                decoration: const InputDecoration(hintText: '請輸入手機號碼'),
                keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            _title('生日'),
            const SizedBox(height: 10),
            TextFormField(
                controller: dateOfBirth,
                maxLength: 8,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '格式:19110101'),
                validator: viewModel.isDateValid),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Selector<SignUpViewModel, bool>(
                    selector: (context, vm) => vm.isPasswordValid,
                    builder: (context, isVaild, child) => TextButton(
                        onPressed: isVaild
                            ? () {
                                if (true) {
                                  // if (_formKey.currentState!.validate()) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          _EmailSent(email.text)));
                                }
                              }
                            : null,
                        style: Themes.confirm(),
                        child: Text(isVaild ? '送出' : '密碼錯誤')))
              ],
            )
          ],
        ),
      )),
    );
  }

  RichText _title(String text, {bool isOptional = false}) {
    return RichText(
        text: TextSpan(
            text: text,
            style: const TextStyle(color: Color(0xfffafafa)),
            children: [
          isOptional
              ? const TextSpan(text: ' (選填)')
              : const TextSpan(text: ' *', style: TextStyle(color: Colors.red))
        ]));
  }
}

class _EmailSent extends StatefulWidget {
  final String email;
  const _EmailSent(this.email);

  @override
  State<_EmailSent> createState() => __EmailSentState();
}

class __EmailSentState extends BaseStatefulState<_EmailSent> with BasePage {
  @override
  BaseViewModel? baseViewModel() => BaseViewModel()
    ..isFloatHeader = true
    ..floatHeaderText = '驗證郵件寄出'
    ..isShowFooter = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      context.goNamed(AppRoutes.login.routeName);
    });
  }

  @override
  Widget body() {
    return BodyCard(
      paddingOffset: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(image: R.image.logo_150_jpg()),
                  shape: BoxShape.circle)),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: const Color(0xffcddee4)),
                color: const Color(0xffe6eff2)),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Color(0xff72919e), size: 40),
                  const SizedBox(width: 30),
                  Expanded(
                      child: Text('驗證郵件已寄出，請進入${widget.email}收取謝謝! 五秒後將轉跳回首頁',
                          style: const TextStyle(color: Color(0xff72919e))))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
