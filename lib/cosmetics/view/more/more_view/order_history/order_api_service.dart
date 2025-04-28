import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_model.dart';

class ApiService {
  static const String baseUrl =
      'https://ambrosiaayurved.in/api/fetch_orders_data';
  static Future<List<dynamic>> getOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id;

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data')) {
        print(responseData);
        return responseData['data']; // Extracting the list from the JSON object
      } else {
        throw Exception("Invalid API response: 'data' key not found.");
      }
    } else {
      throw Exception('Failed to load orders');
    }
  }
}
