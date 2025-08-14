// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class ShiprocketAuth {
//   static String? _token;

//   static String? get token => _token;

//   static void setToken(String token) {
//     _token = token;
//   }

//   static String get safeToken => _token ?? '';

//   static bool get isTokenAvailable => _token != null && _token!.isNotEmpty;
// }

// Future<void> fetchShiprocketToken() async {
//   try {
//     final response = await http.get(
//       Uri.parse('https://ambrosiaayurved.in/Tracking/auth_token'),
//     );

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == true && data['token'] != null) {
//         ShiprocketAuth.setToken(data['token']);
//         print('✅ Shiprocket token saved successfully. $data');
//       } else {
//         print('❌ Failed to get token: ${data['message']}');
//       }
//     } else {
//       print('❌ HTTP error: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('❌ Exception while fetching token: $e');
//   }
// }

// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<String?> getShiprocketAuthToken() async {
//   const String url = 'https://ambrosiaayurved.in/Tracking/auth_token';

//   try {
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json', // keep if API expects JSON
//       },
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       if (data['status'] == true && data['token'] != null) {
//         return data['token'];
//       } else {
//         print("Token not found in response: $data");
//       }
//     } else {
//       print("Error: ${response.statusCode} - ${response.body}");
//     }
//   } catch (e) {
//     print("Exception while getting token: $e");
//   }
//   return null;
// }
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
