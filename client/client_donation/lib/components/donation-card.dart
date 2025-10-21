import 'package:flutter/material.dart';

class DonationCard extends StatelessWidget {
  const DonationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      margin: EdgeInsets.symmetric(vertical:10, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0, top:5.0),
                child: Text("HB Foundation",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0, bottom: 5.0),
                child: Text("Oct 12 2025, 10:40 A.M", style: TextStyle(
                  color: Colors.grey, fontSize: 12
                ),),
              ),
            ],
          ),

          Text("\$5", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
