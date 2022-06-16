import 'package:flutter/material.dart';

class BodyCard extends StatelessWidget {
  final Widget child;
  const BodyCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Padding(padding: const EdgeInsets.all(30), child: child),
      ),
    );
  }
}
