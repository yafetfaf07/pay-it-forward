import 'dart:convert';
import 'dart:typed_data';

import 'package:client_donation/components/bottom_navigation.dart';
import 'package:client_donation/components/donation-card.dart';
import 'package:client_donation/pages/charity.dart';
import 'package:client_donation/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Dashboard extends StatefulWidget {
  final String id;
  Dashboard({super.key, required this.id});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  int selectedIndex = 0;
  bool isLoading = true;
  bool isOffline = false;

  @override
  void initState() {
    super.initState();
    checkConnectivityAndFetch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkConnectivityAndFetch() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isOffline = true;
        isLoading = false;
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserName(
        "https://pay-it-forward-ez0v.onrender.com/api/users/getUsername/${widget.id}",
      );
    });
  }

  Future<void> getUserName(String merchants) async {
    setState(() {
      isLoading = true;
    });

    try {
      var merchantUrl = Uri.parse(merchants);
      final response = await http.get(
        merchantUrl,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        dynamic merchantResponse = json.decode(response.body);
        print(merchantResponse);
        if (mounted) {
          setState(() {
            name = merchantResponse['data'];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to fetch username'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching username: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void onChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> get pages => [
        _buildHomePage(),
        Charity(),
        Profile(),
      ];

  Widget _buildHomePage() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text("Scan QR Code"),
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.chevron_left),
                  ),
                ),
                body: MobileScanner(
                  controller: MobileScannerController(
                    facing: CameraFacing.back,
                    cameraResolution: Size(100, 200),
                    returnImage: true,
                    detectionSpeed: DetectionSpeed.noDuplicates,
                  ),
                  onDetect: (capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    final Uint8List? image = capture.image;
                    if (image != null) {
                      final url = barcodes.first.rawValue;
                      if (url != null && url.isNotEmpty) {
                        final uri = Uri.tryParse(url);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ Invalid URL or cannot launch: $url'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('❌ No URL found in QR code'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
      body: isOffline
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    "No Internet Connection",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please check your connection and try again",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: checkConnectivityAndFetch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(202, 115, 64, 255),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Retry"),
                  ),
                ],
              ),
            )
          : isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: const Color.fromARGB(202, 115, 64, 255),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Loading your profile...",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
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
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color.fromARGB(255, 227, 227, 227),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: selectedIndex,
        onChange: onChange,
      ),
    );
  }
}