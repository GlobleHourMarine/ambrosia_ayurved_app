// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/new_address/address_model.dart';

// class CheckoutService {
//   static const String apiUrl =
//       "https://ambrosiaayurved.in/api/save_checkout_information_api";

//   static Future<Map<String, dynamic>> saveCheckoutInfo(
//       CheckoutInfoModel data) async {
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(data.toJson()),
//       );

//       if (response.statusCode == 200) {
//         return jsonDecode(response.body);
//       } else {
//         return {
//           "status": "error",
//           "message": "Server error: ${response.statusCode}"
//         };
//       }
//     } catch (e) {
//       return {"status": "error", "message": e.toString()};
//     }
//   }
// }
