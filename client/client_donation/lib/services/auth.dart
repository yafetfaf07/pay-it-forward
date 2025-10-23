import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final storage = const FlutterSecureStorage();
    String apiBaseUrl="https://pay-it-forward-ez0v.onrender.com/api/users";
  // Login
  Future<Map<String, dynamic>?> login(String phoneNo)  async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_no': phoneNo,}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storeTokens( data['token']);
      return data;
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  // Register (similar to login)
  Future<Map<String, dynamic>?> register(String name, String phoneNo) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'phone_no': phoneNo}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await _storeTokens( data['token']);
      return data;
    } else {
      print("Failed let's check the name and phone-no: $name $phoneNo");
      throw Exception('Registration failed: ${response.statusCode}');
    }
  }

  // Store tokens securely
  Future<void> _storeTokens( String? refreshToken) async {
    print("Refresh Token: $refreshToken");
    if (refreshToken != null) await storage.write(key: 'token', value: refreshToken);
  }

  // Get access token
  Future<String?> getAccessToken() async => await storage.read(key: 'token');

  // Logout: Clear tokens
  Future<void> logout() async {
    await storage.delete(key: 'token');
    // Optional: Call backend /auth/logout to clear cookies
    await http.post(Uri.parse('$apiBaseUrl/auth/logout'));
  }
}