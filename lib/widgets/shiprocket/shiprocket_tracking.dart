// tracking_service.dart
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TrackingService {
  static Future<Map<String, dynamic>> trackShipment({
    required String token,
    required String awbCode,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final request = http.Request(
        'GET',
        Uri.parse(
            'https://apiv2.shiprocket.in/v1/external/courier/track/awb/$awbCode'),
      );
      request.headers.addAll(headers);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);
      print(responseData);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': responseData,
          'tracking_data': responseData['tracking_data'],
        };
      } else {
        return {
          'success': false,
          'error': responseData['message'] ?? response.reasonPhrase,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  static String getStatusText(int statusCode) {
    switch (statusCode) {
      case 6:
        return 'Shipped';
      case 7:
        return 'Delivered';
      case 8:
        return 'Canceled';
      case 9:
        return 'RTO Initiated';
      case 10:
        return 'RTO Delivered';
      case 12:
        return 'Lost';
      case 13:
        return 'Pickup Error';
      case 17:
        return 'Out For Delivery';
      case 18:
        return 'In Transit';
      case 42:
        return 'Picked Up';
      case 48:
        return 'Reached Warehouse';
      case 51:
        return 'Handover to Courier';
      default:
        return 'Processing';
    }
  }

  static Color getStatusColor(int statusCode) {
    switch (statusCode) {
      case 7:
        return Colors.green;
      case 10:
        return Colors.green;
      case 8:
        return Colors.red;
      case 12:
        return Colors.red;
      case 13:
        return Colors.orange;
      case 17:
        return Colors.blue;
      case 18:
        return Colors.blue;
      case 42:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
