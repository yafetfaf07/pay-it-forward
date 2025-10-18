// main.dart

import 'package:client_donation/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

Future main()async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. MaterialApp is the ancestor.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("images/Coins-amico.png", fit: BoxFit.cover),
          ),
          Positioned.fill(child: Container(color: Colors.black.withAlpha(90))),
          Positioned(
            width: MediaQuery.of(context).size.width * 0.99,
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 50),
                Column(
                  children: [
                    Text(
                      "Pay It Forward",
                      style: GoogleFonts.poppins(
                        fontSize: 44,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Little Change Big Impact",
                      style: GoogleFonts.geologica(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 24,
                    fixedSize: const Size(200, 50),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => Signup()),
                    );
                    // 3. Call the function using the valid HomeScreen context
                    // _showCustomModalSheet(context);
                  },
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.geologica(
                      fontSize: 24,
                      color: Colors.grey.shade50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
