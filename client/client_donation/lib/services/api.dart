import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final storage = const FlutterSecureStorage();
  
  Future<void> logout(String apiUrl) async {
    await storage.delete(key: 'token');
    // Optional: Call backend /auth/logout to clear cookies
    await http.get(Uri.parse(apiUrl));
  }

  Future<Map<String,dynamic>> getAllCharities(String url) async{      var charityUrl = Uri.parse(url);
      final response = await http.get(charityUrl,
      headers: {"Content-Type":"application/json"});
      if(response.statusCode==200) {
        dynamic charityResponse = json.decode(response.body);
        return charityResponse;
      }
      else {
        throw Exception("Charity Api failed: ${response.statusCode}");
      }
    
  }

}