import 'dart:convert';
import 'package:ambrosia_ayurved/widgets/shiprocket/gemini/tracking_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'https://apiv2.shiprocket.in/v1/external/courier/track/awb/';

  // Replace with your actual token
  static const String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjY3NTMwMzksInNvdXJjZSI6InNyLWF1dGgtaW50IiwiZXhwIjoxNzU1NzcxNzkxLCJqdGkiOiJpWmFwVHdubURDMjRWS1ltIiwiaWF0IjoxNzU0OTA3NzkxLCJpc3MiOiJodHRwczovL3NyLWF1dGguc2hpcHJvY2tldC5pbi9hdXRob3JpemUvdXNlciIsIm5iZiI6MTc1NDkwNzc5MSwiY2lkIjo2NTE3MTM5LCJ0YyI6MzYwLCJ2ZXJib3NlIjpmYWxzZSwidmVuZG9yX2lkIjowLCJ2ZW5kb3JfY29kZSI6IiJ9.tfzREh0gVEGxz3WQ4D-JwM7QPIiQExv0BLcDJujo6D4';

  Future<TrackingData> getTrackingData(String awbCode) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',
    };

    final url = Uri.parse('$baseUrl$awbCode');

    try {
      final response = await http.get(url, headers: headers);
      print(response);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        print(decodedData);
        return TrackingData.fromJson(decodedData['tracking_data']);
      } else {
        throw Exception(
            'Failed to load tracking data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
