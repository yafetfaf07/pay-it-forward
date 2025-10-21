import 'dart:convert';
import 'dart:typed_data';

import 'package:client_donation/components/donation-card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';

class Dashboard extends StatefulWidget {
  final String id;
  Dashboard({super.key, required this.id});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserName(
        "https://pay-it-forward-ez0v.onrender.com/api/users/getUsername/${widget.id}",
      );
    });
  }

  Future<void> getUserName(String merchants) async {
    print("Where you callued");
    var merchantUrl = Uri.parse(merchants);
    final response = await http.get(
      merchantUrl,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      dynamic merchantResponse = json.decode(response.body);
      print(merchantResponse);
      setState(() {
        name = merchantResponse['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(title: Text("Scan QR Code")),
                    body: MobileScanner(
                      controller: MobileScannerController(
                        returnImage: true,
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                      onDetect: (capture) {
                        final List<Barcode> barcodes=capture.barcodes;
                        final Uint8List? image = capture.image;
                        for (final barcode in barcodes) {
                          print("Barcode found! hip hip hooooorrrrrrrrrrrrrrrrrrrrraay:  ${barcode.rawValue}");
                        }
                      if(image!=null) {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text(barcodes.first.rawValue ?? ""),
                            content: Image(
                              image: MemoryImage(image),
                            ),
                          );
                        });
                      }
                      },
                    ),
                  ),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(202, 115, 64, 255),
        foregroundColor: Colors.grey.shade100,
        child: Icon(Icons.qr_code_scanner_outlined),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(202, 115, 64, 255),
        elevation: 0,
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
        ],
        leading: IconButton(
          iconSize: 30,
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 148,
              decoration: BoxDecoration(
                color: const Color.fromARGB(202, 115, 64, 255),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
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
                            "Hello, $name",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: const Color.fromARGB(255, 255, 255, 255),
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
                      color: Colors.white,
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
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Donations",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Keep up the good work!! 💯🚀",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return DonationCard();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Chairty News & Updates",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
