import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackingService {
  static const String apiUrl =
      "https://api.trackingmore.com/v4/trackings/create";
  static const String apiKey =
      "lybzn6h9-ljzr-f3yu-gx2g-xaedzabpoyez"; // Replace with your API key

  static Future<void> createTracking(
      String trackingNumber, String courierCode) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Tracking-Api-Key': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "tracking_number": trackingNumber,
          "courier_code": courierCode,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("Tracking created successfully: ${responseData}");
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }
}
