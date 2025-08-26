import 'dart:convert';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:ambrosia_ayurved/widgets/phonepe/phonepe_sdk.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PhonePePaymentService {
  static const String _createOrderUrl =
      "https://ambrosiaayurved.in/PaymentApi/create_order";

  static const String _merchantId = "M22NOXGSL1P2A";

  static Future<String> initiatePayment({
    required int amount,
    required BuildContext context,
  }) async {
    try {
      // Step 1: Create order from backend
      final response = await http.post(
        Uri.parse(_createOrderUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"amount": amount}),
      );
      final Map<String, dynamic> json = jsonDecode(response.body);
      print('🔍 create order response: ${response.body}');

      final Map<String, dynamic> responseData = json['data']['response'];
      final Map<String, dynamic> payloadData = json['data']['payload'];
      print('Response Data : $responseData');
      print('payload Data : $payloadData');
      final String orderId = responseData['orderId'];
      final String token = responseData['token'];
      PhonePeAuthToken.authToken = token;
      final String merchantOrderId = payloadData['merchantOrderId'];
      GlobalPaymentData.merchantOrderId = merchantOrderId;

      print('✅ phonepe: $token');
      print('✅ orderId: $orderId');
      print('✅ token: $token');
      print('✅ merchantOrderId: $merchantOrderId');

      // Step 2: Initialize SDK

      // final userProvider = Provider.of<UserProvider>(context, listen: false);
      // final String userId = userProvider.id.toString();

      // // ✅ Save orderId & userId to backend
      // await savePhonePeData(orderId: merchantOrderId, userId: userId);

      final isInitialized = await PhonePePaymentSdk.init(
        "PRODUCTION",
        _merchantId,
        orderId,
        false,
      );

      if (!isInitialized) {
        return "❌ Failed to initialize SDK";
      }

      // Step 3: Build and send transaction request

      final Map<String, dynamic> payload = {
        "orderId": orderId,
        "merchantId": _merchantId,
        "token": token,
        "paymentMode": {"type": "PAY_PAGE"},
      };

      final String request = jsonEncode(payload);
      final result = await PhonePePaymentSdk.startTransaction(request, "");

      if (result != null) {
        final String status = result["status"] ?? "Unknown";
        final String error = result["error"] ?? "None";
        // await savePhonePeData(orderId: merchantOrderId, userId: userId);
        if (status == "SUCCESS") {
          // ✅ Play success sound
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final String userId = userProvider.id.toString();

          // ✅ Save orderId & userId to backend
          await savePhonePeData(orderId: merchantOrderId, userId: userId);

          final player = AudioPlayer();
          await player.play(AssetSource('sounds/payment_done.mp3'));

          return "Payment Successful";
        } else {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final String userId = userProvider.id.toString();

          // ✅ Save orderId & userId to backend
          await savePhonePeData(orderId: merchantOrderId, userId: userId);
          return "Payment Failed | Status: $status | Error: $error";
        }
      } else {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final String userId = userProvider.id.toString();

        // ✅ Save orderId & userId to backend
        await savePhonePeData(orderId: merchantOrderId, userId: userId);
        return "Transaction flow interrupted or incomplete";
      }
    } catch (e) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String userId = userProvider.id.toString();
      final merchantOrderId = GlobalPaymentData.merchantOrderId;
      // ✅ Save orderId & userId to backend
      await savePhonePeData(
          orderId: merchantOrderId.toString(), userId: userId);

      print('Initiation Error : $e');
      return "Exception: $e";
    }
  }

  Future<String?> initiateRefund(String orderId) async {
    const String refundUrl =
        "https://ambrosiaayurved.in/paymentController/initiate_refund";

    try {
      final response = await http.post(
        Uri.parse(refundUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: '{"order_id": "$orderId"}',
      );

      if (response.statusCode == 200) {
        print('initiate refund response : ${response.body}');
        return response.body; // plain text (Refund ID, Amount, State)
      } else {
        print("Failed to initiate refund. Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error while initiating refund: $e");
      return null;
    }
  }
}

//
//
//
//
//
//
//

Future<void> savePhonePeData({
  required String orderId,
  required String userId,
}) async {
  const String url = "https://ambrosiaayurved.in/PaymentApi/save_phonepe_data";

  final body = {
    "order_id": orderId,
    "user_id": userId,
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print('Body : $body');
    if (response.statusCode == 200) {
      print("✅ PhonePe data saved successfully : ${response.body}");
      print(response.body);
    } else {
      print("❌ Failed to save PhonePe data: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  } catch (e) {
    print("🚨 Error saving PhonePe data: $e");
  }
}

class GlobalPaymentData {
  static String? merchantOrderId;
}

class PhonePeAuthToken {
  static String? authToken;
}
