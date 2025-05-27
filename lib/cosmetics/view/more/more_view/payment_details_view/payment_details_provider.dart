import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/payment_details_view/payment_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';

class PaymentDetailsProvider extends ChangeNotifier {
  List<Payment> paymentDetails = []; // Ensure it's always a list
  bool isLoading = false;

  Future<void> paymentDetailsView(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.id;

    isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://ambrosiaayurved.in/api/fetch_payment_data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);

        if (responseBody['status'] == 'success' &&
            responseBody['data'] != null &&
            responseBody['data'] is List) {
          // Convert list of JSON objects to List<Payment>
          paymentDetails = (responseBody['data'] as List)
              .map((item) => Payment.fromJson(item))
              .toList();
        } else {
          paymentDetails = []; // Ensure it's never null
          // SnackbarMessage.showSnackbar(context, 'No payment details found.');
        }
      } else {
        paymentDetails = [];
        SnackbarMessage.showSnackbar(
            context, 'Failed to fetch payment details.');
      }
    } catch (e) {
      print('Error: $e');
      paymentDetails = []; // Ensure it's never null on error
    }

    isLoading = false;
    notifyListeners();
  }
}
