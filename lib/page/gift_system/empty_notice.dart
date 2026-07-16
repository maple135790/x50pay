import 'package:flutter/material.dart';

class EmptyNotice extends StatelessWidget {
  const EmptyNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 52.5, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff232323),
        borderRadius: BorderRadius.circular(16.5),
      ),
      child: const Column(
        mainAxisSize: .min,
        children: [
          Icon(Icons.not_listed_location_rounded, size: 55),
          SizedBox(height: 15),
          Text('空空', style: TextStyle(fontSize: 17, fontWeight: .w600)),
          SizedBox(height: 3.75),
          Text(
            '啥都沒有。',
            style: TextStyle(fontSize: 15, color: Color(0xffb4b4b4)),
          ),
        ],
      ),
    );
  }
}
