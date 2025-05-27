import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RazorpayService {
  // Your Razorpay test credentials
  static const String keyId = 'rzp_test_J4DBKJFYTiyeCf';
  static const String keySecret = 'AAbHCSGlDA2T2ftj8EexinK9';

  late Razorpay _razorpay;

  // Initialize Razorpay instance
  void initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Clean up Razorpay instance
  void disposeRazorpay() {
    _razorpay.clear();
  }

  // Function pointer types for callbacks
  Function(PaymentSuccessResponse)? onPaymentSuccess;
  Function(PaymentFailureResponse)? onPaymentError;
  Function(ExternalWalletResponse)? onExternalWallet;

  // Open Razorpay payment form
  void startPayment({
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    String description = 'Order Payment',
  }) {
    var options = {
      'key': keyId,
      'amount': (amount * 100)
          .toInt(), // Amount in smallest currency unit (paise for INR)
      'name': 'Ambrosia Ayurved',
      'description': description,
      'prefill': {
        'contact': customerPhone,
        'email': customerEmail,
        'name': customerName,
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  // Payment success callback
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful: ${response.paymentId}",
      timeInSecForIosWeb: 4,
    );

    // Call the custom success handler if provided
    if (onPaymentSuccess != null) {
      onPaymentSuccess!(response);
    }

    print("Payment Success: ${response.paymentId}");
  }

  // Payment error callback
  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.message}",
      timeInSecForIosWeb: 4,
    );

    // Call the custom error handler if provided
    if (onPaymentError != null) {
      onPaymentError!(response);
    }

    print("Payment Error: ${response.code} - ${response.message}");
  }

  // External wallet callback
  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet Selected: ${response.walletName}",
      timeInSecForIosWeb: 4,
    );

    // Call the custom wallet handler if provided
    if (onExternalWallet != null) {
      onExternalWallet!(response);
    }

    print("External Wallet: ${response.walletName}");
  }
}
