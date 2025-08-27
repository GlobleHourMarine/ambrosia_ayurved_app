// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_api_service.dart';
// import 'package:ambrosia_ayurved/cosmetics/view/more/more_view/order_history/order_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:ambrosia_ayurved/home/provider/user_provider.dart';
// import 'package:provider/provider.dart';

// class OrderProvider with ChangeNotifier {
//   List<Order> _orders = [];
//   bool _isLoading = false;

//   List<Order> get orders => _orders;
//   bool get isLoading => _isLoading;

//   Future<void> fetchOrders(BuildContext context) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       final response = await ApiService.getOrders(context);
//       _orders = response.map<Order>((json) => Order.fromJson(json)).toList();
//     } catch (error) {
//       print('Error fetching orders: $error');
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<bool> cancelOrder(
//       String orderId, String userId, BuildContext context) async {
//     final url = "https://ambrosiaayurved.in/api/cancel_order";
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final userId = userProvider.id;
//     print('userid: ${userId}');
//     print('orderid  : ${orderId}');
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "user_id": userId,
//           "order_id": orderId,
//         }),
//       );

//       final responseData = jsonDecode(response.body);
//       print(responseData);
//       if (response.statusCode == 200 && responseData["status"] == "success") {
//         print(responseData);
//         SnackbarMessage.showSnackbar(context, 'Order Cancelled Successfully');
//         return true; // Return success
//       } else {
//         print(responseData);

//         SnackbarMessage.showSnackbar(
//             context, 'Cancel request sent successfully');
//         return false; // Return failure
//       }
//     } catch (e) {
//       print(e);
//       SnackbarMessage.showSnackbar(context, '$e');
//       return false; // Return failure
//     }
//   }

// }
