import 'package:flutter/material.dart';

class BodyCard extends StatelessWidget {
  final Widget child;
  final double paddingOffset;
  const BodyCard({super.key, required this.child, this.paddingOffset = 30});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      // margin:  EdgeInsets.zero,
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Padding(padding: EdgeInsets.all(paddingOffset), child: child),
      ),
    );
  }
}
