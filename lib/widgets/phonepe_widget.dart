import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class PhonePeApiService {
  static const String baseUrl =
      "https://api.phonepe.com/apis/pg/checkout/v2/sdk/order";
  static const String saltKey =
      "0f0dbd9d-0d6d-46c0-ba46-e85a4bc65b66"; // Replace with your actual salt key
  static const String saltIndex = "1"; // Replace with your actual salt index
  static const String merchantOrderId = "";

  /// Creates a PhonePe order
  ///
  /// [merchantOrderId] - Unique merchant order ID
  /// [amount] - Amount in paisa (multiply rupees by 100)
  /// [accessToken] - OAuth access token from PhonePe
  ///
  /// Returns API response as Map<String, dynamic>
  static Future<Map<String, dynamic>> createOrder({
    required String merchantOrderId,
    required int amount,
    required String accessToken,
  }) async {
    try {
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "merchantOrderId": merchantOrderId,
        "amount": amount,
        "paymentFlow": {"type": "PG_CHECKOUT"}
      };

      // Convert request body to JSON string
      final String jsonBody = jsonEncode(requestBody);

      // Encode the JSON body to base64
      final String base64Body = base64Encode(utf8.encode(jsonBody));

      // Create checksum for X-VERIFY header
      final String checksum = _generateChecksum(base64Body);

      // Prepare headers
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'O-Bearer $accessToken',
        'X-VERIFY': checksum,
      };

      print('Request URL: $baseUrl');
      print('Request Headers: $headers');
      print('Request Body: $jsonBody');
      print('Base64 Body: $base64Body');
      print('Checksum: $checksum');

      // Make HTTP POST request
      final http.Response response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonBody,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Parse response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Return response with status code
      return {
        'statusCode': response.statusCode,
        'success': response.statusCode == 200,
        'data': responseData,
      };
    } catch (e) {
      print('Error calling PhonePe API: $e');
      return {
        'statusCode': 500,
        'success': false,
        'error': e.toString(),
        'data': null,
      };
    }
  }

  /// Generates checksum for X-VERIFY header
  /// Formula: SHA256(base64Body + "/apis/pg/checkout/v2/sdk/order" + saltKey) + "###" + saltIndex
  static String _generateChecksum(String base64Body) {
    final String stringToHash =
        base64Body + "/apis/pg/checkout/v2/sdk/order" + saltKey;
    final List<int> bytes = utf8.encode(stringToHash);
    final Digest digest = sha256.convert(bytes);
    return digest.toString() + "###" + saltIndex;
  }

  /// Alternative method without base64 encoding (if above doesn't work)
  static Future<Map<String, dynamic>> createOrderAlternative({
    required String merchantOrderId,
    required int amount,
    required String accessToken,
  }) async {
    try {
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "merchantOrderId": merchantOrderId,
        "amount": amount,
        "paymentFlow": {"type": "PG_CHECKOUT"}
      };

      // Convert request body to JSON string
      final String jsonBody = jsonEncode(requestBody);

      // Create checksum without base64 encoding
      final String checksum = _generateChecksumAlternative(jsonBody);

      // Prepare headers
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'O-Bearer $accessToken',
        'X-VERIFY': checksum,
      };

      // Make HTTP POST request
      final http.Response response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonBody,
      );

      // Parse response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'success': response.statusCode == 200,
        'data': responseData,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'success': false,
        'error': e.toString(),
        'data': null,
      };
    }
  }

  /// Alternative checksum generation
  static String _generateChecksumAlternative(String jsonBody) {
    final String stringToHash =
        jsonBody + "/apis/pg/checkout/v2/sdk/order" + saltKey;
    final List<int> bytes = utf8.encode(stringToHash);
    final Digest digest = sha256.convert(bytes);
    return digest.toString() + "###" + saltIndex;
  }
}

// Example usage function
Future<void> exampleUsage() async {
  const String accessToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJpZGVudGl0eU1hbmFnZXIiLCJ2ZXJzaW9uIjoiNC4wIiwidGlkIjoiNGJiZGY3NTItNWM0Mi00ZTY0LWJhZDYtZTJlMWQ2Y2UyYWQ4Iiwic2lkIjoiYjViMDE5NTgtYTNhNy00MjIyLWE0NGItOWNkMGNkOGExZDllIiwiaWF0IjoxNzU0MTEzOTc3LCJleHAiOjE3NTQxMTc1Nzc9.6dNYFf0iQyzv9WjWexTyuGJUMQWjXDzFD_Os_XkJuFsZ16oailAjFDwQyoTuJIT5LJa7kpkkxCaUpqnNKmH7aw";

  // Call the API
  final result = await PhonePeApiService.createOrder(
    merchantOrderId: "ORDER1290495",
    amount: 500, // Amount in paisa (5 rupees)
    accessToken: accessToken,
  );

  // Handle response
  if (result['success']) {
    print('Order created successfully!');
    print('Response: ${result['data']}');
  } else {
    print('Failed to create order');
    print('Error: ${result['error'] ?? result['data']}');
  }
}

class PhonePePaymentWidget extends StatefulWidget {
  @override
  _PhonePePaymentWidgetState createState() => _PhonePePaymentWidgetState();
}

class _PhonePePaymentWidgetState extends State<PhonePePaymentWidget> {
  bool _isLoading = false;
  String _result = '';

  Future<void> _createPaymentOrder() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    const String accessToken =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJpZGVudGl0eU1hbmFnZXIiLCJ2ZXJzaW9uIjoiNC4wIiwidGlkIjoiNGJiZGY3NTItNWM0Mi00ZTY0LWJhZDYtZTJlMWQ2Y2UyYWQ4Iiwic2lkIjoiYjViMDE5NTgtYTNhNy00MjIyLWE0NGItOWNkMGNkOGExZDllIiwiaWF0IjoxNzU0MTEzOTc3LCJleHAiOjE3NTQxMTc1Nzc9.6dNYFf0iQyzv9WjWexTyuGJUMQWjXDzFD_Os_XkJuFsZ16oailAjFDwQyoTuJIT5LJa7kpkkxCaUpqnNKmH7aw";

    final result = await PhonePeApiService.createOrderAlternative(
      merchantOrderId: "ORDER${DateTime.now().millisecondsSinceEpoch}",
      amount: 500,
      accessToken: accessToken,
    );

    setState(() {
      _isLoading = false;
      _result = result['success']
          ? 'Success: ${result['data']}'
          : 'Error: ${result['error'] ?? result['data']}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PhonePe Payment')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _createPaymentOrder,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Create Payment Order'),
            ),
            SizedBox(height: 20),
            if (_result.isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_result),
              ),
          ],
        ),
      ),
    );
  }
}
