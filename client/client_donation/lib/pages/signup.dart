import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ), // Set icon color to white for contrast
        ),

        backgroundColor: Colors.transparent,
        // elevation: 0,

        // 3. Use flexibleSpace to put the image in the background area
        flexibleSpace: Stack(
          children: [
            Image.asset(
              'images/Computer login-cuate.png',
              fit:
                  BoxFit
                      .cover, // Ensures the image stretches to fill the whole area
              width: double.infinity, // Ensures it takes full width
              height: double.infinity, // Ensures it takes full height
            ),
            // The dark overlay (optional but good for readability)
            Positioned.fill(
              child: Container(color: Colors.black.withAlpha(90)),
            ),
          ],
        ),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, left: 5, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Account",
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Setup your account below",
                  style: GoogleFonts.geologica(
                    fontSize: 20,
                    color: Color(0xFFB1B1B1),
                  ),
                ),
              ],
            ),
          ),

          _buildFormSection("First name", context, firstname),
          _buildFormSection("Last name", context, lastname),
          _buildFormSection("Email", context, email),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Password"),
                const SizedBox(height: 5),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade500,
              fixedSize: Size(180, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.white,
                  content: Text(firstname.text),
                ),
              );
            },
            child: Text(
              "Register",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Already have an account?"), Text("Login")],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(
    String label,
    BuildContext context,
    TextEditingController controllers,
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
              style: GoogleFonts.geologica(
                color: Color.fromARGB(255, 140, 140, 140),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            label == "Email"
                ? TextField(
                  controller: controllers,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: "you@example.com",
                  ),
                )
                : TextField(
                  controller: controllers,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: "John",
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
