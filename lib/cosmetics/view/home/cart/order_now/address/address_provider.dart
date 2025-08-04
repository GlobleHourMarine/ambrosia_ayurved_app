// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ambrosia_ayurved/cosmetics/view/home/cart/order_now/address/address_model.dart';
// import 'package:ambrosia_ayurved/provider/user_provider.dart';
// import 'package:provider/provider.dart';

// class AddressProvider with ChangeNotifier {
//   bool _isLoading = false;
//   String _message = '';
//   AddressModel? _address;

//   bool get isLoading => _isLoading;
//   String get message => _message;
//   AddressModel? get address => _address;

//   Future<void> updateAddress(BuildContext context, String newAddress) async {
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     final userId = userProvider.id; // Assuming userId is stored in UserProvider

//     final url = Uri.parse("https://ambrosiaayurved.in/api/update_address");
//     final addressData = AddressModel(userId: userId, address: newAddress);
//     final body = jsonEncode(addressData.toJson());

//     try {
//       _isLoading = true;
//       _message = '';
//       notifyListeners();

//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: body,
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200 && responseData["status"] == "success") {
//         _message = responseData["message"];
//         _address = addressData; // Update the stored address
//         print(body);
//       } else {
//         _message = responseData["message"] ?? "Failed to update address";
//       }
//     } catch (error) {
//       _message = "An error occurred. Please try again.";
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }

//

/*
// working  one : 
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/cosmetics/view/home/cart/new_cart/provider.dart';
import 'package:ambrosia_ayurved/models/user_model.dart';
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';

class AddressProvider with ChangeNotifier {
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;

  // Getter methods
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get isSuccess => _isSuccess;

  // Address details
  String? fname;
  String? lname;
  String? email;
  String? address;
  String? city;
  String? state;
  String? mobile;
  String? country;
  String? pincode;

  // Method to save checkout address information
  Future<bool> saveCheckoutInformation({
    required String productId,
    required String userId,
    required String fname,
    required String lname,
    required String email,
    required String address,
    required String city,
    required String state,
    required String mobile,
    required String country,
    required String pincode,
    BuildContext? context,
  }) async {
    _isLoading = true;
    _message = '';
    _isSuccess = false;
    notifyListeners();
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final userId = userProvider.id;
    // final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // for (var item in cartProvider.cartItems) {
    //   final productId = item.productId;
    // }

    try {
      // API endpoint
      final String apiUrl =
          'https://ambrosiaayurved.in/api/save_checkout_information_api';

      // Request body
      final Map<String, dynamic> requestBody = {
        'product_id': productId,
        'user_id': userId,
        'fname': fname,
        'lname': lname,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'mobile': mobile,
        'country': country,
        'pincode': pincode,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Parse response
      // final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        //  Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseData.containsKey('message') &&
            responseData['message'] ==
                'Checkout information saved successfully.') {
          // Save address details
          this.fname = fname;
          this.lname = lname;
          this.email = email;
          this.address = address;
          this.city = city;
          this.state = state;
          this.mobile = mobile;
          this.country = country;
          this.pincode = pincode;

          _message = responseData['message'] ?? 'Address saved successfully';
          print(_message);
          SnackbarMessage.showSnackbar(context!, '$_message');
          _isSuccess = true;
          _isLoading = false;
          notifyListeners();

          //         User user = User.fromJson(responseData['data'][0]);
          // // Set the user in the UserProvider
          // final userProvider =
          //     Provider.of<UserProvider>(context!, listen: false);
          // userProvider.setUser(user);

          // // Save the user data to shared_preferences
          // await userProvider.saveUserData(user);
          return true;
        }
        //  else if {
        //   if (responseData.containsKey('message') &&
        //   responseData['message'] == 'Checkout information saved successfully.') {

        //   // Extract the user_id from the response
        //   String userIdfromResponse = responseData['user_id'].toString();
        //   // Fix: Properly extract the first item from the list
        //    //  Map<String, dynamic> itemData = responseData['data'][0];

        //   // Set user_id in the UserProvider
        //   final userProvider =
        //       Provider.of<UserProvider>(context, listen: false);
        //   userProvider
        //       .setid(userIdfromResponse); // Update user_id in the provider
        //   print('User Id from api =   $userIdfromResponse');

        //   }

        //  }

        else {
          _message = responseData['message'] ?? 'Failed to save address';
          SnackbarMessage.showSnackbar(context!, '$_message');
          print(_message);
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }
    } catch (e) {
      _message = 'Error: $e';
      SnackbarMessage.showSnackbar(context!, '$_message');
      print(_message);
      _isLoading = false;
      notifyListeners();
      return false;
    }
    throw Exception('error');
  }

  // Reset state
  void reset() {
    _isLoading = false;
    _message = '';
    _isSuccess = false;
    notifyListeners();
  }
}
*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/cosmetics/common_widgets/snackbar.dart';

class AddressProvider with ChangeNotifier {
  bool _isLoading = false;
  String _message = '';
  bool _isSuccess = false;

  // Getter methods
  bool get isLoading => _isLoading;
  String get message => _message;
  bool get isSuccess => _isSuccess;

  // Address details
  String? userid;
  String? fname;
  String? lname;
  String? district;
  String? address;
  String? city;
  String? state;
  String? mobile;
  String? country;
  String? pincode;
  String? address_type;

  // Method to save address information
  Future<bool> saveCheckoutInformation({
    required String userid,
    required String fname,
    required String lname,
    required String district,
    required String address,
    required String city,
    required String state,
    required String mobile,
    required String country,
    required String pincode,
    required String address_type,
    required BuildContext context,
  }) async {
    try {
      _isLoading = true;
      _message = '';
      _isSuccess = false;
      notifyListeners();

      // Get user ID from UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userid = userProvider.id;

      print("Using user ID from provider: $userid");

      // API endpoint
      final String apiUrl =
          'https://ambrosiaayurved.in/api/add_multiple_address';

      // Request body
      final Map<String, dynamic> requestBody = {
        //

        'user_id': userid,
        'fname': fname,
        'lname': lname,
        'address': address,
        'city': city,
        'state': state,
        "district": district,
        "address_type": address_type,
        'mobile': mobile,
        'country': country,
        'pincode': pincode,
      };

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Handle response
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print("Response data: $responseData");
        this.userid = userid;
        // Save address details locally
        this.fname = fname;
        this.lname = lname;
        this.address = address;
        this.district = district;
        this.city = city;
        this.state = state;
        this.mobile = mobile;
        this.country = country;
        this.pincode = pincode;
        this.address_type = address_type;

        // Set success message from response or default
        _message = responseData['message'] ?? 'Address saved successfully';
        print("Success message: $_message");

        // Set success and clear loading state
        _isSuccess = true;
        _isLoading = false;
        notifyListeners();

        // Show success message
        SnackbarMessage.showSnackbar(context, _message);
        return true;
      } else {
        // Handle non-200 status codes
        _message = 'Server error: ${response.statusCode}';
        print("HTTP error: $_message");
        SnackbarMessage.showSnackbar(context, _message);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _message = 'Error: $e';
      print("Exception caught: $_message");
      SnackbarMessage.showSnackbar(context, _message);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset state
  void reset() {
    _isLoading = false;
    _message = '';
    _isSuccess = false;
    notifyListeners();
  }
}
