import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ShiprocketAuth {
  static const String _tokenKey = 'shiprocket_token';
  static const String _tokenTimeKey = 'shiprocket_token_time';
  static const int _tokenExpiryDays = 10; // token expires after 10 days

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    final savedToken = prefs.getString(_tokenKey);
    final savedTime = prefs.getInt(_tokenTimeKey);

    if (savedToken != null && savedTime != null) {
      final fetchedTime = DateTime.fromMillisecondsSinceEpoch(savedTime);
      final now = DateTime.now();

      // ✅ Check if token is still valid
      if (now.difference(fetchedTime).inDays < _tokenExpiryDays) {
        print("✅ Using cached Shiprocket token $savedToken");
        return savedToken;
      }
    }

    return await _fetchNewToken();
  }

  static Future<String?> _fetchNewToken() async {
    const String url = 'https://apiv2.shiprocket.in/v1/external/auth/login';

    final body = {
      "email": "ambrosiaayurved@gmail.com",
      "password": "5IFx3XFz\$k#8Uqel"
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final token = data['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, token);
          await prefs.setInt(
              _tokenTimeKey, DateTime.now().millisecondsSinceEpoch);
          print('token data: $data');
          print("✅ New Shiprocket token saved : $token");
          return token;
        }
      } else {
        print("❌ Shiprocket login failed: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error fetching Shiprocket token: $e");
    }

    return null;
  }
}
