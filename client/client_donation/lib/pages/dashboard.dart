import 'dart:convert';
import 'dart:typed_data';

import 'package:client_donation/components/charity-news.dart';
import 'package:client_donation/components/donation-card.dart';
import 'package:client_donation/main.dart';
import 'package:client_donation/pages/charity.dart';
import 'package:client_donation/pages/profile.dart';
import 'package:client_donation/services/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Dashboard extends StatefulWidget {
  final dynamic id;
  const Dashboard({super.key, required this.id});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  int totalDonation = 0;
  int selectedIndex = 0;
  bool isLoading = true;
  bool isOffline = false;
  List<dynamic> getDonationData = [];
  List<dynamic> getPostData = [];
  List<dynamic> getCharityData = [];
  Map<String, dynamic> userId = {};
  ApiService _service = ApiService();
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
      Map<String, dynamic> id = JwtDecoder.decode(widget.id);
      setState(() {
        userId = id;
      });
      dynamic charityResponse = _service.getAllCharities(
        "https://pay-it-forward-ez0v.onrender.com/api/charities/getAll",
      );

      getUserName(
        "https://pay-it-forward-ez0v.onrender.com/api/users/getUsername/${id['id']}",
      );
      getUserDonation(
        "https://pay-it-forward-ez0v.onrender.com/api/payments/getTotalAmountByUserId/${id['id']}",
      );
      getListOfRecentDonations(
        "https://pay-it-forward-ez0v.onrender.com/api/payments/getPaymentsByUserId/${id['id']}",
      );
      getListOfPost(
        "https://pay-it-forward-ez0v.onrender.com/api/posts/getAllpost",
      );
    });
  }

  Future<void> getListOfPost(String postUrl) async {
    setState(() {
      isLoading = true;
    });

    try {
      var merchantUrl = Uri.parse(postUrl);
      final response = await http.get(
        merchantUrl,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> charityResponse = responseBody['data'] ?? [];
        if (mounted) {
          setState(() {
            getPostData = charityResponse;
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
              content: Text(
                'Failed to fetch Charity News: ${response.statusCode}',
              ),
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
            content: Text('Error fetching Charity news: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  Future<void> getListOfRecentDonations(String merchants) async {
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
        Map<String, dynamic> responseBody = json.decode(response.body);
        List<dynamic> charityResponse = responseBody['data'] ?? [];
        if (mounted) {
          setState(() {
            getDonationData = charityResponse;
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
              content: Text(
                'Failed to fetch recent donations: ${response.statusCode}',
              ),
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
            content: Text('Error fetching recent donations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> getUserDonation(String merchants) async {
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
        if (mounted) {
          setState(() {
            totalDonation = merchantResponse['data']['totalAmount'];
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
              content: Text('Failed to get total donations'),
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
            content: Text('Error fetching total donations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to validate QR code data
  String? _validateQRCodeData(List<Barcode> barcodes, Uint8List? image) {
    if (image != null) {
      final url = barcodes.first.rawValue;
      if (url == null || url.isEmpty) {
        return null;
      }
      _showDonationDialog(url);
      return url;
    }
    return null;
  }

  // Function to show error SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('❌ $message'), backgroundColor: Colors.red),
    );
  }

  // Function to show donation dialog and handle donation
  Future<void> _showDonationDialog(String url) async {
    TextEditingController amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Make a Donation',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter the amount you wish to donate:',
                    style: GoogleFonts.poppins(),
                  ),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount (\$)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final amount = double.parse(amountController.text);
                    Navigator.of(context).pop();
                    await _makeDonation(widget.id, amount, url);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(202, 115, 64, 255),
                  foregroundColor: Colors.white,
                ),
                child: Text('Donate', style: GoogleFonts.poppins()),
              ),
            ],
          ),
    );
  }

  // Function to make POST request for donation
  Future<void> _makeDonation(String uid, double amount, String url) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://pay-it-forward-ez0v.onrender.com/api/payments/createPayment",
        ),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "uid": userId['id'],
          "charity_id": "68f9044a01eedfc951d97c48",
          "amount": amount,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          } else {
            throw 'Could not launch $url';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Donation successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          _showErrorSnackBar('Failed to process donation');
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error processing donation: $e');
      }
    }
  }

  // Function to handle QR code detection
  Future<void> _handleQRCodeDetection(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    final Uint8List? image = capture.image;
    final url = _validateQRCodeData(barcodes, image);
    if (url == null) {
      _showErrorSnackBar('No valid URL found in QR code');
      return;
    }
  }

  List<Widget> get pages => [_buildHomePage(), Charity(), Profile()];

  Widget _buildHomePage() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => Scaffold(
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
                        returnImage: true,
                        detectionSpeed: DetectionSpeed.noDuplicates,
                      ),
                      onDetect: _handleQRCodeDetection,
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              iconSize: 30,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromARGB(202, 115, 64, 255),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome to Ligesa',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.grey.shade700),
              title: Text('Home', style: GoogleFonts.poppins()),
              selected: selectedIndex == 0,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.volunteer_activism,
                color: Colors.grey.shade700,
              ),
              title: Text('Charity', style: GoogleFonts.poppins()),
              selected: selectedIndex == 1,
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.grey.shade700),
              title: Text('Profile', style: GoogleFonts.poppins()),
              selected: selectedIndex == 2,
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey.shade700),
              title: Text('Settings', style: GoogleFonts.poppins()),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Settings page not implemented yet')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.grey.shade700),
              title: Text('Logout', style: GoogleFonts.poppins()),
              onTap: () {
                ApiService().logout(
                  "https://pay-it-forward-ez0v.onrender.com/api/users/logout",
                );
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
        ),
      ),
      body:
          isOffline
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
                        backgroundColor: const Color.fromARGB(
                          202,
                          115,
                          64,
                          255,
                        ),
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
              : RefreshIndicator(
                color: const Color.fromARGB(202, 115, 64, 255),
                onRefresh: checkConnectivityAndFetch,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'images/star.png',
                                      height: 20,
                                      color: const Color.fromARGB(
                                        83,
                                        37,
                                        37,
                                        37,
                                      ),
                                    ),
                                    Text(
                                      "Hello, $name",
                                      style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        color: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Image.asset(
                                      'images/star.png',
                                      height: 20,
                                      color: const Color.fromARGB(
                                        83,
                                        37,
                                        37,
                                        37,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              "\$$totalDonation",
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
                                    color: const Color.fromARGB(
                                      255,
                                      227,
                                      227,
                                      227,
                                    ),
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
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
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                top: 8.0,
                              ),
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
                                itemCount: getDonationData.length,
                                itemBuilder: (context, index) {
                                  return DonationCard(
                                    name:
                                        getDonationData[index]['charity_name'],
                                    date:
                                        getDonationData[index]['date_created'],
                                    amount: getDonationData[index]['amount'],
                                  );
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
                            "Charity News & Updates",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 270,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: getPostData.length,
                          itemBuilder: (context, index) {
                            return CharityNews(
                              name: getPostData[index]['name'],
                              description: getPostData[index]['desc'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onChange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Charity',
          ),
        ],
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
