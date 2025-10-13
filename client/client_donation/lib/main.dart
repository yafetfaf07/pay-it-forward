// main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. MaterialApp is the ancestor.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 2. The home property now points to the new widget.
      home: const HomeScreen(), 
    );
  }
}

// 💡 NEW WIDGET: Contains the Scaffold and all UI logic.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // The function is now correctly defined within the HomeScreen's scope
  void _showCustomModalSheet(BuildContext context) {


    Widget _buildFormSection(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
      ],
    ),
  );
}
    // 💡 This context is a descendant of MaterialApp and Scaffold, so it works.
  showModalBottomSheet(
  context: context,
  // 💡 Recommendation: Use isScrollControlled: true for sheets with text fields 
  // to ensure the keyboard doesn't cover the inputs.
  isScrollControlled: true, 
  builder: (BuildContext ctx) {
    return Container(
      // Set the desired fixed height
      height: 500, 
      padding: const EdgeInsets.all(16.0), // Add overall padding
      
      // 💡 CORRECTION: The ListView now directly uses the Container's height.
      // Removed 'Expanded' as it's not needed here and causes the error.
      child: ListView(
        // The ListView is scrollable, allowing the content to extend beyond 500px
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Your Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () {

              }, icon: Icon(Icons.close))
            ],
          ),
          const Text(
            "Setup your account below",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          
          // Replaced inner Container with Padding for better layout
          _buildFormSection("First name"),
          _buildFormSection("Last name"),
          _buildFormSection("Email address"),
          _buildFormSection("Phone number"),
          _buildFormSection("Password"),
          _buildFormSection("Confirm Password"),
          
          const SizedBox(height: 50),
          ElevatedButton(onPressed: () {}, child: const Text("Submit")),
        ],
      ),
    );
  },
);


  }

  @override
  Widget build(BuildContext context) {
    // The entire previous Scaffold body is now here.
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset("images/Coins-amico.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withAlpha(90)),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width * 0.99,
            height: MediaQuery.of(context).size.height * 0.95,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 50,),
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
                    // 3. Call the function using the valid HomeScreen context
                    _showCustomModalSheet(context); 
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