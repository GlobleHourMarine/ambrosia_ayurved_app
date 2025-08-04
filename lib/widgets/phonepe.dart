// pubspec.yaml dependencies
// Add these to your pubspec.yaml file:
/*
dependencies:
  flutter:
    sdk: flutter
  phonepe_payment_sdk: ^2.0.1
  http: ^1.1.0
  crypto: ^3.0.3
*/

import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class PhonePePaymentService {
  // Your PhonePe credentials
  static const String merchantId = "M22NOXGSL1P2A";
  static const String clientId = "SU2506031142531039239175";
  static const String clientSecret = "0f0dbd9d-0d6d-46c0-ba46-e85a4bc65b66";
  static const int saltIndex = 1;

  // Environment settings
  static const String environment =
      "SANDBOX"; // Change to "PRODUCTION" for live
  static const String baseUrl =
      "https://api-preprod.phonepe.com/apis/pg-sandbox"; // Change for production

  // Initialize PhonePe SDK
  static Future<bool> initializePhonePe() async {
    try {
      String flowId = "flutter_${DateTime.now().millisecondsSinceEpoch}";
      bool isInitialized = await PhonePePaymentSdk.init(
        environment,
        merchantId,
        flowId,
        true, // Enable logging
      );
      return isInitialized;
    } catch (e) {
      print("PhonePe initialization error: $e");
      return false;
    }
  }

  // Generate Auth Token
  static Future<String?> getAuthToken() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/v1/auth/token'),
        headers: {
          'Content-Type': 'application/json',
          'X-CLIENT-ID': clientId,
          'X-CLIENT-SECRET': clientSecret,
        },
        body: jsonEncode({
          'clientId': clientId,
          'clientSecret': clientSecret,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['accessToken'];
      } else {
        print("Auth token error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Auth token exception: $e");
      return null;
    }
  }

  // Create Order
  static Future<String?> createOrder({
    required String orderId,
    required int amount, // Amount in paise (₹1 = 100 paise)
    required String authToken,
    String? userId,
    String? userPhone,
  }) async {
    try {
      final orderPayload = {
        "orderId": orderId,
        "amount": amount,
        "currency": "INR",
        "merchantId": merchantId,
        "userId": userId ?? "user_${DateTime.now().millisecondsSinceEpoch}",
        "userPhone": userPhone,
        "redirectUrl": "https://webhook.site/redirect-url",
        "callbackUrl": "https://webhook.site/callback-url",
      };

      final response = await http.post(
        Uri.parse('$baseUrl/v1/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
          'X-CLIENT-ID': clientId,
        },
        body: jsonEncode(orderPayload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['token'];
      } else {
        print("Create order error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Create order exception: $e");
      return null;
    }
  }

  // Generate Checksum
  static String generateChecksum(String payload) {
    String saltKey =
        "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399"; // Replace with your actual salt key
    String input = payload + "/pg/v1/pay" + saltKey;
    var bytes = utf8.encode(input);
    var digest = sha256.convert(bytes);
    return digest.toString() + "###$saltIndex";
  }

  // Start Payment Transaction
  static Future<Map<dynamic, dynamic>?> startPayment({
    required String orderId,
    required String token,
  }) async {
    try {
      Map<String, dynamic> payload = {
        "orderId": orderId,
        "merchantId": merchantId,
        "token": token,
        "paymentMode": {"type": "PAY_PAGE"}
      };

      String request = jsonEncode(payload);
      String checksum = generateChecksum(request);

      print("Payment Request: $request");
      print("Checksum: $checksum");

      Map<dynamic, dynamic>? response =
          await PhonePePaymentSdk.startTransaction(request, checksum);
      return response;
    } catch (e) {
      print("Start payment exception: $e");
      return null;
    }
  }

  // Generate unique order ID
  static String generateOrderId() {
    return "ORDER_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}";
  }

  // Check payment status
  static Future<Map<String, dynamic>?> checkPaymentStatus({
    required String orderId,
    required String authToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/v1/orders/$orderId/status'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'X-CLIENT-ID': clientId,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Payment status error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Payment status exception: $e");
      return null;
    }
  }
}

class PhonePePaymentScreen extends StatefulWidget {
  @override
  _PhonePePaymentScreenState createState() => _PhonePePaymentScreenState();
}

class _PhonePePaymentScreenState extends State<PhonePePaymentScreen> {
  String result = "PhonePe SDK not initialized";
  bool isLoading = false;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeSDK();
  }

  void initializeSDK() async {
    setState(() {
      isLoading = true;
    });

    bool isInitialized = await PhonePePaymentService.initializePhonePe();

    setState(() {
      result = isInitialized
          ? 'PhonePe SDK Initialized Successfully'
          : 'PhonePe SDK Initialization Failed';
      isLoading = false;
    });
  }

  void startPayment() async {
    if (amountController.text.isEmpty) {
      showSnackBar("Please enter amount");
      return;
    }

    setState(() {
      isLoading = true;
      result = "Starting payment...";
    });

    try {
      // Step 1: Get Auth Token
      String? authToken = await PhonePePaymentService.getAuthToken();
      if (authToken == null) {
        setState(() {
          result = "Failed to get auth token";
          isLoading = false;
        });
        return;
      }

      // Step 2: Create Order
      String orderId = PhonePePaymentService.generateOrderId();
      int amount = (double.parse(amountController.text) * 100)
          .toInt(); // Convert to paise

      String? token = await PhonePePaymentService.createOrder(
        orderId: orderId,
        amount: amount,
        authToken: authToken,
        userPhone:
            phoneController.text.isNotEmpty ? phoneController.text : null,
      );

      if (token == null) {
        setState(() {
          result = "Failed to create order";
          isLoading = false;
        });
        return;
      }

      // Step 3: Start Payment
      Map<dynamic, dynamic>? paymentResponse =
          await PhonePePaymentService.startPayment(
        orderId: orderId,
        token: token,
      );

      if (paymentResponse != null) {
        setState(() {
          result =
              "Payment Response: ${paymentResponse['status'] ?? 'Unknown'}";
          isLoading = false;
        });

        // Check payment status after some delay
        Future.delayed(Duration(seconds: 2), () async {
          Map<String, dynamic>? statusResponse =
              await PhonePePaymentService.checkPaymentStatus(
            orderId: orderId,
            authToken: authToken,
          );

          if (statusResponse != null) {
            setState(() {
              result = "Final Status: ${statusResponse['data']['status']}";
            });
          }
        });
      } else {
        setState(() {
          result = "Payment initiation failed";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        result = "Payment error: $e";
        isLoading = false;
      });
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhonePe Payment Gateway'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount (₹)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : startPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Pay with PhonePe',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      result,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Configuration:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Environment: SANDBOX\n'
                      'Merchant ID: ${PhonePePaymentService.merchantId}\n'
                      'Client ID: ${PhonePePaymentService.clientId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
