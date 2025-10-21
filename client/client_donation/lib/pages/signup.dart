import 'dart:convert';

import 'package:client_donation/pages/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import "package:http/http.dart" as http;
class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // Controllers
  TextEditingController name = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // ⭐ FIXED: PhoneNumber as CLASS VARIABLE - NO REBUILDS!
  PhoneNumber phone_no = PhoneNumber(isoCode: 'ETH');

  Future<Map<String,dynamic>> sendOtp(String token) async {
  final response = await http.get(
    Uri.parse('https://api.afromessage.com/api/challenge?from&to=${phoneController.text}&len=4&t=0&ttl=300'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if(response.statusCode==200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP sent successfully")));
  return jsonDecode(response.body);
  }
  return jsonDecode("Failed");
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.97,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Image.asset(
                      'images/Computer login-cuate.png',
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Create your account",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        label: Text("Enter your name"),
                        hintText: "John Doe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: InternationalPhoneNumberInput(
                        textAlign: TextAlign.center,
                        
                        onInputChanged: (value) {
                          phone_no = value;
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                          showFlags: true,
                          setSelectorButtonAsPrefixIcon: true, // ⭐ Better UX
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        initialValue: PhoneNumber(isoCode: 'ET', ),
                        textFieldController: phoneController,
                        formatInput: true,
                        keyboardType: TextInputType.number,
                        inputDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone number',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                        ),
                        onInputValidated: (bool value) {
                          // print('Valid: $value');
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.only(bottom: 30),
                width: MediaQuery.of(context).size.width*0.94,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 95, 80, 42),
                     // ⭐ Full width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    _handleContinue();
                  },
                  child: Text(
                    "Continue",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⭐ NEW: Separate validation method
  void _handleContinue()async {
    // ⭐ Check if phone is valid
   Map<String,dynamic> hasSucced= await sendOtp(dotenv.env["AFRMESSAGE_TOKEN"]!);
    // if (phone_no.phoneNumber == "" || phone_no.phoneNumber == null) {
    //   _showSnackBar('Please enter phone number', Colors.red);
    //   return;
    // }
    dynamic otpCode=hasSucced['response']['code'];

    final fullPhone = '${phone_no.phoneNumber}';
    print('✅ Full Phone: $fullPhone');

    // _showSnackBar('Phone: $fullPhone', Colors.green);

    // ⭐ Navigate to OTP
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OtpForm(phone: fullPhone, name:name.text)),
    );
  }

  // ⭐ NEW: Reusable snackbar method
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message, style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Your form section (unchanged)
  Widget _buildFormSection(
    String label,
    BuildContext context,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.97,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Color.fromARGB(255, 140, 140, 140),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                isDense: true,
                filled: true,
                fillColor: Colors.grey[50],
                hintText: label == "Email" ? "you@example.com" : "John",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
