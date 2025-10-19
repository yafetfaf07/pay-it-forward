import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  final String id;
  Dashboard({super.key, required this.id});
  String name = "";
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
        widget.name = merchantResponse['data']['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        toolbarHeight: 60,
        foregroundColor: const Color.fromARGB(255, 129, 98, 4),
        backgroundColor: const Color.fromARGB(255, 252, 251, 247),
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
        ],
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
      ),
      body: SizedBox(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 148,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'images/star.png',
                            height: 20,
                            color: const Color.fromARGB(83, 37, 37, 37),
                          ),
                          Text(
                            "👋🏼👋🏼Hello, ${widget.name}",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: const Color.fromARGB(255, 49, 49, 49),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'images/star.png',
                            height: 20,
                            color: const Color.fromARGB(83, 37, 37, 37),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "\$673",
                    style: GoogleFonts.geologica(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        'images/star.png',
                        height: 20,
                        color: const Color.fromARGB(83, 37, 37, 37),
                      ),

                      Text(
                        "Total donations",
                        style: GoogleFonts.geologica(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 168, 168, 168),
                        ),
                      ),
                      Image.asset(
                        'images/star.png',
                        height: 20,
                        color: const Color.fromARGB(83, 37, 37, 37),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
