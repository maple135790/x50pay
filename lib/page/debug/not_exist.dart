import 'package:flutter/material.dart';

class NotExist extends StatelessWidget {
  const NotExist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('not exist yet')),
    );
  }
}
