import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PhonePePaymentService {
  static const MethodChannel _channel = MethodChannel('phonepe_payment_sdk');

  // --- SDK Initialization ---
  static Future<bool> initSDK({
    required String environment,
    required String merchantId,
    required String flowId,
    bool enableLogging = false,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('init', {
        'environment': environment.toUpperCase(),
        'merchantId': merchantId,
        'flowId': flowId,
        'enableLogs': enableLogging,
      });
      return result;
    } on PlatformException catch (e) {
      print(e);
      throw Exception("SDK Init Failed: ${e.message}");
    }
  }

  // --- Create Order API ---
  static Future<Map<String, dynamic>> createOrder({
    required String accessToken,
    required String saltKey,
  }) async {
    const String url = 'https://api.phonepe.com/apis/pg/checkout/v2/sdk/order';

    final Map<String, dynamic> requestBody = {
      "merchantOrderId": "ORDER_${DateTime.now().millisecondsSinceEpoch}",
      "amount": 200, // Amount in paisa (100 = ₹1)
      "paymentFlow": {"type": "PG_CHECKOUT"},
    };

    final String requestJson = jsonEncode(requestBody);
    final String checksum =
        sha256.convert(utf8.encode('$requestJson$saltKey')).toString();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'O-Bearer $accessToken',
        'X-VERIFY': checksum,
      },
      body: requestJson,
    );
    print('Create order : $response');
    return jsonDecode(response.body);
  }

  // --- Start Transaction ---
  static Future<Map<dynamic, dynamic>> startTransaction({
    required String requestBody,
    String appSchema = 'com.app.ambrosiaayurved', // iOS only
  }) async {
    try {
      final result = await _channel.invokeMethod('startTransaction', {
        'request': requestBody,
        'appSchema': appSchema,
      });
      print('Transaction : $result');
      return result ?? {'status': 'FAILURE', 'error': 'Null response'};
    } on PlatformException catch (e) {
      print(e);

      return {'status': 'FAILURE', 'error': e.message};
    }
  }
}
