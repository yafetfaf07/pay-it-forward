import 'package:client_donation/components/charity-card.dart';
import 'package:flutter/material.dart';

class Charity extends StatelessWidget {
  const Charity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charities"),
      ),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2),
          scrollDirection: Axis.vertical,
          itemCount: 5,
          itemBuilder: (index, context) {
            return CharityCard();
        })
      ),
    );
  }
}