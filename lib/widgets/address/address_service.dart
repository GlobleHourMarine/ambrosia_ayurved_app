import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressService {
  static Future<Map<String, dynamic>> fetchAddressDetails(
      String pincode) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.postalpincode.in/pincode/$pincode'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty && data[0]['Status'] == 'Success') {
          final postOffice = data[0]['PostOffice'][0];
          return {
            'state': postOffice['State'],
            'district': postOffice['District'],
            'status': 'success',
          };
        } else {
          return {'status': 'error', 'message': 'Invalid pincode'};
        }
      } else {
        return {'status': 'error', 'message': 'Failed to fetch data'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'An error occurred'};
    }
  }
}
