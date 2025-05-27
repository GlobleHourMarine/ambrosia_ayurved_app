import 'dart:convert';
import 'package:http/http.dart' as http;

class PincodeApiService {
  // Example for a hypothetical Indian Post Office API endpoint.
  // You'll need to find the actual API endpoint you want to use.
  // For India Post, it might look something like:
  // 'https://api.postalpincode.in/pincode/<YOUR_PINCODE>'
  final String _baseUrl =
      'https://api.postalpincode.in/pincode'; // Example base URL

  Future<Map<String, String>> fetchLocationByPincode(String pincode) async {
    if (pincode.length != 6 || !RegExp(r'^[0-9]+$').hasMatch(pincode)) {
      return {'error': 'Invalid Pincode'};
    }

    try {
      final response = await http.get(Uri.parse('$_baseUrl/$pincode'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0]['Status'] == 'Success') {
          final postOfficeDetails = data[0]['PostOffice'][0];
          return {
            'state': postOfficeDetails['State'],
            'district': postOfficeDetails['District'],
            'city': postOfficeDetails['Block'] ??
                postOfficeDetails[
                    'District'], // Block is often the city/sub-district
          };
        } else if (data.isNotEmpty && data[0]['Status'] == 'Error') {
          return {'error': data[0]['Message'] ?? 'Pincode not found'};
        } else {
          return {
            'error': 'Pincode not found or API response format unexpected'
          };
        }
      } else {
        return {'error': 'Failed to load location: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Network error: $e'};
    }
  }
}
