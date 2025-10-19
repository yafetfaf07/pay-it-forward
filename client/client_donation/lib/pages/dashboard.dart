import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final String id;
    Dashboard({super.key, required this.id});
    String name="";
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserName("http://localhost:5000/api/users/getUsername/${widget.id}");
    });
  }

  Future<void> getUserName(String merchants) async {
    var merchantUrl = Uri.parse(merchants);
    final response = await http.get(
      merchantUrl,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      dynamic merchantResponse = json.decode(response.body);
      setState(() {
      widget.name=merchantResponse['data']['name'];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        toolbarHeight: 60,
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFFFC107),
        elevation: 2,
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.notifications_outlined))
        ],
        leading: IconButton(onPressed: () {

        }, icon: Icon(Icons.menu)),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
           Text("Good Morning, ${widget.name}", style: GoogleFonts.poppins(fontSize: 24, color: Color(0xFF8E6262, ), fontWeight: FontWeight.w500),)
          ],
        ),
      ),
    );
  }
}