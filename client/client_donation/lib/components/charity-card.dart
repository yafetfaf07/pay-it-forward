import 'package:flutter/material.dart';

class CharityCard extends StatelessWidget {
  final String name;
  final String phone;
  const CharityCard({super.key, required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(30)
      ),
      child: Column(
        children: [
          Image.asset("images/caleb-foundation.png"),
          Text(name),
          SelectableText(phone)
        ],
      ),
    );
  }
}