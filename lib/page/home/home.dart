import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:x50pay/common/app_route.dart';
import 'package:x50pay/common/base/base.dart';
import 'package:x50pay/common/theme/theme.dart';
import 'package:x50pay/page/home/home_view_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends BaseStatefulState<Home> with BasePage {
  final viewModel = HomeViewModel();
  @override
  BaseViewModel? baseViewModel() => viewModel;

  @override
  Widget body() {
    return Column(
      children: [
        Theme(
          data: ThemeData(
              textTheme: const TextTheme(
                  bodyText1: TextStyle(color: Colors.white),
                  bodyText2: TextStyle(color: Colors.white),
                  subtitle1: TextStyle(color: Colors.white)),
              iconTheme: const IconThemeData(color: Colors.white)),
          child: Container(
            color: const Color(0xff333333),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Row(
                    children: [
                      FutureBuilder<ImageProvider<Object>>(
                          future: viewModel.getUserImage(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState != ConnectionState.done) {
                              return const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Color(0xff999999),
                                  child: Icon(Icons.person, size: 65, color: Colors.white));
                            }
                            return Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(image: snapshot.data!, fit: BoxFit.fill)));
                          }),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                            const Icon(Icons.person),
                            FutureBuilder<String>(
                                future: viewModel.getUserName(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState != ConnectionState.done) return const Text('');
                                  return Text(snapshot.data!,
                                      style: const TextStyle(color: Colors.white, fontSize: 20));
                                })
                          ]),
                          const SizedBox(height: 5),
                          Row(children: [
                            const Icon(Icons.perm_contact_cal),
                            FutureBuilder<String>(
                                future: viewModel.getUserId(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState != ConnectionState.done) {
                                    return const Text('');
                                  }
                                  return Text('ID : ${snapshot.data!}',
                                      style: const TextStyle(color: Colors.white));
                                })
                          ])
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                          onTap: () {}, child: const Icon(Icons.qr_code, size: 45, color: Color(0xff5a5a5a))),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text('月票', style: TextStyle(color: Colors.white)),
                          FutureBuilder<bool>(
                            future: viewModel.getMPassStatus(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState != ConnectionState.done) {
                                return const Text('---', style: TextStyle(color: Colors.white, fontSize: 20));
                              }
                              if (snapshot.data!) {
                                return const Text('已購買', style: TextStyle(color: Colors.white, fontSize: 20));
                              } else {
                                return RichText(
                                    text: TextSpan(
                                        text: '購買月票',
                                        style: const TextStyle(color: Colors.blue, fontSize: 20),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).pushNamed(AppRoute.buyMPass);
                                          }));
                              }
                            },
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const Text('餘點', style: TextStyle(color: Colors.white)),
                          FutureBuilder<int>(
                            future: viewModel.getPointCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState != ConnectionState.done) {
                                return const Text('0', style: TextStyle(color: Colors.white, fontSize: 30));
                              }
                              return Text(snapshot.data!.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 30));
                            },
                          )
                        ],
                      ),
                      Column(
                        children: [
                          const Text('遊玩券', style: TextStyle(color: Colors.white)),
                          FutureBuilder<int>(
                            future: viewModel.getTicketCount(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState != ConnectionState.done) {
                                return const Text('0', style: TextStyle(color: Colors.white, fontSize: 30));
                              }
                              return Text(snapshot.data!.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 30));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {}, style: Themes.confirm(), child: const Text('西門店夜間開門')))
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
