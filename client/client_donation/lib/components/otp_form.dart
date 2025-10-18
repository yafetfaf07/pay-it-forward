import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_donation/pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;

class OtpForm extends StatelessWidget {
  final String phone;
  OtpForm({super.key, required this.phone});
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  Future<Map<String, dynamic>> getOtp(String token, String otpcode) async {
    // ⭐ Map, not List!
    final response = await http.get(
      Uri.parse(
        'https://api.afromessage.com/api/verify?to=+251985235803&vc=&code=$otpcode',
      ),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      print('✅ Verified: ${response.body}');
      return jsonDecode(response.body); // ⭐ Returns Map
    }

    print("❌ Failed: ${response.body}");
    return {'error': 'Failed'}; // ⭐ Returns Map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.chevron_left),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              "We just sent a SMS ",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            "Enter the security code we sent to ",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          SizedBox(height: 10),
          Text(phone, style: GoogleFonts.poppins(fontSize: 14)),
          SizedBox(height: 40),
          Form(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 64,
                  width: 60,
                  child: TextFormField(
                    controller: _controller1,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 64,
                  width: 60,
                  child: TextFormField(
                    controller: _controller2,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 64,
                  width: 60,
                  child: TextFormField(
                    controller: _controller3,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 64,
                  width: 60,
                  child: TextFormField(
                    controller: _controller4,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(340, 50),
              backgroundColor: const Color.fromARGB(255, 51, 141, 89),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              // ⭐ Add async
              String fullOtp =
                  _controller1.text +
                  _controller2.text +
                  _controller3.text +
                  _controller4.text;

              Map<String, dynamic> result = await getOtp(
                // ⭐ Add await
                dotenv.env['AFRMESSAGE_TOKEN']!,
                fullOtp,
              );

              if (result['acknowledge'] == "success") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ Verified! Welcome!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Navigate to home
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Dashboard()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ Invalid OTP'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Verify',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
