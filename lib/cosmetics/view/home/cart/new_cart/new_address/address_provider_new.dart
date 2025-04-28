// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:ambrosia_ayurved/provider/user_provider.dart';
// import 'package:provider/provider.dart';

// class AddressProviderNew with ChangeNotifier {
//   // Controllers for the form
//   final TextEditingController fnameController = TextEditingController();
//   final TextEditingController lnameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();
//   final TextEditingController pincodeController = TextEditingController();

//   // State fields
//   bool isLoading = false;
//   bool isSuccess = false;
//   String message = '';

//   // Dispose controllers
//   void disposeControllers() {
//     fnameController.dispose();
//     lnameController.dispose();
//     emailController.dispose();
//     mobileController.dispose();
//     addressController.dispose();
//     cityController.dispose();
//     stateController.dispose();
//     countryController.dispose();
//     pincodeController.dispose();
//   }

//   // Submit form to API
//   Future<void> submitAddressForm(BuildContext context) async {
//     isLoading = true;
//     isSuccess = false;
//     message = '';
//     notifyListeners();

//     try {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       final userId = userProvider.id;
//       final productId =
//           '1'; // Assuming one product or static ID, change if needed

//       final url = Uri.parse(
//           'https://ambrosiaayurved.in/api/save_checkout_information_api');
//       final response = await http.post(
//         url,
//         body: {
//           'product_id': productId,
//           'user_id': userId,
//           'fname': fnameController.text.trim(),
//           'lname': lnameController.text.trim(),
//           'email': emailController.text.trim(),
//           'mobile': mobileController.text.trim(),
//           'address': addressController.text.trim(),
//           'city': cityController.text.trim(),
//           'state': stateController.text.trim(),
//           'country': countryController.text.trim(),
//           'pincode': pincodeController.text.trim(),
//         },
//       );

//       final data = json.decode(response.body);

//       if (data['status'] == "success") {
//         isSuccess = true;
//         message = data['message'] ?? 'Address submitted successfully';
//       } else {
//         isSuccess = false;
//         message = data['message'] ?? 'Submission failed';
//       }
//     } catch (e) {
//       isSuccess = false;
//       message = 'Something went wrong: $e';
//     }

//     isLoading = false;
//     notifyListeners();
//   }

//   // Optionally clear fields after success
//   void clearForm() {
//     fnameController.clear();
//     lnameController.clear();
//     emailController.clear();
//     mobileController.clear();
//     addressController.clear();
//     cityController.clear();
//     stateController.clear();
//     countryController.clear();
//     pincodeController.clear();
//   }
// }
