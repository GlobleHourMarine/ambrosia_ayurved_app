import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/payment/payment_model.dart';
import 'package:ambrosia_ayurved/cosmetics/thankyou/thankyou.dart';
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/order_grandtotal_provider.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_provider.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  void _setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  String _selectedPaymentMethod = "UPI";
  String get selectedPaymentMethod => _selectedPaymentMethod;

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  Future<void> processPayment(BuildContext context, String orderId,
      {String? transactionId, String? screenshot}) async {
    _setProcessing(true);

    // Get user ID from UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.id;

    // Get grand total from GrandTotalProvider
    final grandTotalProvider =
        Provider.of<GrandTotalProvider>(context, listen: false);
    final double amount = grandTotalProvider.grandTotal;
    print('Grand total : ${amount}');
    // Get selected payment method from PaymentProvider
    final String paymentMethod =
        _selectedPaymentMethod; // Use the provider's stored value

    // Create PaymentDetails instance
    final paymentDetails = PaymentDetails(
      userId: userId,
      paymentMethod: paymentMethod,
      amount: amount,
      orderId: orderId,
      transactionId: transactionId,
      screenshot: screenshot,
    );

    final url = Uri.parse("https://ambrosiaayurved.in/api/payment_process");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(paymentDetails.toJson()),
      );

      if (response.statusCode == 200) {
        // SnackbarMessage.showSnackbar(context, "Payment Successful");
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          print('Payment Successful: ${response.body}');
          await Future.delayed(Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CheckoutMessageView(),
            ),
          );
        } else {
          print('Payment failed: ${responseData['message']}');
          SnackbarMessage.showSnackbar(context,
              responseData['message'] ?? "Unexpected error, payment failed");
        }
      }
    } catch (e) {
      print(e);
      //  SnackbarMessage.showSnackbar(context, "Error: ${e.toString()}");
    }

    _setProcessing(false);
  }
}
