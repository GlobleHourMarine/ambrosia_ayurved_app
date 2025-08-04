import 'dart:convert';

import 'package:ambrosia_ayurved/widgets/new_phonepe/phonepe_sdk.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _status = 'Ready';
  bool _isLoading = false;
  // Configuration (replace with your actual values)
  final String _merchantId = 'M22NOXGSL1P2A';
  final String _accessToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJpZGVudGl0eU1hbmFnZXIiLCJ2ZXJzaW9uIjoiNC4wIiwidGlkIjoiOTM5MTYzMGItNzJkNS00ZmNhLTgzZDAtYjAyYTRhZjI0NWVhIiwic2lkIjoiMGQ0NmQ4MDctMWY4OS00YzQ2LWExY2YtZDFmNTQxNmUxYTE2IiwiaWF0IjoxNzU0MTM1NDE2LCJleHAiOjE3NTQxMzkwMTZ9.v0ZnOEOHvZmWE7_Zyxw3TDSRVQBW3TV2qErC_1VC6pAhy3IfiL-n351qFmRoc05E7LoQPQ4TYm3mGr71Dx8GTg';
  final String _saltKey = '0f0dbd9d-0d6d-46c0-ba46-e85a4bc65b66';
  final String _flowId = 'USER_${DateTime.now().millisecondsSinceEpoch}';
  Future<void> _initiatePayment() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing SDK...';
    });
    final String transactionId = "TXN_${DateTime.now().millisecondsSinceEpoch}";

    try {
      // 1. Initialize SDK
      final bool isInitialized = await PhonePePaymentService.initSDK(
        environment: 'PRODUCTION',
        merchantId: _merchantId,
        flowId: _flowId,
        enableLogging: false,
      );

      if (!isInitialized) throw Exception('SDK initialization failed');

      // 2. Create Order
      setState(() => _status = 'Creating order...');
      final orderResponse = await PhonePePaymentService.createOrder(
        accessToken: _accessToken,
        saltKey: _saltKey,
      );
      print('Full Order Response: ${jsonEncode(orderResponse)}');
      // 3. Prepare PROPER transaction request

      final Map<String, dynamic> transactionRequest = {
        "merchantId": _merchantId,
        "merchantTransactionId": transactionId,
        // "merchantTransactionId": orderResponse['data']['merchantOrderId'],
        "amount": 200,
        "merchantUserId": "USER_${_flowId}",
        "redirectUrl":
            "https://ambrosiaayurved.in/PaymentController/callback", // Your callback URL
        "redirectMode": "POST",
        "callbackUrl":
            "https://ambrosiaayurved.in/PaymentController/callback", // Same as redirectUrl
        "paymentInstrument": {
          "type": "PAY_PAGE",
          "targetApp": "com.phonepe.app",
        },
        "token": orderResponse['token'], // From order response
        "orderId": orderResponse['orderId'], // From order response
      };

      // 4. Start Transaction with PROPERLY formatted request
      setState(() => _status = 'Starting payment...');
      final transactionResult = await PhonePePaymentService.startTransaction(
        requestBody: jsonEncode(transactionRequest),
      );
      print('Transaction Result: $transactionResult');

      setState(() {
        _status = '''
        Transaction Result:
        Status: ${transactionResult['status']}
        Error: ${transactionResult['error'] ?? 'None'}
         Transaction ID: $transactionId
        Order ID: ${orderResponse['orderId']}
      ''';
      });
    } catch (e) {
      print('Payment Error : $e');
      setState(() => _status = 'Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PhonePe Payment')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _initiatePayment,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Pay with PhonePe', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Payment Status',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Divider(),
                    Text(_status, style: TextStyle(fontFamily: 'Monospace')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
