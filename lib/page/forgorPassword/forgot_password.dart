import 'package:flutter/material.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/widgets/body_card.dart';
import 'package:x50pay/page/forgorPassword/forgot_password_view_model.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends BaseStatefulState<ForgotPassword>
    with BasePage {
  final email = TextEditingController();
  final viewModel = ForgotPasswordViewModel()
    ..floatHeaderText = '忘記密碼'
    ..isFloatHeader = true
    ..isShowFooter = true;

  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    return BodyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('忘記密碼', style: TextStyle(color: Color(0xff5a5a5a))),
          const SizedBox(height: 15),
          RichText(
              text: const TextSpan(
                  text: '電子郵件',
                  style: TextStyle(color: Color(0xfffafafa)),
                  children: [
                TextSpan(text: '*', style: TextStyle(color: Colors.red))
              ])),
          const SizedBox(height: 12),
          TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '請注意驗證郵件將會送到此信箱',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1)),
              )),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff8bb96e))),
                  child: const Text('寄送重置密碼郵件',
                      style: TextStyle(color: Colors.white))),
            ],
          )
        ],
      ),
    );
  }
}
