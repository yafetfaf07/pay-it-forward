import 'package:flutter/material.dart';

class CharityCard extends StatelessWidget {
  const CharityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(30)
      ),
      child: Column(
        children: [
          Image.asset("images/star.png"),
          Text("Charity name")
        ],
      ),
    );
  }
}