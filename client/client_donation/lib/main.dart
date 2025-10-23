// main.dart

import 'package:client_donation/pages/dashboard.dart';
import 'package:client_donation/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:video_player/video_player.dart';

// Ensure you have a 'pages/dashboard.dart' and 'pages/signup.dart' file
// And your video is in 'images/video-illus.mp4' and declared in pubspec.yaml

Future main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Always good practice before native calls
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> _getInitialPage() async {
    const storage = FlutterSecureStorage();
    final String? refreshToken = await storage.read(key: 'token');
    print(" From Main. dart$refreshToken");
    if (refreshToken != null && !JwtDecoder.isExpired(refreshToken)) {
      // Token exists and is not expired
      return Dashboard(id: refreshToken);
    } else {
      // Token is missing or expired
      return const WelcomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while checking token
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            // Handle errors (e.g., storage read issues)
            return const Scaffold(
              body: Center(child: Text('Error checking authentication')),
            );
          }
          // Return the resolved page (Dashboard or WelcomeScreen)
          // Use snapshot.data or fallback to Signup
          return snapshot.data ??  Signup();
        },
      ),
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
                      MaterialPageRoute(builder: (ctx) =>  Signup()),
                    );
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

// =======================================================================
// WELCOMESCREEN WITH LOOPING VIDEO AND EXPANDED FIX
// =======================================================================

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the Video Controller
    _videoController = VideoPlayerController.asset('images/video-illus.mp4')
      ..initialize()
          .then((_) {
            // 2. Set Looping to true for infinite playback
            _videoController.setLooping(true);
            // 3. Start playback
            _videoController.play();
            // 4. Update the UI once initialized
            setState(() {});
          })
          .catchError((error) {
            // Handle potential initialization errors
            print('Error initializing video: $error');
          });
  }

  @override
  void dispose() {
    // 5. IMPORTANT: Dispose of the controller to free resources
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the video is initialized to show a loading indicator if necessary
    final isVideoInitialized = _videoController.value.isInitialized;

    // --- Video Player Widget ---
    final videoWidget = isVideoInitialized
        ? AspectRatio(
            aspectRatio: _videoController.value.aspectRatio,
            child: VideoPlayer(_videoController),
          )
        : const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          // --- Page 1: Video Placeholder/Content (FIXED) ---
          SizedBox(
            child: ListView(
              // Removed height: 500 from SizedBox to let ListView determine height
              children: [
                // 🛑 FIXED: Using SizedBox with defined height instead of Expanded
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45, // Allocate ~45% of screen height
                  child: videoWidget,
                ),
                Center(
                  child: const Text(
                    "Ligesa/ልገሳ",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: const Text(
                      "Express your generosity easily. Give, help, make a difference.",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Swipe Right",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.purple),
                  ],
                ),
              ],
            ),
          ),

          // --- Page 2: Your existing content ---
          SizedBox(
            child: ListView(
              children: [
                Image.asset("images/logillus.jpg"),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Ligesa: Your donation in an instant. Create an account and simply express your generosity by scanning the QR code of your favorite charity center you visited. Give, help, make a difference—all with one simple scan!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Swipe Left",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        "Swipe right",
                        style: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // --- Page 3: Your existing content with Get Started button ---
          SizedBox(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset("images/sign-illus.jpg"),
                const Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 20, right: 10),
                  child: Text(
                    "Don't wait to make a difference. Your support is crucial, and it all starts here. Create your account now to begin your journey of giving!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      backgroundColor: const Color.fromARGB(255, 158, 30, 232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) =>  Signup()),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
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