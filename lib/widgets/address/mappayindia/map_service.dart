import 'dart:convert';
import 'package:http/http.dart' as http;

class MapmyIndiaService {
  static const String _apiKey = '4e692dafadaa6e07193e95433f11ce74';

  static Future<Map<String, dynamic>> fetchPincodeData(String pincode) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                'https://apis.mapmyindia.com/advancedmaps/v1/$_apiKey/pincode_detail?pincode=$pincode'),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return {
            'state': data['results'][0]['state'],
            'district': data['results'][0]['district'],
            'city':
                data['results'][0]['city'] ?? data['results'][0]['district'],
            'status': 'success',
          };
        }
      }
      return {'status': 'error', 'message': 'Invalid pincode or no data'};
    } catch (e) {
      return {'status': 'error', 'message': 'Failed to fetch data: $e'};
    }
  }
}
