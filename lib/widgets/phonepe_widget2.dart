import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class PhonePeCheckoutPage extends StatefulWidget {
  @override
  _PhonePeCheckoutPageState createState() => _PhonePeCheckoutPageState();
}

class _PhonePeCheckoutPageState extends State<PhonePeCheckoutPage> {
  String _apiResponse = "Press the button to call the API";
  bool _isLoading = false;

  Future<void> _callPhonePeAPI() async {
    setState(() {
      _isLoading = true;
      _apiResponse = "Calling API...";
    });

    try {
      final String url =
          'https://api.phonepe.com/apis/pg/checkout/v2/sdk/order';
      final String accessToken =
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJpZGVudGl0eU1hbmFnZXIiLCJ2ZXJzaW9uIjoiNC4wIiwidGlkIjoiNGJiZGY3NTItNWM0Mi00ZTY0LWJhZDYtZTJlMWQ2Y2UyYWQ4Iiwic2lkIjoiYjViMDE5NTgtYTNhNy00MjIyLWE0NGItOWNkMGNkOGExZDllIiwiaWF0IjoxNzU0MTEzOTc3LCJleHAiOjE3NTQxMTc1Nzd9.6dNYFf0iQyzv9WjWexTyuGJUMQWjXDzFD_Os_XkJuFsZ16oailAjFDwQyoTuJIT5LJa7kpkkxCaUpqnNKmH7aw'; // Replace with your token
      final String saltKey = '0f0dbd9d-0d6d-46c0-ba46-e85a4bc65b66';

      final Map<String, dynamic> requestBody = {
        "merchantOrderId": "ORDER1290495",
        "amount": 500,
        "paymentFlow": {"type": "PG_CHECKOUT"},
      };

      final String requestBodyJson = jsonEncode(requestBody);
      final String checksumInput = '$requestBodyJson$saltKey';
      final String xVerifyChecksum =
          sha256.convert(utf8.encode(checksumInput)).toString();
      print(xVerifyChecksum);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'O-Bearer $accessToken',
          'X-VERIFY': xVerifyChecksum,
        },
        body: requestBodyJson,
      );

      setState(() {
        _apiResponse = response.statusCode == 200
            ? "Success!\n\n${response.body}"
            : "Error (${response.statusCode}):\n\n${response.body}";
      });
      print(_apiResponse);
    } catch (e) {
      setState(() {
        _apiResponse = "Error: $e";
      });
      print(_apiResponse);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PhonePe API Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _callPhonePeAPI,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Call PhonePe API'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    _apiResponse,
                    style: TextStyle(fontFamily: 'Monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
