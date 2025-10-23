import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CharityNews extends StatelessWidget {
  final String name;
  final String description;
  const CharityNews({super.key, required this.name, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadiusGeometry.only(topLeft:Radius.circular(10), topRight: Radius.circular(10)),child: Image.asset("images/static.png", width: 270)),
          Padding(
            padding: const EdgeInsets.only(top:8.0, left: 8.0),
            child: Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerRight,
            child: Text("Posted on Oct 12 2025"),
          ),
        ],
      ),
    );
  }
}
