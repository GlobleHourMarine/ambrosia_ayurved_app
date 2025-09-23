import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ambrosia_ayurved/ambrosia/view/login&register/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ambrosia_ayurved/ambrosia/common_widgets/snackbar.dart';

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
  String? email;
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
    required String email,
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
        'email': email,
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
        this.email = email;
        this.address = address;
        this.district = district;
        this.city = city;
        this.state = state;
        this.mobile = mobile;
        this.country = country;
        this.pincode = pincode;
        this.address_type = address_type;

        _message = responseData['message'] ?? 'Address saved successfully';
        print("Success message: $_message");

        _isSuccess = true;
        _isLoading = false;
        notifyListeners();

        SnackbarMessage.showSnackbar(context, _message);
        return true;
      } else {
        print('save address api : ${response.body}');

        _message = 'Server error: ${response.statusCode}';
        print("HTTP error: $_message");
        SnackbarMessage.showSnackbar(context, _message);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _message = 'Error: $e';
      print('save address api : ${e}');
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
